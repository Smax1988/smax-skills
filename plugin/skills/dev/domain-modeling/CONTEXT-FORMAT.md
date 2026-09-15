# CONTEXT.md Format

`CONTEXT.md` does three jobs. It gives the user and the model one word per concept, so a conversation about "the thing" is a conversation about the same thing. It answers *"what is this called in the code?"* — a direct question deserving a direct answer, not a guess. And it keeps that answer stable, so the same concept carries the same identifier in the repository's fifth year as in its first.

The third job is why the code name is not optional and not negotiable per call site. A glossary that names the concept but leaves the identifier open has done a third of its work.

## Structure

```md
# {Context Name}

{One or two sentence description of what this context is and why it exists.}

## Language

**Order**:
{A one or two sentence description of the term}
_Avoid_: Purchase, transaction

**Invoice**:
A request for payment sent to a customer after delivery.
_Avoid_: Bill, payment request

**Customer**:
A person or organization that places orders.
_Avoid_: Client, buyer, account
```

## Terms that aren't English

The glossary names concepts in whatever language the domain is actually spoken in. Code is English regardless. When the canonical term is not already English, the entry carries its English code name in backticks — that name, and only that name, is what appears in identifiers, types, functions, file names and comments:

```md
**Auftrag** (`Order`):
Ein verbindlicher Kundenwunsch, den wir angenommen haben.
_Avoid_: Bestellung, Order (als deutsches Wort), Job

**Leistungsnachweis** (`ServiceRecord`):
Die Dokumentation erbrachter Arbeit an einem Auftrag.
_Avoid_: Nachweis, Stundenzettel, Proof
```

Prose, conversation and commit messages use **Auftrag**; `OrderRepository`, `order_id` and `CREATE TABLE orders` use `Order`. Both directions of that mapping are canonical — the code name is not a translation anyone is free to redo.

Pick the code name once, when the term is added. Leaving it out is what produces `AuftragService` in one file and `CommissionService` in the next.

**There is no exemption.** Product names, legal and regulatory terms, in-house jargon — every one of them gets an English code name. "No English equivalent exists" is not a reason to keep the German word in code; it is a reason to *decide* on a name. Do that with the user, in the modelling session, and record what you picked:

```md
**Gewerbeschein** (`TradeLicence`):
Behördliche Berechtigung zur Ausübung eines reglementierten Gewerbes (GewO).
_Avoid_: Gewerbeberechtigung, BusinessPermit
```

When no candidate is obviously right, put two or three on the table and let the user choose — the name is theirs to live with. What you must not do is leave the slot empty or fill it with the German word: both hand the decision to whoever writes the next identifier, and they will decide differently.

Where the term is an abbreviation of a statute or standard with no English form (`AZG`, `RKV`, `DSGVO`), the choice is between the established English name (`DSGVO` → `Gdpr`) and an expansion (`AZG` → `WorkingHoursAct`). Ask; don't default to keeping the abbreviation.

## Rules

- **Be opinionated.** When multiple words exist for the same concept, pick the best one and list the others under `_Avoid_`.
- **Give every non-English term an English code name.** No entry in a non-English glossary is finished without it, and no term is exempt — not product names, not legal terms. If no equivalent suggests itself, decide one with the user. See above.
- **Keep definitions tight.** One or two sentences max. Define what it IS, not what it does.
- **Only include terms specific to this project's context.** General programming concepts (timeouts, error types, utility patterns) don't belong even if the project uses them extensively. Before adding a term, ask: is this a concept unique to this context, or a general programming concept? Only the former belongs.
- **Group terms under subheadings** when natural clusters emerge. If all terms belong to a single cohesive area, a flat list is fine.

## Single vs multi-context repos

**Single context (most repos):** One `CONTEXT.md` at the repo root.

**Multiple contexts:** A `CONTEXT-MAP.md` at the repo root lists the contexts, where they live, and how they relate to each other:

```md
# Context Map

## Contexts

- [Ordering](./src/ordering/CONTEXT.md) — receives and tracks customer orders
- [Billing](./src/billing/CONTEXT.md) — generates invoices and processes payments
- [Fulfillment](./src/fulfillment/CONTEXT.md) — manages warehouse picking and shipping

## Relationships

- **Ordering → Fulfillment**: Ordering emits `OrderPlaced` events; Fulfillment consumes them to start picking
- **Fulfillment → Billing**: Fulfillment emits `ShipmentDispatched` events; Billing consumes them to generate invoices
- **Ordering ↔ Billing**: Shared types for `CustomerId` and `Money`
```

The skill infers which structure applies:

- If `CONTEXT-MAP.md` exists, read it to find contexts
- If only a root `CONTEXT.md` exists, single context
- If neither exists, create a root `CONTEXT.md` lazily when the first term is resolved

When multiple contexts exist, infer which one the current topic relates to. If unclear, ask.