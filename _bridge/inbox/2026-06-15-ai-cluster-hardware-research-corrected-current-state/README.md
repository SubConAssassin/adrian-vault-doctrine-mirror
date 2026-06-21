# AI Cluster Hardware Research — Corrected Current State

Date: 2026-06-15  
Authoring system: ChatGPT  
Audience: Claude / Antigravity / GitHub Bridge / Obsidian / Grok / CLI agents  
Classification: doctrine + status + procurement brief + action plan  
Status: latest operative update; supersedes earlier bridge notes where contradicted

---

## 1. Executive Summary

The earlier plan changed because the M1 Ultra Mac Studio order fell through. Adrian has received the money back. The previously discussed M2 Ultra Mac Pro 192GB / 8TB listing was also already sold and is not available. The M3 has been sold. Adrian is now re-evaluating practical dry-room nodes while still aiming for a future high-memory 192GB+ Ultra node and a Hong Kong-purchased M5 Max MacBook Pro.

Current live decision points:

1. Whether to buy an official-reseller M2 Ultra 64GB Mac Studio for about Rp70 million.
2. Whether to add a cheaper M2 Max 32GB Mac Studio for about Rp26 million as an Antigravity IDE / CLI node.
3. Whether to buy Atti’s M1 Max 64GB MacBook Pro for about Rp25 million as a dry-room research node, despite broken Touch ID.
4. Whether an M4 Mac mini 16GB/256GB at around Rp12.9 million is useful as a cheap cloud-CLI scout node.
5. Whether to prioritize the M5 Max 128GB MacBook Pro in Hong Kong before heavier fixed nodes.
6. How to plan external SSD / NAS storage now that the 1TB M1 Ultra did not materialize.

Core conclusion: Adrian’s missing strategic capability is still a single high-memory 192GB+ Apple Silicon node. Mid-tier machines can add parallel cloud-agent throughput, but they do not replace the local-model capability unlocked by 192GB+ unified memory.

---

## 2. Corrected Current Hardware Status

### 2.1 M1 Ultra Mac Studio 64GB / 1TB

Status: order fell through.

The seller did not send the machine despite same-day delivery, then stated the stock was empty. Adrian has received the money back. This machine should no longer be counted as purchased or incoming.

### 2.2 M3 MacBook

Status: sold.

The M3 has been sold and should not be counted in the future node architecture.

### 2.3 Current M1 Max 64GB MacBook Pro

Status: owned, possible future sale.

Known:
- 64GB unified memory.
- 2TB SSD.
- Adrian was considering selling it for about Rp33 million once the M5 Max replaces it.

Observed real-world capacity:
- Around four CLI connections in practical mixed use.
- Around two genuinely heavy coding windows.

This observed operational ceiling should be weighted more strongly than theoretical benchmark assumptions.

### 2.4 Atti’s M1 Max 64GB MacBook Pro

Status: optional purchase.

Offered price: about Rp25 million.

Known issue:
- Touch ID / fingerprint button does not work.

Potential value:
- More attractive than a 32GB M2 Max Studio for multi-agent research work because it has 64GB RAM.
- Good as a dry-room research bureau / overflow node if the rest of the machine is healthy.

Must verify:
- Exact SSD capacity.
- Battery cycle count and battery health.
- Power button functionality.
- Cause of Touch ID failure.
- MDM status.
- Activation Lock / iCloud status.
- All ports, screen, keyboard, trackpad, Wi-Fi.
- Apple Diagnostics.
- Any liquid damage history.

### 2.5 2014 Intel i7 MacBook Pro 16GB

Status: owned.

Recommended role:
- Lantern / watchdog / dashboard / emergency admin terminal.

Use for:
- SSH into other nodes.
- LAN health checks.
- NAS and backup status.
- Logs and dashboards.
- Emergency admin access.

Do not use for:
- Heavy coding agents.
- Antigravity IDE work.
- Local LLMs.
- Large repos or builds.

---

## 3. Planned Commander Node: M5 Max MacBook Pro 128GB

Status: planned, not yet purchased.

Likely source: Apple Hong Kong.

Known configuration being considered:
- 16-inch MacBook Pro.
- M5 Max.
- 128GB unified memory.
- At least 2TB SSD.
- 4TB internal SSD still under consideration.

Previously observed Hong Kong price:
- HK$43,624 for 128GB / 2TB configuration.

2TB to 4TB upgrade:
- About HK$4,500.
- Around US$574 at the checked rate.

Decision framework:
- 2TB is better value if fast external SSD/NAS will be used.
- 4TB is better if Adrian wants maximum standalone travel capability and local model/dataset storage on flights and while away from the dry room.

Recommended role:
- Commander / mobile cockpit.
- Human-facing strategy, review, prompt design, Antigravity control, Claude work, and remote control of dry-room nodes.

---

## 4. Official Reseller M2 Ultra 64GB Mac Studio at Rp70 Million

Status: under consideration.

Claimed by Adrian:
- Official Apple reseller.
- M2 Ultra Mac Studio.
- 64GB unified memory.
- Approximately Rp70 million.

Currency context:
- Rp70 million is roughly US$3,950–4,000 depending exchange rate.

Interpretation:
- This is close to the original US launch price of the base M2 Ultra Mac Studio.
- It is a powerful, clean dry-room node, but not a bargain if it is only 64GB / 1TB / 60-core GPU.
- It gives strong CPU/GPU/bandwidth and desktop thermals, but it does not unlock larger local models compared with any other 64GB Ultra-class node.

Key value issue:
- The M2 Ultra 64GB is much stronger than M2 Max 32GB or M1 Max 64GB for sustained throughput.
- However, the main missing capability in Adrian’s stack is not simply compute at 64GB. It is 192GB+ unified memory.

Suggested buying thresholds:

At Rp70m:
- Fair only if sealed/new, official warranty, strong reseller, and ideally better than base spec.
- Better if it has 76-core GPU or 2TB+ SSD.
- Less attractive if it is base 60-core GPU / 64GB / 1TB.

Negotiation target:
- For base 64GB/1TB/60-core, try Rp60–65m.
- At Rp70m, expect official warranty, clean provenance, and ideally a stronger configuration.

Recommended role if purchased:
- Main temporary Forge node until a 192GB+ machine appears.
- Heavy Antigravity, builds, tests, multiple cloud CLIs, indexing, moderate local models.

Limit:
- Still only 64GB. Does not replace future 192GB+ node.

---

## 5. M2 Max Mac Studio 32GB / 512GB at Rp26 Million

Status: Marketplace candidate.

Known listing details:
- Mac Studio M2 Max.
- 32GB unified memory.
- 512GB SSD.
- Around Rp26 million.
- Used about four months, according to listing.
- No box mentioned in earlier seller conversation.

Best role:
- Dedicated Antigravity IDE appliance / Bridgekeeper / CI / Scout node.

Strengths:
- Desktop cooling.
- Built-in 10Gb Ethernet.
- Better always-on node than a closed-lid laptop.
- Good for one persistent Antigravity instance, browser/terminal agents, test/build loops, and cloud CLI work.
- Cheap compared with Ultra-class machines.

Weaknesses:
- 32GB RAM limits simultaneous heavy IDE/agent workloads.
- 512GB SSD is small for multiple repos, Docker, build caches, screenshots, browser artifacts, and local data.
- Not a high-memory local-model node.

Expected practical load:
- 2–3 heavy Antigravity/coding workspaces.
- 4–6 moderate agent/workspace tasks.
- 6–8 lightweight cloud-research CLIs if kept lean.
- Poor fit for large local LLM workloads.

Price view:
- Rp26m is fair.
- Try to negotiate toward Rp24–25m.

Recommended if:
- Adrian wants a dedicated always-on Antigravity IDE node.
- M1 Ultra is no longer available and a clean desktop appliance is useful.
- It does not delay the M5 Max or future 192GB+ node.

Not recommended as:
- Main high-memory Forge.
- Replacement for a 64GB+ node in multi-agent memory-heavy work.

---

## 6. M4 Pro Mac mini 24GB / 512GB at Rp34.754 Million

Status: evaluated and not preferred.

Known listing:
- M4 Pro Mac mini.
- 24GB RAM.
- 512GB SSD.
- Around Rp34.754m.

Compared with M2 Max Studio 32GB at Rp26m:
- M4 Pro has newer/faster CPU cores.
- M2 Max Studio has more RAM, more memory bandwidth, stronger GPU, built-in 10GbE, and lower price.

Conclusion:
- For a personal everyday desktop, M4 Pro could feel snappier.
- For Adrian’s Antigravity / multi-agent dry-room node, M2 Max Studio is better value because RAM and memory bandwidth matter more than isolated single-core speed.

Recommendation:
- Do not buy the M4 Pro 24GB Mac mini for this stack at Rp34.754m.
- It becomes more interesting only with 48GB RAM or a much lower price.

---

## 7. M4 Mac mini 16GB / 256GB at Rp12.9 Million

Status: potential cheap CLI node.

Known listing:
- Apple Mac mini M4.
- 16GB unified memory.
- 256GB SSD.
- Around Rp12.9m.
- Secondhand, condition claimed 99%.

Best role:
- Scout / lightweight cloud-CLI bureau.

Useful for:
- Independent internet research agents.
- Claude/ChatGPT/Grok CLI sessions.
- GitHub bridge checks.
- Documentation generation.
- Monitoring and scheduled scripts.
- Lightweight repo inspection.

Expected practical capacity:
- 5–8 lightweight terminal research CLIs.
- Possibly 8–10 extremely light cloud-response CLIs.
- 3–4 mixed coding CLIs on small/medium repos.
- 1–2 heavy coding/build/browser sessions.
- Not suitable as a serious local LLM node.

Weaknesses:
- 16GB RAM.
- 256GB SSD.
- Standard Gigabit Ethernet unless upgraded.

Conclusion:
- Good value as a cheap isolated cloud-CLI worker.
- Not a replacement for M1 Ultra, M2 Max Studio, M2 Ultra, or M5 Max.
- Worth considering if Adrian has enough account/token capacity to keep another research team useful.

---

## 8. Atti M1 Max 64GB vs M2 Max Studio 32GB

If choosing between Atti’s M1 Max 64GB at Rp25m and M2 Max Studio 32GB at Rp26m:

Choose Atti’s M1 Max if:
- the goal is multi-agent research concurrency;
- 64GB memory matters;
- the broken Touch ID is harmless;
- the machine passes health checks.

Choose M2 Max Studio if:
- the goal is a clean always-on Antigravity appliance;
- desktop thermals, no battery, and built-in 10GbE matter;
- 32GB is acceptable for narrower workloads.

For Adrian’s Presidential Protocol, the 64GB M1 Max is generally more useful than a 32GB M2 Max if the condition is good.

For dedicated Antigravity IDE appliance work, the M2 Max Studio is cleaner.

---

## 9. Presidential Protocol / Multi-Agent Research Doctrine

Adrian’s working method prioritizes collective multi-source research over a single model answer.

Operational pattern:
1. Commander defines the question.
2. Several agents research separate angles.
3. Each returns findings and unique nuggets.
4. A critic challenges assumptions.
5. A verifier checks claims.
6. A synthesizer consolidates.
7. Commander reviews and decides.

This can outperform one model’s first-pass response because independent agents often discover unique points or corroborate each other’s findings.

Hardware implication:
- More nodes create more independent work lanes.
- But more small nodes do not equal one high-memory node.
- The 192GB+ node remains strategically important.

---

## 10. Why 192GB+ Still Matters

Multiple 16GB/32GB/64GB/128GB machines increase parallelism, not single-model memory capacity.

A future 192GB+ Ultra node unlocks:
- larger quantized local LLMs;
- larger context/KV cache;
- heavier embeddings/indexing;
- multiple local models resident together;
- local privacy workflows;
- larger data-processing jobs.

M2 Ultra maximum target:
- 192GB unified memory.

M3 Ultra-style progression:
- 256GB can be worthwhile only if a real workload needs more than 192GB.
- 512GB-class hardware is justified only when local AI workloads exceed 192GB/256GB, or when local inference becomes revenue-producing or API-cost-saving infrastructure.

More Claude CLI windows alone do not justify 512GB.

---

## 11. External SSD Strategy

The M1 Ultra 1TB plan is no longer active, but the general storage research remains relevant for any 512GB/1TB dry-room node.

Best value target for a working external SSD:
- 4TB genuine NVMe SSD.
- USB4 / Thunderbolt 40Gbps enclosure.
- Around Rp8m budget target if possible.

Recommended use:
- local models;
- Dropbox selected working sets;
- datasets;
- project mirrors;
- repos not needing maximum internal SSD random I/O;
- build artifacts;
- temporary AI-processing files.

Avoid:
- generic USB-C drives with vague speed claims;
- fake high-capacity drives;
- suspicious 8TB/16TB/256TB products at impossible prices.

Preferred SSD/enclosure classes:
- Lexar NM790 4TB non-heatsink.
- TeamGroup MP44 4TB.
- ORICO / UGREEN / Acasis USB4 40Gbps enclosures.
- Enclosure should state USB4 40Gbps or Thunderbolt-class support and include a genuine 40Gbps cable.

Important:
- One external SSD is not a redundant backup.

---

## 12. NAS Research

A low-end UGREEN NAS description was evaluated.

Specs included:
- 1GbE.
- 4GB RAM.
- No M.2 NVMe support.
- Around 125MB/s transfer ceiling.

Conclusion:
- OK for basic home/family photo backup.
- Not recommended as Adrian’s main AI-cluster NAS.

Main problem:
- 1GbE is too slow for serious multi-node AI workflow storage.

Preferred NAS minimum:
- 4 bays.
- 2.5GbE minimum.
- 8GB RAM minimum.
- NVMe slots.
- snapshots.
- UPS support.

Better:
- 4–6 bays.
- 10GbE or upgrade path.
- 16GB+ RAM.
- NVMe support.
- RAID/SHR with snapshots.
- offline backup rotation.

Doctrine:
- SSD is for speed.
- NAS is for capacity and redundancy.
- Offline backup is for true disaster protection.
- RAID is not backup.

---

## 13. Fake Storage Warning

A Tokopedia listing claiming 256TB portable SSD for around Rp2.1m was reviewed.

Conclusion:
- Almost certainly fake-capacity storage.

Reason:
- impossible price/capacity ratio;
- generic branding;
- inconsistent title/capacity;
- very low review count;
- common firmware-capacity scam pattern.

Doctrine:
- Do not buy unbranded impossible-capacity storage.
- Do not trust any drive for backups without full capacity testing.

---

## 14. Updated Procurement Priority

Given the M1 Ultra order failed, current recommended priority is:

1. Secure the M5 Max 128GB MacBook Pro in Hong Kong as Commander.
2. Decide whether a temporary/permanent dry-room node is needed before the 192GB+ node.
3. If buying an official reseller M2 Ultra 64GB at Rp70m, negotiate and confirm exact GPU/SSD/warranty.
4. If buying a cheaper node, choose based on role:
   - M2 Max 32GB Studio for Antigravity IDE appliance.
   - Atti M1 Max 64GB for research-swarm memory headroom.
   - M4 mini 16GB for cheap CLI scout work.
5. Source a genuine fast 4TB USB4 NVMe external drive for whichever dry-room node has limited internal storage.
6. Continue verified search for a 192GB+ Ultra node.
7. Buy NAS later with 2.5GbE minimum, preferably 10GbE path.

---

## 15. Current Best Interpretation

The M2 Ultra 64GB at Rp70m is powerful but awkward: it is high-throughput but still low-memory relative to Adrian’s long-term objective.

The M2 Max 32GB at Rp26m is a good-value dedicated Antigravity appliance, but memory-limited.

Atti’s M1 Max 64GB at Rp25m may be the best value for a pure research-swarm node, provided it passes verification.

The M4 mini 16GB at Rp12.9m is useful only as a cheap cloud-CLI scout node.

The M5 Max 128GB remains the most important near-term personal productivity upgrade.

The future 192GB+ node remains the most important strategic local-AI capability upgrade.

---

## 16. Immediate Questions for Claude to Track

1. What exact configuration is the official-reseller M2 Ultra 64GB? GPU cores? SSD? Warranty? Sealed or used?
2. Does Atti’s M1 Max have 512GB, 1TB, or 2TB SSD?
3. Is the broken Touch ID isolated or evidence of broader top-case/liquid damage?
4. Is the M2 Max Studio still available, and can it be negotiated to Rp24–25m?
5. Is the M4 mini useful enough to justify adding another account/CLI lane?
6. Should the Hong Kong M5 be 2TB or 4TB?
7. Which exact Tokopedia SSD/enclosure listing is genuine and best value?
8. What verified 192GB+ Ultra listings are available now?

---

## 17. Bridge Reply to Claude

Findings:
The M1 Ultra order failed and was refunded. The M3 is sold. The M2 Ultra Mac Pro 192GB/8TB listing is unavailable. The M5 Max 128GB remains planned. Adrian is comparing a Rp70m official-reseller M2 Ultra 64GB, a Rp26m M2 Max 32GB Studio, Atti’s Rp25m M1 Max 64GB, and a Rp12.9m M4 mini 16GB.

Action taken:
This corrected comprehensive hardware research brief has been written to Google Docs and to the GitHub Bridge.

Verification requirement:
Claude should treat this document as the current corrected state and not rely on earlier assumptions that the M1 Ultra is arriving or that the 192GB/8TB Mac Pro is available.

Blocker:
No high-memory 192GB+ node is secured. No exact fast 4TB SSD/enclosure listing has been verified.

Recommendation:
Prioritize the M5 Max Commander, then choose the next dry-room node by role: M2 Ultra 64GB only if well-specified and negotiated; M2 Max 32GB for dedicated Antigravity appliance; Atti M1 Max 64GB for research-swarm memory; M4 mini 16GB only as a cheap CLI scout. Continue sourcing a true 192GB+ node.
