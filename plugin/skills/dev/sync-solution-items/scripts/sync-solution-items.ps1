<#
.SYNOPSIS
    Mirrors the files under docs/ into the Solution Items of a .slnx solution.

.DESCRIPTION
    Adds a <File> entry for every file under docs/ that the solution does not
    list yet, creates the <Folder> nodes it needs along the way, and removes
    entries whose file no longer exists on disk.

    Only the XML-based .slnx format is supported. A classic .sln stores solution
    folders as GUID-keyed project stanzas; rewriting that mechanically is a
    different job and this script refuses it rather than corrupting it.

.PARAMETER RepoRoot
    Repository root. Defaults to the git top level of the current directory.

.PARAMETER SolutionPath
    Explicit .slnx to update. Required only when the root holds more than one.

.PARAMETER DocsDir
    Directory to mirror, relative to RepoRoot. Defaults to 'docs'.

.PARAMETER DryRun
    Report what would change and leave the solution untouched.

.OUTPUTS
    Exit code 0 on success and on every no-op (no solution, no docs directory,
    classic .sln). Non-zero only on a real error.
#>
[CmdletBinding()]
param(
    [string]$RepoRoot,
    [string]$SolutionPath,
    [string]$DocsDir = 'docs',
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

# Files that are never solution items even when they sit under docs/. Names
# starting with '_' or '.' are excluded as well — see the filter below.
$ExcludedSegment = '00_Archive'
$JunkNames = @('.DS_Store', 'Thumbs.db', 'desktop.ini')

# --- locate repo, solution and docs ------------------------------------------

if (-not $RepoRoot) {
    $RepoRoot = git rev-parse --show-toplevel 2>$null
    if (-not $RepoRoot) { $RepoRoot = (Get-Location).Path }
}
# Get-Item, not Resolve-Path: Resolve-Path preserves 8.3 short names ("MAXIMI~1")
# while Get-ChildItem reports children in long form, and the two lengths must
# match for the relative-path arithmetic below.
$RepoRoot = (Get-Item -LiteralPath $RepoRoot).FullName.TrimEnd('\')

if (-not $SolutionPath) {
    $found = @(Get-ChildItem -LiteralPath $RepoRoot -Filter '*.slnx' -File)
    if ($found.Count -eq 0) {
        $classic = @(Get-ChildItem -LiteralPath $RepoRoot -Filter '*.sln' -File)
        if ($classic.Count -gt 0) {
            Write-Host "UEBERSPRUNGEN: $($classic[0].Name) ist eine klassische .sln. Dieses Skript unterstuetzt nur .slnx — Solution Items bitte in Visual Studio pflegen."
            exit 0
        }
        Write-Host "UEBERSPRUNGEN: keine Solution in $RepoRoot — nichts zu spiegeln."
        exit 0
    }
    if ($found.Count -gt 1) {
        throw "Mehrere .slnx in $RepoRoot gefunden ($($found.Name -join ', ')). Ziel mit -SolutionPath angeben."
    }
    $SolutionPath = $found[0].FullName
}
$SolutionPath = (Resolve-Path -LiteralPath $SolutionPath).Path

$docsPath = Join-Path $RepoRoot $DocsDir
if (-not (Test-Path -LiteralPath $docsPath)) {
    Write-Host "UEBERSPRUNGEN: $DocsDir/ existiert nicht in $RepoRoot."
    exit 0
}

# --- what is on disk ----------------------------------------------------------

$sep = [IO.Path]::DirectorySeparatorChar
$onDisk = @(
    Get-ChildItem -LiteralPath $docsPath -Recurse -File |
        Where-Object { $_.FullName.Split($sep) -notcontains $ExcludedSegment } |
        Where-Object { $JunkNames -notcontains $_.Name -and $_.Name -notlike '~$*' } |
        Where-Object {
            # Dot- and underscore-prefixed names are tooling, not documents:
            # docs/_generator/, docs/.gitignore. The check runs over every path
            # segment below docs/, so a generator directory takes its whole
            # contents with it however the files inside are named.
            $rel = $_.FullName.Substring($docsPath.Length).TrimStart($sep)
            -not @($rel.Split($sep) | Where-Object { $_.StartsWith('_') -or $_.StartsWith('.') })
        } |
        ForEach-Object {
            if (-not $_.FullName.StartsWith("$RepoRoot$sep", [StringComparison]::OrdinalIgnoreCase)) {
                throw "Pfad liegt nicht unter dem Repo-Root: $($_.FullName) (Root: $RepoRoot). Abbruch statt falsche Eintraege zu schreiben."
            }
            $_.FullName.Substring($RepoRoot.Length + 1).Replace('\', '/')
        }
)

# --- drop what git ignores ----------------------------------------------------

# Build artefacts and generated intermediates sit under docs/ but are not repo
# content — listing them shows every developer a file that is not in the repo.
# git itself is asked rather than re-implementing .gitignore matching: nested
# ignore files, negations and the global excludes all come for free. No git, no
# repo, or a git that fails: the filter is skipped rather than guessed at.
if ($onDisk.Count -gt 0 -and (Get-Command git -ErrorAction SilentlyContinue)) {
    # The trailing LF is load-bearing: PowerShell appends CRLF to a string piped
    # into a native program, and without it the last path reaches git as
    # "docs/x.md`r" and never matches.
    $ignoredOutput = (($onDisk -join "`n") + "`n") | & git -C $RepoRoot check-ignore --stdin 2>$null
    # 0 = some path is ignored, 1 = none are. Anything else (128: not a repo)
    # means the answer is unusable and nothing gets filtered.
    if ($LASTEXITCODE -le 1) {
        $ignored = @{}
        foreach ($line in @($ignoredOutput)) {
            if ($line) { $ignored[$line.Replace([char]92, '/')] = $true }
        }
        if ($ignored.Count -gt 0) {
            $onDisk = @($onDisk | Where-Object { -not $ignored.ContainsKey($_) })
            Write-Host "  (uebersprungen: $($ignored.Count) von git ignorierte Datei(en))"
        }
    }
}

# --- load the solution --------------------------------------------------------

$rawBytes = [IO.File]::ReadAllBytes($SolutionPath)
$rawText = [Text.Encoding]::UTF8.GetString($rawBytes)
$hadBom = $rawBytes.Length -ge 3 -and $rawBytes[0] -eq 0xEF -and $rawBytes[1] -eq 0xBB -and $rawBytes[2] -eq 0xBF
$newLine = if ($rawText.Contains("`r`n")) { "`r`n" } else { "`n" }
$trailingNewline = $rawText.EndsWith("`n")

$xml = New-Object System.Xml.XmlDocument
$xml.PreserveWhitespace = $false
$xml.Load($SolutionPath)
$root = $xml.DocumentElement

$docsPrefix = "$DocsDir/"
$folderPrefix = "/$DocsDir/"

function Get-DocsFolderNodes {
    @($root.SelectNodes('Folder')) | Where-Object { $_.GetAttribute('Name').StartsWith($folderPrefix) }
}

function Resolve-FolderNode([string]$folderName) {
    $existing = @(Get-DocsFolderNodes) | Where-Object { $_.GetAttribute('Name') -eq $folderName } | Select-Object -First 1
    if ($existing) { return $existing }

    $node = $xml.CreateElement('Folder')
    $node.SetAttribute('Name', $folderName)

    # Keep the docs folder block in name order; a sorted list also guarantees
    # that a parent folder precedes the children it was created for.
    $successor = @(Get-DocsFolderNodes) |
        Where-Object { [string]::Compare($_.GetAttribute('Name'), $folderName, [StringComparison]::OrdinalIgnoreCase) -gt 0 } |
        Select-Object -First 1

    if ($successor) {
        [void]$root.InsertBefore($node, $successor)
    }
    else {
        $last = @(Get-DocsFolderNodes) | Select-Object -Last 1
        if ($last) { [void]$root.InsertAfter($node, $last) }
        else {
            $firstProject = $root.SelectSingleNode('Project')
            if ($firstProject) { [void]$root.InsertBefore($node, $firstProject) }
            else { [void]$root.AppendChild($node) }
        }
    }
    $script:createdFolders += $folderName
    return $node
}

# --- add what is missing ------------------------------------------------------

$listed = @{}
foreach ($f in @($root.SelectNodes('Folder/File'))) {
    $listed[$f.GetAttribute('Path')] = $f
}

$script:createdFolders = @()
$added = @()

foreach ($relPath in ($onDisk | Sort-Object)) {
    if ($listed.ContainsKey($relPath)) { continue }

    $folderName = $folderPrefix + (($relPath.Substring($docsPrefix.Length) -split '/' | Select-Object -SkipLast 1) -join '/')
    if (-not $folderName.EndsWith('/')) { $folderName += '/' }

    # Visual Studio emits every ancestor folder, so create the whole chain.
    $segments = @($folderName.Trim('/') -split '/')
    for ($i = 1; $i -le $segments.Count; $i++) {
        [void](Resolve-FolderNode ('/' + (($segments | Select-Object -First $i) -join '/') + '/'))
    }

    $fileNode = $xml.CreateElement('File')
    $fileNode.SetAttribute('Path', $relPath)
    [void](Resolve-FolderNode $folderName).AppendChild($fileNode)
    $added += $relPath
}

# --- drop entries whose file is gone -----------------------------------------

$removed = @()
foreach ($fileNode in @($root.SelectNodes('Folder/File'))) {
    $p = $fileNode.GetAttribute('Path')
    if (-not $p.StartsWith($docsPrefix)) { continue }
    if (Test-Path -LiteralPath (Join-Path $RepoRoot ($p.Replace('/', '\')))) { continue }
    [void]$fileNode.ParentNode.RemoveChild($fileNode)
    $removed += $p
}

# --- report and save ----------------------------------------------------------

foreach ($p in $added) { Write-Host "  + $p" }
foreach ($p in $removed) { Write-Host "  - $p" }

if ($added.Count -eq 0 -and $removed.Count -eq 0) {
    Write-Host "Solution Items sind aktuell — $($onDisk.Count) Datei(en) unter $DocsDir/ gespiegelt, nichts zu tun."
    exit 0
}

if ($DryRun) {
    Write-Host "DryRun: $($added.Count) hinzuzufuegen, $($removed.Count) zu entfernen — $([IO.Path]::GetFileName($SolutionPath)) nicht geaendert."
    exit 0
}

$settings = New-Object System.Xml.XmlWriterSettings
$settings.Indent = $true
$settings.IndentChars = '  '
$settings.OmitXmlDeclaration = $true
# Keep the file's own line endings and BOM. Writing CRLF into an LF file turns
# a two-line change into a whole-file diff.
$settings.NewLineChars = $newLine
$settings.Encoding = New-Object System.Text.UTF8Encoding($hadBom)

$writer = [System.Xml.XmlWriter]::Create($SolutionPath, $settings)
try { $xml.Save($writer) } finally { $writer.Dispose() }
if ($trailingNewline) { [IO.File]::AppendAllText($SolutionPath, $newLine) }

Write-Host "$([IO.Path]::GetFileName($SolutionPath)) aktualisiert: $($added.Count) hinzugefuegt, $($removed.Count) entfernt, $($script:createdFolders.Count) Ordner angelegt."
# Explicit, like every other way out: git check-ignore leaves $LASTEXITCODE at 1
# when nothing is ignored, and a caller using '&' would read that as failure.
exit 0
