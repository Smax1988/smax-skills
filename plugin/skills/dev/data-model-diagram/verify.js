// Verification for a data-model diagram page. Paste the whole function into
// mcp__playwright__browser_evaluate. Needs a real browser over http:// —
// the file: protocol is blocked in Playwright.
//
// Returns {ok, surfaces, findings}. ok === true means every check passed.
// Set EXPECT to the number of wire objects per surface before running, or the
// count check cannot fail. A favicon.ico 404 in the console is normal; read
// the console separately, this script does not see it.
() => {
  const EXPECT = {};            // e.g. {wires1: 8, wires2: 9}

  const findings = [];
  const surfaces = [];
  const add = (check, detail) => findings.push({check, ...detail});

  for (const svg of document.querySelectorAll('svg.wires')) {
    const id = svg.id;
    const host = svg.parentNode.getBoundingClientRect();
    // :scope > path — a plain 'path' also catches the paths inside the markers.
    const paths = [...svg.querySelectorAll(':scope > path')];
    const texts = [...svg.querySelectorAll(':scope > text')];
    surfaces.push({id, paths: paths.length, labels: texts.length,
                   expected: EXPECT[id] ?? null});

    if (EXPECT[id] != null && EXPECT[id] !== paths.length)
      add('edge count', {surface: id, drawn: paths.length, defined: EXPECT[id]});

    const cards = [...document.querySelectorAll('details.tbl')].map(c => {
      const r = c.getBoundingClientRect();
      return {id: c.id, x: r.left - host.left, y: r.top - host.top,
              w: r.width, h: r.height};
    });

    paths.forEach((p, i) => {
      const d = p.getAttribute('d') || '';
      // A valid route is M/L plus numbers. Anything else means a value was
      // concatenated as a string instead of added as a number.
      if (/NaN/.test(d) || /[^ML\d.\s-]/.test(d))
        add('malformed path', {surface: id, wire: i, d: d.slice(0, 80)});

      const m = /url\(#(.+)\)/.exec(p.getAttribute('marker-end') || '');
      if (!m) add('no arrowhead', {surface: id, wire: i});
      else if (!document.getElementById(m[1]))
        add('arrowhead does not resolve', {surface: id, wire: i, marker: m[1]});

      // The connector layer sits behind the grid, so an edge crossing a card is
      // drawn and invisible — and passes every other check here.
      // Skip the first and last 26px: those legitimately touch source and target.
      let L = 0;
      try { L = p.getTotalLength(); } catch (e) { L = 0; }
      const hit = new Set();
      for (let s = 26; s < L - 26; s += 6) {
        const q = p.getPointAtLength(s);
        for (const c of cards)
          if (q.x > c.x + 2 && q.x < c.x + c.w - 2 &&
              q.y > c.y + 2 && q.y < c.y + c.h - 2) hit.add(c.id);
      }
      if (hit.size)
        add('wire hidden behind card', {surface: id, wire: i, cards: [...hit],
             fix: 'route via other sides, or stagger fo/qo and bend'});
    });

    for (const t of texts) {
      const x = +t.getAttribute('x'), y = +t.getAttribute('y');
      if (!isFinite(x) || !isFinite(y) ||
          x < 0 || y < 0 || x > host.width || y > host.height)
        add('label outside the drawing surface',
            {surface: id, text: t.textContent, x, y});
    }
  }

  // A card's column list must not render while the card is collapsed.
  for (const c of document.querySelectorAll('details.tbl:not([open]) .cols'))
    if (c.getBoundingClientRect().height > 0)
      add('column list visible while collapsed',
          {card: c.closest('details.tbl').id,
           fix: '.tbl:not([open]) .cols{display:none}'});

  // Every drawing surface needs its own marker ids.
  const ids = [...document.querySelectorAll('marker')].map(m => m.id);
  const dupes = ids.filter((v, i) => ids.indexOf(v) !== i);
  if (dupes.length) add('duplicate marker ids', {ids: [...new Set(dupes)]});

  return {ok: findings.length === 0, surfaces, findings};
}
