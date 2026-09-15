<#
.SYNOPSIS
  Assembles C:\Temp\MAIL-<Name>.html from the page template and opens it.

.DESCRIPTION
  Takes the subject as a string and the mail body as a file holding an HTML
  fragment (p / strong / em / ul / ol / li / a / br only). Writes the finished
  page as UTF-8 without BOM and prints the resulting path.

.EXAMPLE
  .\new-mail.ps1 -Name angebot-wartung -Subject 'Angebot Wartung 2027' -BodyPath C:\Temp\body.html
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$Name,
    [Parameter(Mandatory)][string]$Subject,
    [Parameter(Mandatory)][string]$BodyPath,
    [switch]$NoOpen
)

$ErrorActionPreference = 'Stop'

if ($Name -notmatch '^[a-z0-9]+(-[a-z0-9]+)*$') {
    throw "Name must be lower-case kebab-case ASCII, got: $Name"
}
if (-not (Test-Path -LiteralPath $BodyPath -PathType Leaf)) {
    throw "Body file not found: $BodyPath"
}

$templatePath = Join-Path $PSScriptRoot '..\assets\page-template.html'
if (-not (Test-Path -LiteralPath $templatePath -PathType Leaf)) {
    throw "Page template not found: $templatePath"
}

$template = Get-Content -LiteralPath $templatePath -Raw -Encoding UTF8
$body     = (Get-Content -LiteralPath $BodyPath -Raw -Encoding UTF8).Trim()

if ([string]::IsNullOrWhiteSpace($body)) {
    throw "Body file is empty: $BodyPath"
}

$escapedSubject = $Subject.Replace('&', '&amp;').Replace('<', '&lt;').Replace('>', '&gt;')

$html = $template.Replace('{{SUBJECT}}', $escapedSubject).Replace('{{BODY}}', $body)

$targetDir = 'C:\Temp'
if (-not (Test-Path -LiteralPath $targetDir -PathType Container)) {
    New-Item -ItemType Directory -Force -Path $targetDir | Out-Null
}

$outPath = Join-Path $targetDir "MAIL-$Name.html"
[System.IO.File]::WriteAllText($outPath, $html, (New-Object System.Text.UTF8Encoding($false)))

if (-not $NoOpen) {
    Start-Process -FilePath $outPath
}

Write-Output $outPath
