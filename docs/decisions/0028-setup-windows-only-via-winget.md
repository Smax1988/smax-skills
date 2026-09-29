# The setup skill supports Windows only and installs via winget

`smax:setup` checks and installs the plugin's requirements on Windows and on
nothing else. On any other platform it stops at the first step and says so. It
installs missing software with `winget`, and MCP servers with
`claude mcp add --scope user`. **Every installation is confirmed first**,
individually by number, and nothing is ever uninstalled.

**Why Windows only, in a public repo:** the plugin itself is not portable, so a
portable setup would promise more than the skills deliver. `md-to-pdf` runs a
`.bat`, `handoff`, `replicate`, `mail-draft` and `md-to-pdf` write to
`C:\Temp`, and `sync-solution-items` handles `.slnx` files with Windows path
separators. Supporting macOS or Linux in the setup skill alone would install
tools for skills that then fail anyway. A port starts with the skills, not with
the setup.

**Why winget rather than only printing commands:** winget ships with Windows 11,
and every current requirement has a package ID. A setup that only prints commands
leaves the user to do the actual work. The confirmation per installation is what
keeps it from acting silently.

**Consequence:** a colleague on a Mac gets a clear refusal instead of a
half-working install. If the plugin ever becomes portable, this decision is
superseded together with the Windows paths in the skills. It is not revised on
its own.
