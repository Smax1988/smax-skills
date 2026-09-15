---
name: infographic-page
description: Use when the user asks to create a visual overview, infographic, diagram, or explanatory page about any topic — technical or non-technical. Triggers on "Grafik erstellen", "Infografik", "visuelle Übersicht", "Erklaerseite", "Diagramm das X erklaert", "HTML Seite die Y vergleicht", or similar requests for a standalone educational HTML page. Generates a single self-contained .html file with dark luxury design (gold on dark), collapsible sections, and Google Fonts. Do NOT use for UML/Mermaid code diagrams, data dashboards with real datasets, React/Vue components, SVG/logo generation, markdown documentation, interactive apps, or editing existing HTML files.
argument-hint: <topic> [focus or angle]
disable-model-invocation: true
---

# Infographic Page

## Overview

Creates a single self-contained `.html` file that visually explains a topic — structured in collapsible sections with a dark luxury aesthetic. No frameworks, no build tools. HTML + CSS + minimal inline JS.

## When to Use

- User asks for a visual explanation, diagram, or infographic on any topic
- User wants a styled HTML reference page
- User says "create a graphic/page/diagram about X"

## Output

**One single `.html` file.** Everything inline — CSS in `<style>`, JS in `<script>`. No external dependencies except Google Fonts.

Never embed secrets (API keys, tokens, passwords) or personal data (PII) in the generated page — it is a self-contained, shareable file. Use placeholders instead.

## Design System

### Fonts (Google Fonts import)

```
Cinzel (400, 700, 900) — Headings, badges, section titles
Fira Code (400, 600) — Code, technical labels, monospace elements
Crimson Pro (300, 400, 600, italic) — Body text, descriptions
```

```html
<link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;700;900&family=Fira+Code:wght@400;600&family=Crimson+Pro:ital,wght@0,300;0,400;0,600;1,300&display=swap" rel="stylesheet">
```

### Color Palette (CSS Variables)

```css
:root{
  /* Core palette */
  --gold:#c9a84c;
  --gold-dim:#8a6d2b;
  --gold-bright:#e8d48b;
  --bg-deep:#0a0c10;
  --bg-card:#12151c;
  --bg-stage:#0e1118;
  --border:#1e2330;
  --text:#c8ccd4;
  --text-dim:#6b7280;
  --red:#ef4444;

  /* Accent colors — pick per topic, assign to sections/cards */
  --accent-blue:#3b82f6;
  --accent-blue-dim:#1e3a5f;
  --accent-purple:#8b5cf6;
  --accent-purple-dim:#3b1f6e;
  --accent-green:#10b981;
  --accent-green-dim:#0a4a33;
  --accent-orange:#f97316;
  --accent-orange-dim:#6b3410;
  --accent-amber:#f59e0b;
  --accent-amber-dim:#5c3d0a;
  --accent-pink:#ec4899;
  --accent-pink-dim:#6b1a45;
}
```

### Design Rules

| Element | Style |
|---------|-------|
| **Background** | `var(--bg-deep)` with subtle noise texture overlay |
| **Headings** | Cinzel, gold, uppercase, letter-spacing `.12em`, text-shadow glow |
| **Body text** | Crimson Pro, `var(--text-dim)`, italic for descriptions |
| **Strong text** | `var(--text)`, `font-weight:600`, not italic |
| **Code/technical** | Fira Code, colored background pill |
| **Cards/boxes** | `var(--bg-stage)` bg, `var(--border)` border, `12px` border-radius, hover: `var(--gold-dim)` border |
| **Badges** | Absolute positioned `top:-13px`, Cinzel uppercase, accent-colored bg+border |
| **Section dividers** | Gold gradient lines with Cinzel label between them |
| **Info boxes** | Dashed or solid accent border, icon + text layout |
| **Animations** | `fadeSlideIn` on cards with staggered `animation-delay` |

### Noise Texture Overlay (on body::before)

```css
body::before{
  content:'';position:fixed;inset:0;z-index:0;pointer-events:none;
  background-image:url("data:image/svg+xml,%3Csvg viewBox='0 0 256 256' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='n'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23n)' opacity='0.03'/%3E%3C/svg%3E");
  background-repeat:repeat;
}
```

## Page Structure

```
<header>         — Title (Cinzel h1, gold) + subtitle (Fira Code, dim)
<expand-controls> — "Alle aufklappen" / "Alle zuklappen" buttons
<details>         — Section 1 (open by default)
  <summary>       — Gold divider line with section title + chevron
  <section-content> — Cards, diagrams, info boxes, tables, flows
<details>         — Section 2 (closed)
  ...
<details>         — Section N (closed)
```

## Collapsible Sections — Required CSS + HTML + JS

### CSS (include in every page)

```css
/* ── Collapsible sections ── */
details{margin-bottom:.5rem}
details summary{
  display:flex;align-items:center;gap:1rem;margin:2.5rem 0 0;
  cursor:pointer;list-style:none;user-select:none;
  padding:.4rem 0;border-radius:6px;
  transition:opacity .2s;
}
details summary::-webkit-details-marker{display:none}
details summary::before,details summary::after{
  content:'';flex:1;height:1px;
  background:linear-gradient(90deg,transparent,var(--gold-dim),transparent);
}
details summary span{
  font-family:'Cinzel',serif;font-weight:700;font-size:.85rem;
  color:var(--gold);letter-spacing:.18em;text-transform:uppercase;
  white-space:nowrap;
  display:flex;align-items:center;gap:.5rem;
}
details summary span::after{
  content:'\25BC';font-size:.55rem;color:var(--gold-dim);
  transition:transform .3s ease;
  display:inline-block;
}
details[open] summary span::after{
  transform:rotate(180deg);
}
details summary:hover{opacity:.8}
details summary:hover span{color:var(--gold-bright)}
details .section-content{
  overflow:visible;
  animation:sectionOpen .4s ease both;
}
@keyframes sectionOpen{
  from{opacity:0;max-height:0;margin-top:0}
  to{opacity:1;max-height:2000px;margin-top:1.5rem}
}

/* ── Expand/Collapse buttons ── */
.expand-controls{
  display:flex;justify-content:center;gap:1rem;margin-bottom:1rem;
}
.expand-btn{
  font-family:'Fira Code',monospace;font-size:.7rem;
  color:var(--text-dim);background:var(--bg-card);
  border:1px solid var(--border);border-radius:4px;
  padding:.3rem .8rem;cursor:pointer;
  transition:border-color .2s, color .2s;
}
.expand-btn:hover{border-color:var(--gold-dim);color:var(--gold)}
```

### HTML pattern

```html
<!-- After </header> -->
<div class="expand-controls">
  <button class="expand-btn" onclick="toggleAll(true)">Alle aufklappen</button>
  <button class="expand-btn" onclick="toggleAll(false)">Alle zuklappen</button>
</div>

<!-- First section: open by default -->
<details open>
<summary><span>Section Title</span></summary>
<div class="section-content">
  <!-- content here -->
</div>
</details>

<!-- All other sections: closed -->
<details>
<summary><span>Section Title</span></summary>
<div class="section-content">
  <!-- content here -->
</div>
</details>
```

### JS (before `</body>`)

```html
<script>
function toggleAll(open) {
  document.querySelectorAll('details').forEach(d => d.open = open);
}
</script>
```

## Reusable Component Patterns

### Card with Badge

```html
<div class="card card--blue">
  <div class="card-badge">Label</div>
  <div class="card-icon">EMOJI</div>
  <div class="card-title">Title</div>
  <div class="card-desc">Description with <strong>highlights</strong>.</div>
</div>
```

```css
.card{
  position:relative;border:1px solid var(--border);border-radius:12px;
  background:var(--bg-stage);padding:2rem 1.4rem 1.4rem;
  transition:border-color .3s, transform .2s;
}
.card:hover{border-color:var(--gold-dim);transform:translateY(-2px)}
.card-badge{
  position:absolute;top:-13px;left:1.2rem;
  font-family:'Cinzel',serif;font-weight:700;font-size:.72rem;
  letter-spacing:.18em;text-transform:uppercase;
  padding:.25rem .9rem;border-radius:4px;
}
.card--blue .card-badge{background:var(--accent-blue-dim);color:var(--accent-blue);border:1px solid rgba(59,130,246,.3)}
.card-icon{font-size:2.4rem;text-align:center;margin:.4rem 0 .8rem;line-height:1}
.card-title{
  font-family:'Cinzel',serif;font-weight:700;font-size:1rem;
  color:var(--gold);text-align:center;margin-bottom:.6rem;letter-spacing:.06em;
}
.card-desc{font-size:.88rem;line-height:1.55;color:var(--text-dim)}
.card-desc strong{color:var(--text);font-weight:600}
```

### Info Box (highlighted callout)

```html
<div class="info-box">
  <div class="info-box-icon">EMOJI</div>
  <div class="info-box-text">
    Text with <strong>bold highlights</strong> and <code>code</code>.
  </div>
</div>
```

```css
.info-box{
  border:1px solid var(--accent-blue-dim);border-radius:10px;
  padding:1.2rem 1.5rem;background:rgba(59,130,246,.03);
  margin-top:1.5rem;display:flex;gap:1rem;align-items:flex-start;
}
.info-box-icon{font-size:1.4rem;flex-shrink:0;margin-top:.1rem}
.info-box-text{font-size:.88rem;line-height:1.6;color:var(--text-dim)}
.info-box-text strong{color:var(--text);font-weight:600}
.info-box-text code{
  font-family:'Fira Code',monospace;font-size:.75rem;
  color:var(--accent-blue);background:rgba(59,130,246,.08);
  padding:.05rem .3rem;border-radius:2px;
}
```

### Highlighted Info Box (for key insights)

```css
.info-box--highlight{
  border-color:var(--gold-dim);
  background:linear-gradient(135deg,rgba(201,168,76,.06),rgba(201,168,76,.02));
  padding:1.6rem 1.8rem;
  box-shadow:0 0 30px rgba(201,168,76,.06);
}
```

### Flow Diagram (horizontal A -> B -> C)

```html
<div class="flow-row">
  <div class="flow-node flow-node--blue">Node A</div>
  <div class="flow-arrow">
    <div class="lbl">label</div>
    <div class="arr">&rarr;</div>
  </div>
  <div class="flow-node flow-node--green">Node B</div>
</div>
```

```css
.flow-row{display:flex;align-items:center;justify-content:center;gap:.8rem;margin:1.2rem 0;flex-wrap:wrap}
.flow-node{
  font-family:'Fira Code',monospace;font-size:.78rem;
  padding:.5rem 1.1rem;border-radius:6px;
  border:1px solid var(--border);background:var(--bg-card);
}
.flow-node--blue{color:var(--accent-blue);border-color:rgba(59,130,246,.3)}
.flow-node--green{color:var(--accent-green);border-color:rgba(16,185,129,.3)}
.flow-arrow{display:flex;flex-direction:column;align-items:center;gap:.1rem;color:var(--text-dim)}
.flow-arrow .arr{font-size:1.3rem;line-height:1}
.flow-arrow .lbl{font-family:'Fira Code',monospace;font-size:.58rem;color:var(--text-dim)}
```

### Comparison (side by side with VS)

```html
<div class="compare">
  <div class="compare-box"><!-- left --></div>
  <div class="compare-vs">VS</div>
  <div class="compare-box"><!-- right --></div>
</div>
```

```css
.compare{display:grid;grid-template-columns:1fr auto 1fr;gap:1.5rem;align-items:start}
.compare-box{border:1px solid var(--border);border-radius:12px;background:var(--bg-stage);padding:1.6rem 1.4rem 1.2rem;position:relative}
.compare-vs{display:flex;align-items:center;justify-content:center;font-family:'Cinzel',serif;font-weight:900;font-size:1.4rem;color:var(--gold-dim);letter-spacing:.1em;padding-top:4rem}
```

### Property List

```html
<ul class="prop-list">
  <li><span class="prop-key">key</span><span class="prop-val">value with <code>code</code></span></li>
</ul>
```

```css
.prop-list{list-style:none;padding:0}
.prop-list li{display:flex;gap:.6rem;align-items:flex-start;margin-bottom:.6rem;font-size:.88rem;line-height:1.45}
.prop-key{
  font-family:'Fira Code',monospace;font-size:.72rem;color:var(--gold-bright);
  background:rgba(201,168,76,.06);border:1px solid rgba(201,168,76,.12);
  border-radius:3px;padding:.1rem .4rem;white-space:nowrap;flex-shrink:0;
}
.prop-val{color:var(--text-dim);font-size:.85rem}
.prop-val code{font-family:'Fira Code',monospace;font-size:.75rem;color:var(--text);background:rgba(255,255,255,.05);padding:.05rem .3rem;border-radius:2px}
```

### Styled Table

```css
.styled-table{width:100%;border-collapse:collapse;margin-top:.8rem}
.styled-table th{
  font-family:'Cinzel',serif;font-size:.7rem;letter-spacing:.12em;
  text-transform:uppercase;color:var(--text-dim);
  text-align:left;padding:.5rem .8rem;border-bottom:1px solid var(--border);
}
.styled-table td{font-size:.82rem;padding:.5rem .8rem;border-bottom:1px solid rgba(30,35,48,.5);vertical-align:top}
.styled-table td:first-child{font-family:'Fira Code',monospace;font-size:.75rem;color:var(--gold-bright);white-space:nowrap}
```

## Animation (fadeSlideIn)

```css
@keyframes fadeSlideIn{
  from{opacity:0;transform:translateY(12px)}
  to{opacity:1;transform:translateY(0)}
}
.card,.info-box,.compare-box{
  animation:fadeSlideIn .5s ease both;
}
/* Stagger with animation-delay per element */
```

## Responsive

```css
@media(max-width:800px){
  /* Stack grids to single column */
  .cards-grid{grid-template-columns:1fr}
  .compare{grid-template-columns:1fr;gap:1rem}
  .compare-vs{padding-top:0;font-size:1rem}
}
```

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| `overflow:hidden` on `.section-content` | Use `overflow:visible` — badges overlap parent boundaries |
| Forgetting `open` on first `<details>` | First section should always be `<details open>` |
| External CSS/JS files | Everything must be inline in the single `.html` file |
| Generic fonts (Inter, Arial) | Always use the Cinzel/Fira Code/Crimson Pro stack |
| Light background | Always dark (`--bg-deep: #0a0c10`) |
| Missing noise texture | Include the `body::before` SVG noise overlay |
