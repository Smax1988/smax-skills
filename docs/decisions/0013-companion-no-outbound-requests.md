# The brainstorming companion makes no outbound requests

`brainstorming/scripts/server.cjs` is trimmed against upstream by the remote
logo and its telemetry env vars. Upstream's `renderBrand()` loads an image from
`https://primeradiant.com/brand/...png` with the superpowers version in the
query string — once per page view. The only way to switch it off was
`SUPERPOWERS_DISABLE_TELEMETRY` or `DISABLE_TELEMETRY`.

**Why it was removed:** a query string carrying a version number that goes to a
foreign host on every page view is a beacon, regardless of how it is meant. The
companion runs locally during a design session and has no reason to speak
outward. An opt-out you have to know about is no substitute for "does not do it
in the first place".

**Replaced by:** a plain text mark, no image reference. The comment in place
names the reason, so the line does not get pulled back in by accident during an
upstream comparison.

**Consequence for the upstream comparison:** `server.cjs` will show a conflict in
exactly this block on every update. That is expected — the trim is to be kept,
see [[0001-superpowers-vendored-not-dependency]].
