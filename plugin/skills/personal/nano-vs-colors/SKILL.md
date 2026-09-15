---
name: nano-vs-colors
description: Installs Visual-Studio-Dark+ syntax highlighting for GNU nano running under Git Bash on Windows. Use whenever the user wants colored/syntax-highlighted code in Git-Bash nano, an IDE-like color scheme in nano, or asks to set up / fix / copy their nano coloring — including for C#, PowerShell, XML, XAML, SCSS, Batch, Razor/Blazor, TypeScript, Go, JSON, JavaScript, HTML and CSS. Trigger on phrases like "nano farben", "nano syntax highlighting", "nano color scheme", "VS colors in nano", or moving this setup to another machine.
disable-model-invocation: true
---

# nano VS Dark+ colors (Git Bash)

Deploys an IDE-like (Visual Studio *Dark+*) color scheme to GNU nano on Git Bash. It ships two things:

- `assets/nano/*.nanorc` — nine custom syntaxes nano lacks out of the box: **C#, PowerShell, XML, XAML, SCSS, Batch, Razor/Blazor, TypeScript, Go**.
- `assets/nanorc` — the main config. It loads those files **and** recolors nano's built-in **json / javascript / html / css** to the same palette, so every language looks consistent.

Palette: comment `#6a5` · keyword `#59c` · control-flow `#c8c` · type `#4cb` · function `#dda` · variable `#9df` · number `#bca` · string `#c97`.

## Requirements

nano **≥ 5.0** (the palette uses hex colors, added in 5.0). Check with `nano --version`; if older, warn the user that colors won't apply. The config self-loads `/usr/share/nano/*.nanorc`, so it works even if the machine's `/etc/nanorc` is bare.

## Where the files go

Everything lives in the user's home directory, which on Git Bash is `C:\Users\<name>` — shown as `/c/Users/<name>` inside the shell. Confirm it with `echo $HOME`.

- The nine syntax files → `~/.nano/` (create the folder if missing).
- The main config → `~/.nanorc`.

The bundled `~/.nanorc` uses `include "~/.nano/*.nanorc"`; nano expands the `~`, so nothing needs editing per machine.

## Installing

First always place the syntax files (this part is the same in every case):

```
mkdir -p ~/.nano
cp <skill>/assets/nano/*.nanorc ~/.nano/
```

Then handle `~/.nanorc` depending on what's already there — check with `ls -la ~/.nanorc`:

**Case A — no `~/.nanorc` yet** (most common): just drop the bundled one in.

```
cp <skill>/assets/nanorc ~/.nanorc
```

**Case B — a `~/.nanorc` already exists**: don't clobber it blindly. Back it up first (`cp ~/.nanorc ~/.nanorc.bak`), show the user what's in theirs, and pick one:

- If it's just nano's default sample / nothing they care about → replace it as in Case A.
- If they have their own settings to keep → **merge**: append the two `include` lines and the entire `extendsyntax` block from `assets/nanorc` to their file. Those are the parts that do the highlighting. Skip any `set …` lines that duplicate settings they already have, to avoid surprises.

## Verifying

Open any code file, e.g. `nano <something>.ps1`, and confirm colors appear (cmdlets/functions yellow, `$variables` light-blue, strings orange, comments green). For a non-interactive check, this prints nothing on success and lists file+line on any config error:

```
printf 'x\n' > /tmp/t.cs && nano /tmp/t.cs </dev/null 2>&1 | tr '\r' '\n' | grep -iE "error in|not understood|no syntax|not allowed"; rm -f /tmp/t.cs
```

## Good to know (if you adapt the files)

Two nano quirks that constrain the design:

- **`extendsyntax` only works in a top-level rcfile**, never in an `include`d file (nano errors "not allowed in included file"). That's why the built-in recoloring lives directly in `~/.nanorc` and not in a file under `~/.nano/`.
- **Hex colors** (`#rgb`) are valid inside `color`/`extendsyntax` rules and are *not* mistaken for comments there. Change a color by editing its `#rgb` value; nano maps it to the nearest of the 256-color palette.

The highlighting is regex/line-based, not a real parser — ~95% matches VS, but edge cases exist (a PascalCase variable colored like a type; `//` inside a string URL colored as a comment). That's nano's ceiling.
