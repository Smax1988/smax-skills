---
name: find-beer-deals
description: Finds current discount offers for a given beer (crate) near an Austrian home town
argument-hint: <beer> [ZIP/town]
allowed-tools: WebSearch, WebFetch
disable-model-invocation: true
---

Input: **$ARGUMENTS**

Read the **beer** and the **home town (ZIP/town in Austria)** out of it. Example: "Zipfer Märzen 6421 Rietz" → beer = "Zipfer Märzen", town = "6421 Rietz".

Find out whether that beer is currently on offer, preferably as a **crate** (*Kasten/Kiste*), and where — near the home town.

If no town is recognisable, ask once, briefly, for ZIP/town and then continue.

## Procedure

1. **Mind today's date** — flyer promotions are time-limited. Offers valid right now take precedence. Offers starting in the next few days may be included, but only with the start date stated and clearly marked as "noch nicht gültig". Expired promotions do not belong in the table — at most as a side note, if they explain why a price is currently high.
2. **Web search** on the Austrian offer aggregators:
   - `marktguru.at`
   - `wogibtswas.at`
   - `flugblattangebote.at`
   - `rabattkompass.at`
   - plus the retailers directly (Hofer, Lidl, Spar/Eurospar/Interspar, Billa/Billa Plus, MPreis).
   - `aktionsfinder.at` has shut down, the domain no longer resolves — do not go there any more.
   - `hofer.at` and `filialen.hofer.at` block automated fetches with 403. Get Hofer offers via the aggregators instead, and mark in the report that the source is not the retailer itself.
3. **Always check MPREIS explicitly for Tyrolean home towns** — MPREIS is extremely dense in Tyrol and often does not show up prominently on the aggregators. Therefore:
   - Search specifically for "<beer> MPREIS Angebot".
   - Reliable marktguru entry points are the brand page `https://www.marktguru.at/b/<brand>` and the retailer category page `https://www.marktguru.at/rc/mpreis/bier` (derive the brand from the beer, e.g. "Zipfer Märzen" → `zipfer`). Equally productive: the MPreis retailer page at `https://www.flugblattangebote.at/geschaefte/mpreis/angebote/`.
   - **Do not guess retailer/brand URLs.** `marktguru.at/rb/<retailer>/<brand>` exists only for incidentally indexed combinations and otherwise returns 404 (proven: `/rb/hofer/zipfer`, `/rb/norma/zipfer`). The same goes for guessed promotion paths on `mpreis.at`. Only open URLs that come from a search or from a page already loaded.
   - On these JS-heavy portals, HTTP 200 does not mean offer data is in there. If a page contains no concrete prices, it counts as a failure — not as "MPREIS has nothing".
   - Keep MPREIS as a candidate even when it does not surface on the aggregators above — better to check once too often than once too rarely.
4. **Open the relevant pages via WebFetch** and extract concrete offers: retailer, pack size, promotional price (including app/loyalty price if there is one), regular price, discount %, validity period, region/province.
5. **Filter by region:** only consider offers valid in the province of the home town. Account for Tyrolean specifics (MPreis is typical for Tyrol).
6. **Locate the nearest branch** of the relevant retailers roughly against the home town (distance/direction), so it is clear where to drive. Include small formats (MPREIS Mini-M) — a short trip beats a minimal price advantage further away.

## Output

Write the answer **in German**.

- **Crate offers first**, in a table: Händler | Gebinde | Aktionspreis | App-/Treuepreis | Statt | Gültig | nächste Filiale. Carry every column even if one stays empty — do not move app/loyalty prices into running text. Name the deposit (*Pfand*) separately below the table, do not fold it into the promotional price.
- Then briefly what the remaining stores currently have (often single bottles/cans only).
- **A clear recommendation:** where the crate is cheapest and which branch is nearest.
- **A reliability note:** flyer prices and regional validity can change at short notice — check the app/flyer before driving.
- At the end, a **source list** with the URLs used, as Markdown links.

Address Smax by name, be brief and direct.
