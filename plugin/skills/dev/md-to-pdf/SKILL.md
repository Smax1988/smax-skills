---
name: md-to-pdf
description: Converts Markdown files to PDF. Use this skill whenever one or more .md files should be turned into a PDF. Triggers on "PDF aus dieser Markdown-Datei", "Doku als PDF exportieren", "README in PDF konvertieren", "md to pdf", "Markdown drucken/exportieren", or similar requests.
argument-hint: <file.md> [more.md ...]
allowed-tools: Bash, PowerShell, Glob, Read
---

# Markdown → PDF

Converts `.md` files to PDF using the bundled batch script.

## Target path

- The target directory is **`C:\Temp`** — regardless of the current working
  directory. `docs/foo.md` becomes `C:\Temp\foo.pdf`. The PDF is a generated
  artifact, not source: it does not belong in the repo and has no business in a
  commit. The same rule applies to `smax:handoff` and `smax:replicate`.
- If `C:\Temp` does not exist, the batch script creates it.
- Same name as the source, extension `.pdf`. **An existing file is
  overwritten** — a freshly generated PDF of the same source should replace the
  old one, not sit next to it. To keep a version, copy it away beforehand.
- `md-to-pdf` itself has no target option; the batch script generates the PDF
  next to the source and moves it immediately. Nothing is left behind in the
  project directory. If the move fails, the script reports it and leaves the PDF
  next to the source instead of quietly pretending to be done.

Usable on Windows only (cmd.exe batch). On Linux/macOS call
`npx md-to-pdf <file.md>` directly instead.

## Invocation

`MDTOPDF_RUNNING` **must** be set. Without the variable the script restarts
itself via `cmd /k` in a new window that stays open — that is meant for a
double-click in Explorer and would block here until the tool call runs into its
timeout.

PowerShell:

```powershell
$env:MDTOPDF_RUNNING = "1"; & "<skill-dir>\scripts\md-to-pdf.bat" "C:\path\file.md"
```

Several files in one run — just append them:

```powershell
$env:MDTOPDF_RUNNING = "1"; & "<skill-dir>\scripts\md-to-pdf.bat" "a.md" "b.md" "c.md"
```

`<skill-dir>` is the directory of this `SKILL.md`.

The first run on a machine takes longer: `npx` pulls `md-to-pdf` along with
Puppeteer/Chromium. Set a generous timeout (at least 300000 ms).

## Procedure

1. **Determine the files.** If paths are named, take those. If only a folder or
   a pattern is named, resolve it with `Glob` and briefly name the list of
   matches before converting.
2. **Check the paths.** Use absolute paths, quote paths containing spaces. If a
   file does not exist, report it instead of guessing.
3. **Convert** as above.
4. **Verify the result.** Check that `C:\Temp\<name>.pdf` exists and is larger
   than 0 bytes — the batch script reports "Fertig!" even when
   `npx md-to-pdf` failed for a single file. Only then report success, naming
   the generated paths under `C:\Temp`.

## Styling

The batch script passes no options through. If a custom stylesheet, page format
or margins are required, call `npx md-to-pdf` directly — and then move the PDF
to `C:\Temp` yourself, because the direct call puts it next to the source:

```powershell
npx md-to-pdf --stylesheet "style.css" --pdf-options '{"format":"A4","margin":"20mm"}' "file.md"
Move-Item "file.pdf" "C:\Temp\file.pdf" -Force
```

Alternatively, frontmatter in the `.md` file itself controls the output
(`stylesheet`, `pdf_options`, `body_class`).
