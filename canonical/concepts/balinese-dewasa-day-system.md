---
title: The Balinese Dewasa Day System — Pawukon, Saka, and the Vault's Computation Engine
type: doctrine
status: active
tier: 2
firewall_class: working-internal
version: 1.0
created: 2026-07-27
last_updated: 2026-07-27
authored_by: claude
related:
  - tools/balinese_calendar.py
  - tools/balinese_dewasa_data.py
  - tools/balinese_day_brief.py
  - tools/balinese-day-send.py
  - tools/test_balinese_calendar.py
  - working/_research/2026-07-27-balinese-calendar/
  - working/state/balinese-days/
  - ~/Library/LaunchAgents/com.adrianvault.balinese-day-brief.plist
purpose: |
  Reference doctrine for the Balinese calendar system Adrian lives inside
  (Sayan, Ubud) and for the vault's computational implementation of it: what
  the Pawukon and Saka calendars actually are, how dewasa ayu (auspicious-day)
  guidance is derived, what the ceremonial cycle contains, the honest
  resolution of the "red days / blue days" question, and — stated as plainly
  as the working parts — which layers of the implementation are well-sourced
  and which are approximations that will eventually break.
---

# The Balinese Dewasa Day System

## 0. Why this exists

Adrian lives in Sayan, Ubud. Bali runs on a day-quality calendar that materially
governs when things happen around him — when roads close, when the island shuts
down entirely, when a Balinese counterparty will not sign, when temple traffic
makes a journey pointless. He described it in his own words as *"a bit like
astrology… where they have red days and blue days, days where you literally
don't leave the house and don't do any negotiations, and then days which are
prime for doing negotiations,"* and asked for a daily automated brief.

That framing turned out to be a plain-English gloss over a real system with a
different name and a different colour scheme. **§4 states the verdict honestly,
including the part where his framing does not map onto anything documented.**

Everything below distinguishes three things that are easy to conflate: what
Balinese practice actually is (ethnography), what this vault's software computes
(engineering), and how far the second can be trusted (§9).

---

## 1. The two calendars, running in parallel and unsynchronised

Bali runs **two independent calendars simultaneously**. Neither is derived from
the other; they drift against each other permanently. Knowing which calendar
owns which holy day is the single most load-bearing fact in the whole system.

### 1.1 Pawukon — a 210-day permutation cycle with no year

The **Pawukon** has no year concept at all and no epoch in the ordinary sense.
It is 210 days that repeat forever. Its structure is ten concurrent "weeks"
(the **wewaran**) of lengths 1 through 10, all running at once and never
resetting against each other except at the 210-day boundary. Those 210 days are
also cut into **30 named wuku** of 7 days each — Sinta, Landep, Ukir, Kulantir,
Taulu, Gumbreg, Wariga, Warigadian, Julungwangi, Sungsang, Dunggulan, Kuningan,
Langkir, Medangsia, Pujut, Pahang, Krulut, Merakih, Tambir, Medangkungan, Matal,
Uye, Menail, Parangbakat, Bala, Ugu, Wayang, Kelawu, Dukut, Watugunung.

A day is named by combining Saptawara + Pancawara + wuku: *"Buda Keliwon
Dunggulan"* = Wednesday + Keliwon + the Dunggulan week. That is Galungan.

Because 7 and 5 are coprime, any Saptawara+Pancawara pair recurs every
LCM(7,5) = **35 days**, and 210 ÷ 35 = 6 — which is *why* there are exactly six
Tumpek, six Buda Keliwon and six Anggara Kasih per cycle. That is a mechanism,
not a coincidence, and it is the reason the Pawukon is trivially computable
once anchored.

Two of the ten cycles are irregular and are the classic implementation trap:
**Astawara** (8-day) and **Sangawara** (9-day) do not divide 210, so they carry
published *plateaus* — Astawara holds at Kala across cycle days 71–73, Sangawara
holds at Dangu across days 1–4 — which is how the cycle closes cleanly instead
of wrapping mid-week. **Caturwara** (4-day) inherits Astawara's plateau, giving
Jaya 54 occurrences where the others get 52. The engine asserts all of this as
invariants (§6.4).

### 1.2 The ten wewaran

| Cycle | Length | Values |
|---|---|---|
| Ekawara | 1 | Luang (only on odd-Dasawara days; otherwise blank) |
| Dwiwara | 2 | Menga, Pepet |
| Triwara | 3 | Pasah, Beteng, **Kajeng** |
| Caturwara | 4 | Sri, Laba, Jaya, Menala |
| Pancawara | 5 | Paing, Pon, Wage, **Keliwon**, Umanis |
| Sadwara | 6 | Tungleh, Aryang, Urukung, Paniron, Was, Maulu |
| Saptawara | 7 | Redite, Soma, Anggara, Buda, Wraspati, Sukra, Saniscara |
| Astawara | 8 | Sri, Indra, Guru, Yama, Ludra, Brahma, Kala, Uma |
| Sangawara | 9 | Dangu, Jangur, Gigis, Nohan, Ogan, Erangan, Urungan, Tulus, Dadi |
| Dasawara | 10 | Pandita, Pati, Suka, Duka, Sri, Manuh, Manusa, Raja, Dewa, Raksasa |

Each value carries an **urip** — a numeric "life force" weight used in day-quality
arithmetic. `urip(Saptawara) + urip(Pancawara)` is the **neptu**, the number most
padewasan calculations start from.

Dasawara is the odd one out: it is not counted off a position, it is *looked up
by a computed value* 1–10. A reported "source conflict" between Wikipedia and
babadbali on the Dasawara table was investigated and is **not a conflict** —
babadbali's *position* for a name is exactly Wikipedia's *urip* for that name,
for all ten. babadbali additionally publishes a separate credit-point urip. Both
quantities are kept in the engine under distinct names rather than one being
picked and the other lost.

### 1.3 Saka — the lunisolar calendar

The **Saka** calendar (epoch 78 CE, so Saka 1948 ≈ 2026 CE) is lunisolar and
governs Nyepi, the monthly Purnama (full moon) and Tilem (dark moon), and
month-based ritual scheduling. Twelve months (**sasih**): Kasa, Karo, Ketiga,
Kapat, Kelima, Kenam, Kepitu, Kewulu, Kesanga, Kedasa, Jiyestha, Sadha. Each
nominally 30 days: 15 waxing (**Penanggal** 1–15, ending at Purnama) then 15
waning (**Pangelong** 1–15, ending at Tilem).

**The critical fact, and the one that decides the whole implementation:** the
Balinese Saka calendar is *not* an astronomical readout. babadbali states it
outright — *"Penanggalan Bali adalah penanggalan 'konvensi'. Tidak astronomis
seperti penanggalan Islam, tidak pula aritmatis seperti penanggalan Jawa"* (the
Balinese calendar is a *convention*: not astronomical like the Islamic calendar,
nor arithmetic like the Javanese, but roughly between the two). It is a pinned
arithmetic convention owned by a religious authority (PHDI) and re-anchored by
decree — which actually happened in **1971** and again in **2000** (the
*pengalantaka* switchovers).

This was tested rather than assumed. An audit of 50 published Purnama/Tilem
dates against Meeus ch.49 true lunation moments gave the distribution
**{−1 day: 25, 0: 24, +1: 1}** — i.e. **half** of real Balinese dates fall a full
day before the astronomical event, including cases where the true moment is at
midday the following day and cannot be explained away by timezone or evening
reckoning. An ephemeris-driven implementation would therefore disagree with
Balinese practice roughly half the time. **For ceremonial purposes the convention
is the ground truth, not the astronomy.** The engine implements the convention.

Two mechanisms make the convention work:
- **Ngunaratri** — every 63 days one lunar day-number is skipped, compressing
  the nominal 30-day month back toward the real ~29.53-day lunation.
- **Nampih Sasih** — an intercalary month inserted on a Saka-year-mod-19 table
  (this is why "Mala Jiyestha" appears in real almanac output).

---

## 2. Dewasa ayu — how activity guidance is actually derived

**Padewasan** (from *wariga*) is the Balinese science of choosing good and bad
days. *Dewasa* means "day" in the qualitative sense — a day carrying a specific
character. **Dewasa ayu** = a day good for a given purpose; **dewasa ala** = bad
for it; **ala ayuning dewasa** is the umbrella term for the whole practice.

The inputs to any dewasa calculation are five: **wewaran**, **wuku**,
**penanggal/pangelong** (lunar day), **sasih** (lunar month), and **dauh**
(time-of-day watch). The engine implements the first four; **dauh is not
implemented** (§9).

The system is a **catalogue of named day-conditions**, not a formula. Each named
dewasa has a trigger — a conjunction of wewaran/wuku/lunar conditions — and a
published definition stating what it is good and bad for. Example, verbatim from
the source:

> **Agni Agung Doyan Basmi** — *"Bersifat panas, tidak baik membangun rumah,
> terutama tidak baik mengatapi rumah, karena mudah terbakar. Baik untuk mulai
> membakar bata, genteng, gerabah, keramik, tembikar."*
> Triggers: (Anggara ∧ Purnama) ∨ (Anggara ∧ Astawara-Brahma). Alahing 4.

Note the shape: one entry is **simultaneously favourable and prohibitive**, for
different activities. That dual valence is normal in padewasan, not an error, and
any implementation that flattens it into a single good/bad score is lying.

**Named source texts** (lontar), all independently confirmed to exist: *Wariga
Gemet*, *Wariga Dewa*, *Aji Swamandala*, *Wariga Catur Winasa Sari*, *Wariga
Parerisian*, plus the printed secondary literature (*Pokok-Pokok Wariga*,
Ardhana/Arhana; *Wariga Dewasa*, Sri Reshi Ananda Kusuma 1979). Two names the
brief asked about were **not** confirmed: "Sundari Trus" exists only as a *deity*
name inside wariga narrative, not as a lontar title; **"Medaswara" returned
nothing at all** and is recorded as NOT FOUND rather than quietly dropped.

### 2.1 How the engine turns that into a verdict

Fourteen activity classes: building, planting, marriage, travel, business,
agreements, money, ceremony, cremation, haircut, moving_house, medical,
learning, conflict.

Verdict rules, and the reasoning behind each:

1. **Any active dewasa that explicitly prohibits the activity → AVOID.**
   Prohibition dominates: in padewasan practice an *ala* marking outranks a
   co-occurring *ayu* marking for the same purpose.
2. Otherwise, any dewasa that favours it → **FAVOURABLE**.
3. Otherwise → **NEUTRAL**. Neutral genuinely means *"nothing in the catalogue
   speaks to this today"*, not "mildly good."
4. Where both polarities hit the same class, the day is flagged **CONFLICTED**
   and both sides are retained, so the reader sees the tension rather than a
   laundered verdict.
5. **Ingkel** is folded in as a separate source — it is a week-long prohibition
   running with the wuku (Wong/Sato/Mina/Manuk/Taru/Buku), not a dewasa.

Every verdict carries the **verbatim Indonesian clause** that produced it,
because the English activity-class tagging is a translation layer added by this
vault (`ACTIVITY_LEXICON`), **not a Balinese source claim**, and the reader must
be able to audit it.

---

## 3. The ceremonial cycle

### 3.1 Pawukon-governed (computable from the 210-day cycle alone)

**The Galungan sequence** — offsets from Galungan (Buda Keliwon Dunggulan):

| Offset | Day |
|---|---|
| −6 | Sugihan Jawa |
| −5 | Sugihan Bali |
| −3 | Penyekeban |
| −2 | Penyajaan |
| −1 | Penampahan Galungan |
| 0 | **Galungan** |
| +1 | Umanis Galungan |
| +2 | Pemaridan Guru |
| +4 | Ulihan |
| +5 | Pemacekan Agung |
| +9 | Penampahan Kuningan |
| +10 | **Kuningan** |
| +35 | Pegat Wakan |

**Four of these offsets are corrections to the research corpus, not copies of
it.** The corpus gave Sugihan Jawa/Bali as −9/−10, Ulihan as +6 and Pemacekan
Agung as +7. All four are wrong and were caught by re-deriving from wuku
arithmetic rather than trusting the table: Sugihan Jawa is Wraspati Wage wuku
Sungsang = cycle day 68; Galungan is day 74; 74 − 68 = **6**. Ulihan is the first
day of wuku Kuningan = day 78 = Galungan **+4**. Pemacekan Agung is Soma Keliwon
Kuningan = day 79 = **+5**. Each is independently confirmed by Balinese sources
(Dinas Kebudayaan Buleleng, Buleleng Post, ortibali.com). The corpus's own cited
day-names mathematically refuted its own offsets.

**The six Tumpek** (each Saniscara Keliwon of a specific wuku): Tumpek Landep
(Landep), Tumpek Wariga/Uduh/Pengatag (Wariga), Tumpek Kuningan (Kuningan),
Tumpek Krulut (Krulut), Tumpek Kandang (Uye), Tumpek Wayang (Wayang).

**Recurring conjunctions:** Kajeng Keliwon (every 15 days — sub-typed *Enyitan*
in the waxing fortnight, *Uwudan* in the waning), Anggara Kasih, Buda Cemeng
(Buda Wage — financial transactions traditionally avoided), Buda Keliwon.
**Cycle-boundary days:** Saraswati (last day, Watugunung), Banyu Pinaruh,
Soma Ribek, Sabuh Mas, Pagerwesi.

### 3.2 Saka-governed

Purnama and Tilem of each sasih; **Siwaratri** (Tilem of Kepitu); **Tawur Agung
Kesanga** (Tilem of Kesanga, the day before Nyepi); **Nyepi** — the total island
shutdown, airport and all roads and ports closed 24 hours; **Ngembak Geni** the
day after.

### 3.3 Not computable at all

**Odalan** (per-temple anniversaries) are **not derivable by any rule.** Each
temple sets its own on its own founding date, on either cycle. They need a
per-temple table, which this vault does not have and the engine does not ship.
This is a real gap for anyone in Ubud, where the practical question is often
"which local temple has its odalan this week" — the engine cannot answer it.

---

## 4. The "red days / blue days" question — the honest verdict

**Adrian's framing does not map onto a documented Balinese system, and the
software does not pretend it does.**

The findings, ranked by what they actually support:

1. **The real binary is `ayu` / `ala`** (auspicious / inauspicious), per activity,
   not per day, and not colour-coded. This is the system Adrian was describing;
   "red days and blue days" is his own (or ChatGPT's) plain-English gloss over it.

2. **Red is genuinely real, in two unrelated senses.** (a) babadbali's printed
   convention: **Penanggal 1–15 printed in red, Pangelong 1–15 in black** — a
   lunar-fortnight marker, nothing to do with day quality. (b) Indonesian
   *tanggal merah* = public holiday, a purely administrative labour-law
   convention, applied to exactly one Bali-origin day (Nyepi, the only nationally
   gazetted one). These two reds are different things and conflating them would
   be a real bug. The engine exposes the first as `BalineseDay.printed_colour`
   and does not model the second.

3. **Blue has no calendar meaning at all.** It exists only as **Sambhu /
   north-east** in the nine-direction **Nawa Sanga / Pangider Bhuwana** spatial
   cosmology, which governs temple and compound orientation, never a day. The
   five-colour Pancawara scheme — Umanis/white, Paing/red, Pon/yellow,
   Wage/black, Keliwon/*panca warna* — contains **no blue**. There is no such
   thing as a blue Balinese day.

4. **No paired "blue day" convention was found anywhere**, in any Balinese or
   Indonesian source, including Wikipedia's "Red letter day" article checked
   specifically for a contrasting term. If a tidy red/blue binary was ever
   asserted, it was invented to make the story symmetrical.

Two adjacent traditions were checked and ruled out: Javanese *primbon* lucky
colours (a *personal* birth-date luck system, not a calendar-day system), and the
Chinese *Huangli/Tong Shu* almanac (structurally very similar to padewasan — it
does mark each day's suitable and unsuitable activities — but not Balinese and
carrying no red/blue convention).

**Operating consequence:** the daily brief speaks in ayu/ala and per-activity
verdicts. It never uses "red day" or "blue day" as a category, because doing so
would encode a fiction into a system Adrian will make real decisions from.

---

## 5. Implementation architecture

Four files, deliberately layered so each can be corrected without touching the
others.

| File | Role |
|---|---|
| `tools/balinese_calendar.py` | **Engine.** What is true about a given day. Stdlib only, no network at runtime, no ephemeris. |
| `tools/balinese_dewasa_data.py` | **Data.** The 220-entry dewasa rule catalogue. No logic whatsoever. |
| `tools/balinese_day_brief.py` | **Renderer.** Turns a day-reading into the message Adrian reads on a phone. |
| `tools/balinese-day-send.py` | **Delivery.** Archive-first, then a verified channel ladder. |
| `tools/test_balinese_calendar.py` | **Tests.** 565 stdlib-unittest cases, one per sourced fact. |

**Why no ephemeris:** see §1.3. The convention is the ground truth; astronomy
would be wrong half the time.

**Why data is separate from logic:** the dewasa catalogue is a transcription of
someone else's published glossary and will need correction. Corrections must not
require touching the calendar algorithm.

**The one configuration point:** `PIVOTS` in `balinese_calendar.py` holds the two
pengalantaka anchors (2000-01-06 and 1971-01-27). When Bali's authorities next
re-pin the calendar — as they did in 1971 and 2000 — **that block is the only
thing that changes.** `NYEPI_OVERRIDES` similarly lets a single decreed year be
pinned without rebuilding anything.

### 5.1 The confidence vocabulary

Every value the engine returns carries a grade, because not every field of a
Balinese day is equally well established:

- **VERIFIED** — academic algorithm, reproduced against its own reference table
  *and* a live almanac. (Pawukon/wewaran.)
- **SOURCED** — closed-form rule from a primary Balinese source, confirmed live.
- **EMPIRICAL** — no usable published table; read off the live almanac across a
  full cycle with no internal disagreement. Exact for the observed space.
- **CALIBRATED** — arithmetic convention fitted to live data. Correct across the
  validated window; a PHDI re-pinning invalidates it. (The Saka lunar side.)
- **CONTESTED** — computed, but sources disagree with each other or with the
  almanac. The disagreement is documented at the point of use.
- **UNSUPPORTED** — the module refuses to guess; the value is returned as `None`.

Two fields are returned as `None`/UNSUPPORTED rather than fabricated:
**`ekajalaresi`** and **`pratiti_samut_pada`**. No source publishes a formula, and
an independent probe over 70 consecutive live almanac days ruled out every
compact model tested — not a function of (saptawara, pancawara), not of the
tithi, not of `day0 mod n` for n ∈ {7,12,15,16,18,21,24,30,35,42,105}. Only
models with as many free parameters as days fit, i.e. none. They are left blank.

### 5.2 Provenance

- **Pawukon algorithm and epoch** — Dershowitz & Reingold, *Calendrical
  Calculations* (CUP, 2018) p.187, via Wikipedia's transcription of its 210-row
  reference table and via `espinielli/pycalcal`. Epoch: a cycle begins at
  **JDN 146** (= 26 May 4713 BCE proleptic Julian / 18 April proleptic
  Gregorian). *The research corpus gave "3 March 4713 BCE" from Grokipedia; that
  is wrong and was discarded.*
- **Wewaran, urip, deities, Ingkel, Jejepan, Watek, Pangarasan, Pancasuda,
  Rakam, Lintang, the printed red/black convention, the 1993 Nyepi deferral** —
  babadbali.com (Yayasan Bali Galang), fetched as raw HTML 2026-07-27.
- **Dewasa catalogue (220 entries)** — kalenderbali.org "Wewaran Penyusun
  Ala-Ayuning Dewasa" (I Wayan Nuarsa, Universitas Udayana; Kemenkumham
  C00201000668), fetched with `curl` and parsed locally.
- **Saka lunar mechanism** — `peradnya/balinese-date-js-lib` (Apache-2.0) read at
  source level, with constants **re-fitted** here against live data.

**A methodology note worth carrying forward:** the sources were fetched with
plain `curl` and parsed locally, *not* through `WebFetch`. The original research
pass used `WebFetch`, whose summarising model silently dropped ~40% of the dewasa
glossary entries and truncated the two-part "Baik… / Tidak baik…" definitions —
i.e. it dropped exactly the prohibition half. Every research doc in the corpus
complained that Firecrawl was IP-blocked; none of them tried `curl`, which worked
first time on every site they had given up on. **For structured-table extraction,
an AI summariser is a lossy transport. Use `curl`.**

---

## 6. How to run it

```bash
# today's full reading
python3 tools/balinese_calendar.py
python3 tools/balinese_calendar.py 2026-08-15
python3 tools/balinese_calendar.py 2026-08-15 --json

# Adrian's otonan (Balinese 210-day birthday)
python3 tools/balinese_calendar.py --otonan 1972-05-06

# what the module deliberately does NOT compute
python3 tools/balinese_calendar.py --limitations

# validation against the 111-entry anchor set + embedded live fixtures
python3 tools/balinese_calendar.py --selftest

# the brief a human reads
python3 tools/balinese_day_brief.py                  # SMS format, <900 chars
python3 tools/balinese_day_brief.py --format full    # complete markdown reading
python3 tools/balinese_day_brief.py --week           # 7-day look-ahead

# generate + deliver (normally fired by the LaunchAgent)
python3 tools/balinese-day-send.py --dry-run
python3 tools/balinese-day-send.py --force
python3 tools/balinese-day-send.py --channel ntfy

# full test suite (~3 minutes; spawns subprocesses for CLI smoke tests)
python3 tools/test_balinese_calendar.py
```

`--date` defaults to **today in Asia/Makassar (WITA)**, not UTC and not the
machine's locale — Adrian is in Bali, so "today" must be his today.

### 6.1 The daily automation

`com.adrianvault.balinese-day-brief` fires `balinese-day-send.py` at **06:30**.
Its design, in order:

1. **Archive first, always.** The full-detail brief is written to
   `working/state/balinese-days/YYYY-MM-DD.md` *before* any delivery is
   attempted. If every channel fails, the record still exists.
2. **Delivery ladder, stopping at the first PROVEN success:** iMessage to
   `adrian.photon@me.com` → ntfy push (`https://ntfy.sh/adrianvault-fleet`) →
   macOS `display notification`. A channel counts as successful only when
   *verified* — `verify_imessage_sent()` reads the Messages `chat.db` back to
   confirm the message actually landed, because `osascript` exiting 0 is not
   proof of delivery.
3. **Never fails silently.** If the whole ladder fails, the script exits
   non-zero and writes an URGENT handoff into `working/handoffs/` so the next
   Claude session trips over it at bootup.
4. **Idempotent.** A per-date receipt (`.delivery-YYYY-MM-DD.json`) makes a second
   run a no-op. A *failed* prior attempt does not block a retry — that is the
   point of retrying.
5. **Logs to `~/Library/Logs/adrianvault/`, never under `~/Documents`** —
   LaunchAgent stdout/stderr redirects into `~/Documents` are blocked by TCC at
   launchd's pre-exec stage (exit 78 / EX_CONFIG). This vault has been bitten by
   that before; see `memory/feedback-launchagent-logs-not-in-documents-tcc.md`.

---

## 7. How to extend or correct the dewasa ruleset

**Never edit `balinese_calendar.py` to change a day-quality outcome.** The rules
live in `balinese_dewasa_data.py` as data. A rule fires when **any** of its
`triggers` matches; a trigger matches when **all** of its conditions hold
(disjunction of conjunctions):

```python
{
  "name": "Agni Agung Doyan Basmi",
  "definition_id": "<verbatim Indonesian, the authoritative text>",
  "favours_id":    "<the 'Baik ...' half, verbatim>",
  "avoids_id":     "<the 'Tidak baik ...' half, verbatim>",
  "character_id":  "<a stated character rather than a permission>",
  "alahing": 4,          # published severity weight
  "triggers": ((("sapta", "Anggara"), ("moon", "Purnama")),
               (("sapta", "Anggara"), ("ast",  "Brahma"))),
  "notes": (),
}
```

Condition kinds, all of which appear verbatim in the source page's "Wewaran
Penyusun" column: `sapta` · `panca` · `tri` · `sad` · `catur` · `ast` · `sanga` ·
`dasa` · `dwi` · `wuku` · `moon` (Purnama|Tilem) · `sasih` · `phase`
(Penanggal|Pangelong) · `phase_num` · `phase_num_eq_sasih`.

Rules for extending it, in priority order:

1. **Keep the Indonesian verbatim.** The `*_id` fields are the authority. The
   English activity tags are a translation aid this vault added and can be wrong;
   the Indonesian cannot.
2. **Add to `ACTIVITY_LEXICON`, don't hand-tag.** Activity classes are derived
   from keywords in the definition text. Tagging a rule by hand breaks that.
3. **Transcribe as published, even when the publisher is wrong.** `Kala Buingrau`
   is left as printed and flagged, not back-fitted to make the numbers look
   better (§8).
4. **Add a test.** Every sourced fact in `test_balinese_calendar.py` is its own
   test method carrying its source URL in the failure message, so a future
   regression is diagnosable without re-deriving where the number came from.
5. **New ceremonial days** go in `RAHINAN_RULES` / `GALUNGAN_SEQUENCE` / `TUMPEK`
   in the engine — and **re-derive the offset from wuku arithmetic before
   trusting any published table**, which is exactly what caught the four wrong
   offsets in §3.1.

---

## 8. Validation — the real numbers

Two independent test surfaces, reporting different things. Both were re-run on
2026-07-27 and the numbers below are that run, not a claim.

### 8.1 `test_balinese_calendar.py` — **565 tests, 565 passed, 0 failed, 0 errors**

One test per sourced fact across the 111-entry anchor set, plus a **20-date
HOLDOUT set** scraped from kalenderbali.org at seeded-random dates across
1978–2055, deliberately outside every window the engine was fitted against:
**20/20 on the Pawukon triple and 20/20 on the lunar day + sasih**, including the
intercalary "Mala Jiyestha". Four anchor facts have no assertable value (the
source itself states no value) and are reported as such rather than counted as
passes.

### 8.2 `--selftest` — **1,630 assertions, 1,618 passed, 12 failed**

| Layer | Checked | Failed |
|---|---|---|
| Pawukon / wewaran fields | 202 | 0 |
| Holiday derivation rules | 43 | 0 |
| Galungan 210-day spacing | 1 | 0 |
| Saka lunar assertions | 74 | 0 |
| Live-oracle regression (154 days × tithi + sasih) | 308 | **8** |
| Derived cycles (70 days × 5 cycles) | 350 | 0 |
| Dewasa rule activations | 637 | **4** |
| Irregular-cycle invariants | 15 | 0 |

**All 12 failures are known, located, and deliberately not fixed.** They are not
a backlog:

**The 8 lunar failures are all inside the 1993–2003 "Sasih Kesinambungan"
window, where the almanac contradicts itself.** kalenderbali.org shows
2002-03-01 as Kewulu, then labels that same month's Tilem (2002-03-13) "Kedasa",
skipping Kesanga entirely — and does the same thing at 1993-03-23. There is no
correct answer to reproduce. Dates in that window are returned with
`Confidence.CONTESTED` rather than quietly presented as fact, and the test suite
asserts the *contradiction itself*, so if the publisher ever fixes its data the
test fails loudly and tells you to re-derive. Outside that window the live-oracle
regression is **124/124 on tithi and 124/124 on sasih**.

**The 4 dewasa failures are all the single entry `Kala Buingrau`** (1 false
positive, 3 false negatives), whose *published* trigger list disagrees with its
own publisher's daily output — it shares an identical published trigger list with
`Lebur Awu` while producing different daily results. It is transcribed as
published and flagged, **not back-fitted** to make the score look better.
Aggregate on the dewasa engine: 637 activations, **634 true positives**, and
**66/70 days reproduced exactly**.

---

## 9. Confidence and limitations

This section is the point of the document. **A canonical note that overstates its
own reliability is worse than no note.**

### Well-sourced — trust it

- **The Pawukon side is the strongest layer in the whole system.** The algorithm
  is academic (Dershowitz & Reingold), independently reproduced against its own
  210-row reference table, cross-checked against `pycalcal`, and validated
  against a live Balinese almanac across 1971–2055 including a blind holdout.
  The irregular Astawara/Sangawara/Caturwara plateaus are asserted as invariants.
  **This layer will not drift and does not need re-pinning.**
- **The wewaran names, urip, deities and directions** come from a primary
  Balinese source (babadbali) and reproduce live almanac output exactly.
- **The derived cycles** — lintang, pancasuda, jejepan, watek, pangarasan —
  reproduce 70/70 against live pages.
- **The dewasa catalogue transcription** is verbatim from a single named,
  copyrighted, bibliography-publishing source, machine-parsed rather than
  AI-summarised.

### Approximate — will eventually break

- **The Saka lunar side is CALIBRATED, not derived.** It is an arithmetic
  convention fitted to live data. It is exact across the validated window and
  **a PHDI re-pinning invalidates it.** That has happened twice in living memory
  (1971, 2000). When it happens again, `PIVOTS` is the fix; do not rebuild.
- **Dates before roughly 1975 are UNVALIDATED.** The 1971 pivot carries a
  one-tithi discontinuity in its first weeks: live output for 1971-01-27/28 and
  1971-02-01 is one tithi ahead of what the constants produce, while every probe
  from 1975-06-15 onward matches exactly.
- **The 2000-01-06 switchover fortnight is unreliable** — the almanac labels
  2000-01-06 "Tilem Kepitu" and 2000-01-18 "Penanggal 13 Kepitu", which cannot
  both be true of one continuous month.
- **The 1993–2003 window is CONTESTED** (§8.2). Treat any lunar reading in it as
  indicative.
- **Nyepi 2027 is genuinely disputed between published sources.**
  kalenderbali.org gives 8 March 2027; Wikipedia, officeholidays.com,
  tanggalans.com and husniadil.com give 9 March, and the true new moon
  (2027-03-08 17:29 WITA) leans to the 9th. The engine reproduces
  kalenderbali.org. **Use `NYEPI_OVERRIDES` to pin the year if PHDI decrees
  otherwise.**
- **Nyepi can be deferred by decree** — babadbali records that Nyepi 1993 was
  pushed back one day because penanggal 1 collided with a pangunalatri. No
  algorithm predicts a decree.
- **Nyepi is the first day of sasih Kedasa, which is not always penanggal 1.**
  When the ngunaratri correction lands on the month boundary, penanggal 1 is
  skipped. This silently ate Nyepi in **1976, 1989 and 2020** until it was fixed
  on 2026-07-27. Anything that re-derives Nyepi must test the month boundary,
  never the lunar-day number.

### Not implemented at all — do not expect it

- **`ekajalaresi` and `pratiti_samut_pada`** — no published formula, empirically
  unmodellable (§5.1). Returned as `None`.
- **`dauh`** — the time-of-day watch, a genuine fifth input to real padewasan.
  Not implemented. Every reading is whole-day.
- **Odalan** — per-temple, not computable by any rule (§3.3).
- **`tanggal merah`** — Indonesian national public holidays are not modelled;
  only Nyepi appears, and it appears because it is a Saka day, not because it is
  gazetted.

### The interpretive caveat, stated plainly

The English activity classes are **a translation layer this vault invented**, not
a Balinese source claim. "Baik untuk membuat bendungan" (good for building a dam)
becomes `favours: building/construction` by keyword match. That is a useful
approximation and it is also a lossy one. The verbatim Indonesian is carried
through to the archived brief for exactly this reason — **when a verdict matters,
read the clause, not the label.**

And the largest caveat of all: this engine reproduces *one published almanac's
reading* of a living tradition in which practitioners disagree, regional
variation is real, and a Balinese priest's judgment on a specific undertaking
outranks any table. It is a decision *input*, not an oracle.

---

## 10. Operating notes for a future Claude session

- **Never invent a "red day" or "blue day."** §4. The vocabulary is ayu/ala.
- **Never back-fit a rule to improve the score.** `Kala Buingrau` stays wrong
  because its publisher is wrong. A green test suite that lies is worse than a
  documented failure.
- **Re-derive ceremonial offsets from wuku arithmetic** before trusting any
  published table, including this one. That method caught four errors the
  research corpus stated as confirmed.
- **`curl` and parse locally** for structured Balinese sources. `WebFetch`'s
  summariser drops table rows and truncates two-part definitions.
- **If the daily brief stops arriving,** check
  `~/Library/Logs/adrianvault/balinese-day-brief.log` first — it names the
  carrying channel every morning — then `working/handoffs/` for the URGENT
  handoff the sender writes on total failure.

---

revision_history:
- 2026-07-27 — created. Built in one session from a six-document research corpus
  (`working/_research/2026-07-27-balinese-calendar/`) plus an adversarial
  verification pass that refuted nine of the corpus's own factual claims. Records
  the engine (`tools/balinese_calendar.py`), the 220-entry data catalogue, the
  renderer, the 06:30 delivery agent, and — as its most load-bearing content —
  §9's honest split between the VERIFIED Pawukon layer and the CALIBRATED Saka
  layer that a PHDI re-pinning will eventually invalidate. The "red days / blue
  days" framing that started the work is resolved in §4 as **not a Balinese
  system**: the real binary is ayu/ala, red is a lunar-fortnight print convention
  (and separately an Indonesian holiday convention), and blue has no calendar
  meaning at all.
