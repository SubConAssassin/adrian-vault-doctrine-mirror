---
title: OSB Provenance Certificate System
type: canonical-design
status: active
created: 2026-04-26
authored_by: claude (CEO mode, phone-prompt session)
commissioned_by: Peter Van Drago (2022 request); reconfirmed in chatgpt-project-intelligence.md
tags: [osb, provenance, authenticity, certificate, product-design, id-scheme]
related:
  - canonical/concepts/methodology-canon.md
  - canonical/projects/osb/business-intelligence-2026-04-24.md
---

# OSB Provenance Certificate System

## Purpose

Every Original Siberian Blue piece carries a unique stone that cannot be replicated. The certificate makes that uniqueness legible — to the buyer, to future owners, and to any secondary market. It is an authenticity instrument, a brand touchpoint, and a long-term relationship asset.

Peter Van Drago requested this in 2022. It is now a production priority.

---

## What the Certificate Certifies

1. **Stone origin** — Genuine Siberian Blue (Hackmanite variety, Siberian deposit). Not synthetic. Not substitute.
2. **Artisan authentication** — Hand-crafted by Yoga, OSB's master artisan, Bali.
3. **Symbol identity** — Which sacred geometry symbol the piece carries, and its meaning within the Arcturian Design System.
4. **Edition and size** — Standard / Diamond Edition; small / medium / large as applicable.
5. **Unique serial number** — Ties this certificate to this exact physical piece, permanently.

---

## ID Scheme

### Format

```
OSB-{YEAR}-{SYMBOL}-{SEQUENCE}
```

### Symbol codes

| Symbol | Code |
|---|---|
| Arcturian Soul Purpose Amulet | ASA |
| Merkaba | MRK |
| Tranquility | TRQ |
| Arcturian Navigator | ANV |
| TAM seed-syllable | TAM |
| Symbol 4 (TBC) | S04 |

### Sequence

Six-digit zero-padded integer, per symbol, per year. Resets annually.

### Examples

```
OSB-2026-ASA-000001   ← first Arcturian Soul Purpose Amulet of 2026
OSB-2026-TRQ-000047   ← 47th Tranquility piece of 2026
OSB-2024-MRK-000012   ← backdated Merkaba (for historic pieces in the Peter Van Drago range)
```

### Backdating historic pieces

Pieces sold before this system existed can be registered retroactively with the year of original sale. Yoga's records and OSB order history are the source of truth. Gaps in sequence are acceptable — the sequence is a counter, not a proof of continuity.

---

## Certificate Components

### Physical certificate (ships with piece)

| Field | Content |
|---|---|
| Certificate ID | `OSB-{YEAR}-{SYMBOL}-{NNNNNN}` |
| Symbol name | Full name (e.g. "Arcturian Soul Purpose Amulet") |
| Symbol meaning | 2–3 sentences from the Arcturian Design System canon |
| Stone | "Genuine Siberian Blue (Hackmanite)" |
| Edition | Standard / Diamond Edition |
| Size | Small / Medium / Large |
| Artisan | "Hand-crafted by Yoga, Bali" |
| Date of issue | YYYY-MM-DD |
| QR code | Links to the digital registry entry for this certificate ID |
| OSB seal | Arcturian symbol + "Original Siberian Blue" wordmark |

**Physical spec:**
- Premium heavyweight stock (min 350gsm), cream or deep navy ground
- Foil detail on the OSB seal and certificate ID
- Dimensions: A6 (105 × 148mm) — fits the jewellery pouch without folding
- Enveloped separately inside the packaging box

### Digital registry entry (per certificate ID)

Public URL: `osb.store/certificate/{ID}` (or equivalent domain)

Fields displayed:
- Certificate ID
- Symbol name + meaning
- Stone: Genuine Siberian Blue
- Edition / size
- Date of issue
- "This certificate is authentic" confirmation (visual indicator)
- Transfer log (optional, Phase 2) — if the piece changes hands, the new owner can register

The registry does not display buyer name — privacy by default.

---

## Issue Process

### Step 1 — Artisan sign-off

Yoga completes the piece. Signs off quality. Piece is ready to ship.

### Step 2 — Certificate generated

Adrian or the fulfilment operator generates the certificate:

1. Open the OSB Certificate Registry (spreadsheet or future CRM field)
2. Look up the symbol and year → get the next sequence number
3. Enter: symbol, edition, size, date of issue
4. System outputs the Certificate ID and a print-ready PDF
5. Print, seal in envelope

Until a formal registry tool is built, the working instrument is a Google Sheet with columns:
`ID | Symbol | Edition | Size | Date | Order# | Buyer (internal only) | Status`

### Step 3 — QR code

QR code is pre-generated per certificate ID. Points to the digital registry page. Can be batch-generated weekly once tooling is in place.

### Step 4 — Ship

Certificate envelope goes inside the box, on top of the jewellery pouch. Not inside the pouch — it should be the first thing the buyer sees.

### Step 5 — Digital registry (same day or next business day)

Register the certificate ID in the live registry. Until the public-facing page is built, a simple "certificate lookup" form on the OSB site or a Notion public page will serve.

---

## Phase 2 additions (do not build now — scope creep risk)

- Transfer registration — buyer can register ownership to their name
- NFC tag embedded in the certificate — tap-to-verify on phone
- Bespoke certificate for Diamond Edition (different physical design, velvet presentation)
- Yoga's physical mark/stamp on the reverse of the certificate

---

## Design brief for the physical certificate

Hand this to the designer:

> The OSB Provenance Certificate is a premium printed card (A6, 350gsm minimum, cream or deep navy). It carries the Arcturian sacred geometry symbol of the piece it accompanies, centred on the card, printed or foil-embossed. The Siberian Blue stone is the zero-point centre of any Arcturian composition — the symbol design should reflect this (a central void or motif). The OSB wordmark sits at the foot. The certificate ID is typeset prominently below the symbol, in a serif or refined sans-serif. A QR code sits bottom-right, small but scannable. Tone: sacred, authoritative, rare. Not clinical. Not corporate. The buyer should feel they are holding a document of spiritual provenance, not a warranty card.

---

## Open questions (for Adrian to resolve)

1. **Registry hosting** — where does `osb.store/certificate/` point? Shopify metafield? Notion? Custom page? Recommend Notion public page as fastest MVP.
2. **Historic backdating** — does Adrian want to issue certificates for pieces already with clients (e.g. Peter Van Drago's own pieces)? If yes, a personal outreach to existing clients is a brand moment.
3. **Who generates certificates** — Adrian manually, or a VA with a template? Define before volume scales.
4. **Diamond Edition differentiation** — same certificate design or premium variant? Recommend same system, different physical stock (black card, silver foil).
