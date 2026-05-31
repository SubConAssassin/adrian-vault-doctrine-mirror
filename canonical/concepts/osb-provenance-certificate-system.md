---
title: OSB Provenance Certificate System
type: canonical-design
status: active
created: 2026-05-05
last_updated: 2026-05-05
authored_by: claude (CEO mode, phone-prompt session)
commissioned_by: Peter Van Drago (2022 request)
tags: [osb, provenance, authenticity, certificate, product-design, id-scheme]
related:
  - canonical/concepts/methodology-canon.md
---

# OSB Provenance Certificate System

Every Original Siberian Blue piece carries a stone that cannot be replicated. The certificate makes that uniqueness legible — to the buyer, to future owners, and to any secondary market.

---

## ID Scheme

```
OSB-{YEAR}-{SYMBOL}-{SEQUENCE}
```

| Symbol | Code |
|---|---|
| Arcturian Soul Purpose Amulet | ASA |
| Merkaba | MRK |
| Tranquility | TRQ |
| Arcturian Navigator | ANV |
| TAM seed-syllable | TAM |
| Symbol 4 (TBC) | S04 |

Sequence: six-digit zero-padded integer, per symbol, per year, resets annually.

Examples: `OSB-2026-ASA-000001` / `OSB-2024-MRK-000012` (backdated historic piece)

---

## Certificate Components (physical)

| Field | Content |
|---|---|
| Certificate ID | `OSB-{YEAR}-{SYMBOL}-{NNNNNN}` |
| Symbol name + meaning | 2–3 sentences from Arcturian Design System canon |
| Stone | "Genuine Siberian Blue (Hackmanite)" |
| Edition | Standard / Diamond Edition |
| Size | Small / Medium / Large |
| Artisan | "Hand-crafted by Yoga, Bali" |
| Date of issue | YYYY-MM-DD |
| QR code | Links to digital registry entry |
| OSB seal | Arcturian symbol + "Original Siberian Blue" wordmark |

**Physical spec:** A6 (105×148mm), min 350gsm, cream or deep navy. Foil on seal and certificate ID. Enveloped separately inside the packaging box — first thing the buyer sees.

---

## Digital Registry

Public URL: `osb.store/certificate/{ID}` (or equivalent)

Displays: certificate ID, symbol + meaning, stone, edition/size, date, authenticity confirmation. Does not display buyer name (privacy by default). MVP: Notion public page or Shopify metafield until custom page is built.

---

## Issue Process

1. Yoga signs off the completed piece
2. Operator looks up symbol + year → gets next sequence number from the registry sheet
3. Generates certificate ID, prints PDF, seals in envelope
4. Ships inside the box
5. Registers the ID in the live digital registry same day

Working registry instrument until tooling is built: Google Sheet with columns `ID | Symbol | Edition | Size | Date | Order# | Buyer (internal only) | Status`

---

## Design Brief (for designer)

> A6, 350gsm minimum, cream or deep navy. The Arcturian sacred geometry symbol of the piece, centred, printed or foil-embossed. OSB wordmark at foot. Certificate ID typeset prominently below the symbol. QR code bottom-right, small but scannable. Tone: sacred, authoritative, rare — not clinical. The buyer should feel they are holding a document of spiritual provenance, not a warranty card.

---

## Open Questions (Adrian to resolve)

1. **Registry hosting** — Notion public page fastest MVP; Shopify metafield for long-term
2. **Historic backdating** — issue certificates to existing clients (e.g. Peter Van Drago)? Yes = brand moment
3. **Who generates** — Adrian manually or VA with template?
4. **Diamond Edition** — same design on black card/silver foil, or separate spec?

---

## Phase 2 (do not scope now)

NFC tag embedded in certificate, transfer registration (new owner can register), bespoke Diamond Edition physical design, Yoga's physical mark/stamp on reverse.
