---
name: mail-draft
description: Use when the user needs the text of an e-mail — a new one, a reply to a mail or thread they pasted, or a rework of an existing draft ("kürzer", "formeller", "freundlicher"). Triggers on "Mail schreiben", "E-Mail formulieren", "Mailtext", "schreib das als Mail", "antworte auf diese Mail", "write an email". Not for sending or fetching mail, and not for newsletters or HTML campaign layouts.
argument-hint: [recipient / topic]
---

# Mail Draft

## Overview

Produces one mail in two places at once: printed in the terminal, and as a
self-contained HTML page in `C:\Temp` that opens in the browser, where a button
puts body and subject on the clipboard ready for Outlook.

**Both, always.** Terminal output without the HTML file is an unfinished run.

The mail text is German unless the source mail, the recipient or the user's
instruction says otherwise.

## The shape of the mail

The body, in this order:

1. Anrede.
2. **One sentence** saying what this is about and what is wanted.
3. Only what the recipient needs in order to act. Three or more items of the
   same kind → a bulleted list.
4. If something is needed from them: the concrete next step — who does what,
   by when.
5. Grußformel — **and the mail ends there.** No name, no title, no contact
   block underneath: Outlook appends the user's signature to what is pasted,
   and a name in the body would stand twice.

Binding limits:

- **Body ≤ 150 words.** More only when the content genuinely carries more
  (figures, a list of items) — never for politeness.
- The ask or the decision stands in the **first two sentences**, never at the end.
- One thought per sentence.
- Keep the user's own words for products, systems and people. Do not upgrade
  them into officialese.
- Openers that say nothing ("ich hoffe, es geht dir gut", "wie besprochen melde
  ich mich hiermit") are not written.

## Anrede and register

- **A source mail exists** → mirror it exactly: Du or Sie, the greeting, the
  sign-off, first name or full name.
- **No source** → take it from how the user speaks about the recipient (first
  name → Du; company, role or unknown → Sie).

Name the choice in one line after the output ("Sie-Form, weil kein Vorname
genannt") so it can be corrected. Do not ask before writing.

## Formatting contract

The body is an HTML fragment. These tags and no others:

`<p>` `<strong>` `<em>` `<ul>` `<ol>` `<li>` `<a href="…">` `<br>`
`<table>` `<tr>` `<th>` `<td>`

No `style`, no `class`, no headings, images, colours or `<div>`. The copy button
ships this markup untouched, so Outlook applies the user's own default font and
the mail reads as typed, not as pasted. Anything beyond the list either
announces itself as foreign or breaks Outlook's rendering.

**A table carries its borders as HTML attributes, never as `style`.** Outlook's
renderer honours these, and they survive the paste where a stylesheet would not:

```html
<table border="1" cellspacing="0" cellpadding="4">
  <tr><th>Posten</th><th>Betrag</th></tr>
  <tr><td>Wartung</td><td>1.200 €</td></tr>
</table>
```

**A list is the default; a table is the exception.** Reach for one only when the
content cannot be carried by a list — two or more columns whose values have to
line up to be read. One value per row is a list, and a two-row table that could
have been two bullets is noise in a mail.

**Underlining is never used**, not even on request wording like "heb das hervor":
every mail client draws links that way, and the reader tries to click it.
Emphasis is `<strong>`, a softer nuance `<em>`.

A heading → a `<strong>` line. Every paragraph is its own `<p>`, Anrede and
Grußformel included; `<br>` never separates paragraphs.

## Procedure

1. **Collect the source.** Read what was pasted or named — mail thread, ClickUp
   task, file. Invent no facts, figures, dates or names.
2. **Subject.** At most ~60 characters and it names the thing. A reply keeps the
   original subject including its `AW:` / `Re:` prefix.
3. **Write the fragment** to a file in the scratchpad directory, UTF-8.
4. **Build the page:**

   ```powershell
   & "<skill-dir>\scripts\new-mail.ps1" -Name <short-name> -Subject "<subject>" -BodyPath "<fragment path>"
   ```

   `<skill-dir>` is the directory of this `SKILL.md`. `-Name` is 1–3 kebab-case
   ASCII words naming topic or recipient (`angebot-wartung`, `absage-termin`). The
   script writes `C:\Temp\MAIL-<name>.html`, opens it in the browser and prints
   the path. Add `-NoOpen` only when the user asked for no browser window.
5. **Print in the terminal:** the subject line, then the body as plain text
   (`**bold**`, `-` for list items), then the file path on one line.

**Overwriting is intended.** A rework of the same mail ("kürzer", "andere
Anrede") reuses the same `-Name` and overwrites the file — tell the user to
reload the tab, not to open a second one. A different `-Name` only for a
genuinely different mail.

## Missing information

Anything no source supplies — a date, a price, a name — becomes a placeholder in
the mail: `[Termin]`. Deliver the draft with the placeholder and list the open
points in the terminal below it. Do not stop and ask first; a mail with two gaps
is worth more than a question.

## Red flags

- Terminal output but no HTML file → the run is not finished.
- Body past ~150 words without a factual reason → cut.
- The ask buried in the last paragraph → move it up.
- `style=`, `<div>` or a heading tag in the fragment → strip it.
- A name or contact block after the Grußformel → remove it, the signature carries it.
- A fact in the mail that stands in no source → remove it or make it a
  placeholder.
