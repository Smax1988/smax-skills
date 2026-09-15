---
name: data-model-diagram
description: Use when a database schema or data model should be drawn — tables, columns, keys and relationships as a standalone interactive HTML page. Triggers on "Datenmodell zeichnen/visualisieren", "ERD", "Entity-Relationship-Diagramm", "Tabellendiagramm", "Schema als Grafik", "database schema diagram". Not for topic infographics (that is infographic-page), not for Mermaid/PlantUML source, not for dashboards over real datasets.
argument-hint: <model source (spec, DDL, schema)> [target path]
disable-model-invocation: true
---

# Data Model Diagram

## Overview

One self-contained `.html` file — no CDN, no framework, everything inline. Table cards sit in a CSS grid; a rigid SVG layer draws the relationships. **Collapsed is the reading state**: a card shows its name, one note and its keys; you open one card briefly to look a column up.

**Start from [template.html](template.html).** A working, browser-verified skeleton: two zones, all five card variants, eight wires. Copy it, replace the content, keep the CSS and the script. Do not rebuild the layout engine.

**Not this skill:** `infographic-page` (topic explainer, dark-luxury design), Mermaid/PlantUML source, dashboards over real data.

## Procedure

1. **Ask what is missing.** Never assume: the target path (the diagram belongs next to its source document, not in `C:\Temp`), the model source, and the **zone split**. Zones are a subject-matter decision — which tables belong together and what the group is called. Do not invent them.
2. **Derive the model.** Tables and columns from the source; edge candidates from foreign keys (`sys.foreign_keys`, DDL) where a database exists. **Derived content gets cross-checked by a second, independent agent** before it goes in — on the reference model that check found ten defects including two missing tables. Iterate until the checker is quiet.
3. **Fill in the cards.** One `<details class="tbl">` per table, id `t-<name>`.
4. **Write the wires.** Derivation gives you `from`/`to` and the multiplicities. Sides, offsets and bends are hand work — see below.
5. **Verify in the browser, then clean up.** Mandatory, not optional. See Verification.

Visible strings in the template are German. Match the language of the source document instead if it is not.

## Card variants

| Class | For | Look |
|---|---|---|
| (none) | new table | solid |
| `anchor` | the table the zone revolves around | blue, filled |
| `legacy` | existing table, only the relevant columns | dashed |
| `lookup` | value list | dashed |
| `link` | pure junction table, no payload columns | pale border |

**The anchor is the table every other card in the zone connects to.** If two tables compete for it, the zone is probably two zones. A table may appear in a second zone: different id, a note saying it is the same table — and `anchor` **only if it is that zone's pivot too**. Applied blindly the rule gives a zone three blue cards and no centre.

Each card carries: name, badge, **one note naming the thing about the table that is not obvious**, the short form (keys), and the full column list. Key markers: PK ochre, FK blue, lookup green, reference-without-FK violet, rowversion grey. The badge is free text — column count, block-type range, `Bestand`; just not a word that already means something else in this model.

## Notation rules

- **Multiplicity at both ends** (`1` ↔ `0..n`). One number alone does not say which side it means.
- **`1:n` and `0..n` are two different notations. Never mix them.** `1:n` (Chen) names the kind of relationship and its `1` is the *parent*; `0..n` (UML/crow's foot) is a multiplicity at *one end* and its `0` is the *child*. This template uses UML at both ends — stay there.
- **`1..n` is a stronger claim than `0..n`** and usually not covered by the database: no foreign key can enforce "at least one child". Where it stands, name who keeps it (a stored procedure, the save path — say which).
- **The arrowhead points at the child side**, where the foreign key lives. Put that in the legend: the opposite convention (arrow towards the referenced target) is just as widespread.
- **An unknown delete rule gets no label.** Where the source does not say whether an edge cascades, leave `note` off and put the question in the footer's *Offen* line. A guessed `CASCADE` is a claim the drawing cannot back.
- **The legend describes your model, not the template's.** Re-derive every line. The shipped legend renders `FK` as "foreign key with `CASCADE`" — true of the demo edges it was written for, false as a general statement, and false for half the demo's own cards. Copy the CSS and the script verbatim; never the words.
- Cards ~320 px wide, generous grid gaps (3rem/5rem). Full-width columns leave no room for the wires — sooner smaller type and zoom.
- **One explanation panel for whatever looks wrong in the schema but is deliberate.** Without it the next reader repairs the intent away.

## The wires array

```js
{from:"t-order", fs:"right", to:"t-ordertag", ts:"left", a:"1", b:"0..n", fo:18, bend:-20, note:"CASCADE", mute:true}
```

`fs`/`ts` side of source/target (`top|bottom|left|right`) · `fo`/`qo` shift the attachment point along that side · `bend` shifts the corner · `a`/`b` multiplicity at source/target end · `note` extra label · `mute` grey line, for edges to existing tables and value lists.

**Never reuse a key name for two meanings.** The offsets are `fo`/`qo` precisely because `to` was once both target id and target offset: the offset won, `getElementById` returned null, two edges vanished and 33 console errors appeared that were invisible in the code.

**Bundles: stagger `fo` *and* `bend`.** Five edges leaving the same card for five targets in the same column compute the same corner and smear into one stripe. Staggering only one of the two is not enough.

The router does orthogonal routes with at most two corners and no collision detection. It carries a three-column layout. Beyond that, expect hand tuning — and check it in the browser, not in your head.

## Verification — required

The code looks right when it is broken. On the reference model 33 console errors were invisible while reading and obvious in one browser load.

1. `python -m http.server <port>` in the file's directory. **`file:` is blocked in Playwright** — without a server there is no check.
2. Load the page, read the console. A `favicon.ico` 404 is normal; everything else is a finding.
3. **Measure, do not look.** Fill `EXPECT` in [verify.js](verify.js) with the wire count per surface, paste the whole function into `browser_evaluate`, and require `ok: true`. It checks the edge count, malformed and `NaN` paths, arrowheads that do not resolve, labels off the drawing surface, column lists visible while collapsed, duplicate marker ids — and **wires that run through a card**. That last one matters most: the connector layer sits *behind* the grid, so an edge crossing a card is drawn and invisible while every other check passes on it. Do not re-implement these by hand; that is how the invisible one slips through.
4. Screenshot and look: **collapsed, one card open, flow mode**.
5. Clean up: stop the server, delete screenshots, check `git status`. Playwright drops screenshots in the **repository root**, not where you expect, and creates a `.playwright-mcp` directory.

## Interaction rules — not negotiable

| Rule | Why |
|---|---|
| Collapsed is the reading state | Expanded, a ~300-column model is metres tall and no longer an overview |
| The wires are rigid — computed once from the collapsed grid, never redrawn on toggle | Wires that move on every click destroy spatial orientation |
| An open card overlays the grid instead of shifting it | Follows from the previous rule: the wires may only stay fixed if the grid does |
| Only one card open; click outside or `Esc` closes | Fits "open briefly"; prevents stacked overlays |
| "Expand all" switches to flow mode (`body.flow`), where cards flow and the wires are redrawn once | Whoever expands everything wants to read, not navigate. Applies to printing too |
| Print toggle top right forces light mode, colour coding survives | A dark ground is useless on paper, but the colours carry information |

## Pitfalls

| Symptom | Cause | Fix |
|---|---|---|
| Collapsed, only the table name shows | `<details>` hides *everything* after the `<summary>` | Short form and note go **inside** the `<summary>`; the disclosure marker moves to `.thead::before` |
| Column lists visible while collapsed | An `position:absolute` child whose containing block (`.tbl`) is outside the collapsed subtree escapes the hiding | `.tbl:not([open]) .cols{display:none}` — already in the template, do not remove it |
| Edges end nowhere, labels at the page edge, console errors | A key name used for two things in the wire objects | Distinct names (`fo`/`qo`); check no key is doubly assigned |
| Bundled edges lie on top of each other | Same corner computed for all of them | Stagger `fo` **and** `bend` |
| Labels sit on the line | Vertical edges centre the label on the path | Offset sideways, and put `note` on the opposite side of the multiplicities |
| Arrowheads missing with several SVG layers | Duplicate `<marker>` ids | Derive the id per surface (`arr-a-wires1`); one marker per line colour — `context-stroke` does not carry everywhere |
