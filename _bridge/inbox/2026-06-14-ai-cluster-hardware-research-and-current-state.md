# AI Cluster Hardware Research and Current State

Date: 2026-06-14  
Authoring system: ChatGPT  
Audience: Claude / Antigravity / GitHub Bridge / Obsidian / Grok / CLI agents  
Classification: doctrine + status + action + procurement brief  
Status: current operative summary; supersedes earlier assumptions where explicitly corrected below

---

# 1. Purpose

This document consolidates the recent hardware, sourcing, storage, networking, node-role, and multi-agent orchestration research for Adrian's evolving local AI cluster.

It is intended to let Claude understand:

- what hardware is already purchased;
- what hardware has been sold;
- what remains planned;
- which previously discussed units are no longer available;
- how each node should be used;
- what each node can realistically handle;
- which future upgrades actually unlock new capability;
- the current storage/NAS strategy;
- the remaining procurement tasks.

This document should be treated as the current hardware-state handoff for future planning.

---

# 2. Existing AI Memory and Bridge Architecture

Adrian already has a mature external-memory architecture. Do not design a new memory system from zero.

Current system:

- Obsidian installed.
- Obsidian vault synchronized over iCloud.
- Graph/knowledge tooling used around the vault.
- Full shutdown protocol already performed after major work.
- Lessons, architectural changes, and new systems written into the Obsidian vault.
- GitHub used as a bridge between ChatGPT, Claude, Grok, Antigravity, and CLI tools.
- Multiple AI CLIs available.
- Antigravity used for high-volume development and agent workflows.

Operating principle:

- Obsidian is the human-readable long-term memory and doctrine layer.
- GitHub is the machine-readable bridge and code/state layer.
- Repo-local files are the project-specific operational state.
- Future NAS/external storage will be the durable large-data/archive layer.

Every serious AI session should:

1. Read current doctrine, project state, handoff, decisions, and blockers.
2. Execute the assigned task.
3. Update lessons, architecture, state, handoff, blockers, and next action.
4. Verify every write by read-back before claiming success.

---

# 3. Current Confirmed Hardware Status

## 3.1 Confirmed purchase: M1 Ultra Mac Studio

Adrian has already paid for:

- Mac Studio
- M1 Ultra
- 64GB unified memory
- 1TB SSD

Expected arrival: Monday following the conversation.

This unit is no longer hypothetical. It is the confirmed first serious dry-room node.

Recommended role:

**Secondary Forge / Presidential Protocol research-and-coding node**

Primary uses:

- multi-agent cloud CLI research;
- Claude/ChatGPT/Grok CLI sessions;
- coding windows;
- build/test jobs;
- GitHub bridge operations;
- Obsidian synchronization and structured handoff work;
- sustained desktop workloads better suited to a Studio than a closed-lid laptop.

The 1TB internal SSD is relatively limited for the intended workload, so a fast external SSD is a near-term priority.

## 3.2 M3 MacBook status

The M3 MacBook has been sold and is due to leave on Sunday in Bali.

Do not include it in future node counts or architecture planning.

## 3.3 Current M1 Max 64GB MacBook Pro

Adrian's current M1 Max MacBook Pro has:

- 64GB unified memory;
- 2TB SSD.

Adrian is considering selling it to his friend Atti for approximately Rp33 million once the M5 Max replaces it as his mobile machine.

Observed practical capacity from Adrian's real use:

- around four CLI connections;
- around two genuinely heavy coding windows.

This real-world observation should be weighted more heavily than generic theoretical estimates.

## 3.4 Atti's M1 Max 64GB MacBook Pro

Atti has offered Adrian an M1 Max 64GB MacBook Pro for approximately Rp25 million.

Known issue:

- Touch ID / fingerprint button does not work.

Unknown or still to verify:

- exact SSD size;
- battery health and cycle count;
- whether the power button itself works normally;
- cause of Touch ID failure;
- whether there was previous liquid damage or top-case repair;
- MDM status;
- Activation Lock/iCloud status;
- overall condition.

Potential role if purchased:

**Dedicated Research Bureau / overflow multi-agent node**

For a headless or mostly remote dry-room node, broken Touch ID is not operationally critical if:

- the physical power button works;
- password/admin authentication works;
- FileVault access is normal;
- no MDM or Activation Lock exists;
- all ports and networking are healthy.

## 3.5 Legacy 2014 Intel MacBook Pro

Existing machine:

- 2014 Intel i7 MacBook Pro;
- 16GB RAM.

Recommended role:

**Lantern / watchdog / dashboard / emergency admin terminal**

Appropriate uses:

- LAN health checks;
- NAS status display;
- backup progress display;
- SSH terminal into stronger nodes;
- log tailing;
- router/admin utilities;
- read-only bridge status dashboard;
- emergency control if other machines are busy.

Do not use it for heavy coding agents, modern local LLMs, or memory-intensive workflows.

---

# 4. Planned Hardware

## 4.1 Planned mobile commander: M5 Max MacBook Pro

Planned configuration:

- 16-inch MacBook Pro;
- M5 Max;
- 128GB unified memory;
- at least 2TB SSD;
- 4TB internal SSD still under consideration.

Likely purchase location:

- Hong Kong, because Adrian has friends there and can arrange pickup/delivery support.

Known Apple Hong Kong configuration price previously inspected:

- HK$43,624 for the configured 128GB / 2TB machine shown in Apple's Hong Kong store.

The 2TB-to-4TB internal-storage upgrade was approximately:

- HK$4,500, roughly US$574 at the rate checked during the conversation.

Decision framework:

Choose 2TB if:

- external USB4 storage and NAS will be used;
- the MacBook primarily carries active work, selected local models, Obsidian, and repos;
- value is prioritized.

Choose 4TB if:

- Adrian wants the MacBook to be strongly self-sufficient on flights and while travelling;
- several large local models/datasets must remain onboard;
- convenience and future-proofing are worth the extra HK$4,500.

Recommended role:

**Commander / mobile cockpit / primary human-facing workstation**

Primary uses:

- Adrian's live work;
- strategy and review;
- high-priority Claude/Antigravity sessions;
- controlling dry-room nodes remotely;
- local AI while travelling or offline;
- final synthesis and approval.

## 4.2 Future high-memory node: M2 Ultra 192GB or larger

Adrian still intends to acquire a high-memory Ultra-class node because 192GB+ unified memory unlocks local models that 64GB and 128GB machines cannot hold.

Important correction:

A previously discussed Indonesian Mac Pro listing with:

- M2 Ultra;
- 192GB unified memory;
- 8TB SSD;
- 76-core GPU;

had already been sold and is unavailable.

Do not include it as secured, available, or pending purchase.

Current status:

- no M2 Ultra 192GB machine is secured;
- future sourcing remains open;
- possible sourcing markets include the US, Hong Kong, Singapore, Indonesia, or later used/refurb inventory.

Potential future options:

- M2 Ultra Mac Studio 192GB;
- M2 Ultra Mac Pro 192GB if priced correctly;
- M3 Ultra 256GB or larger if the workload and price justify it.

Primary reason for this node:

- larger single-machine memory envelope;
- local inference for larger LLMs;
- large embedding/index workloads;
- multiple resident local models;
- heavy data processing;
- workloads where separate smaller nodes cannot substitute for one large unified-memory domain.

---

# 5. Current Recommended Cluster Architecture

## 5.1 Near-term architecture after M1 Ultra arrival

| Role | Machine | Memory | Status |
|---|---|---:|---|
| Secondary Forge / Presidential Protocol node | M1 Ultra Mac Studio | 64GB | Purchased; arriving Monday |
| Current mobile workstation | M1 Max MacBook Pro | 64GB | Owned; possible future sale |
| Lantern / watchdog | 2014 Intel MacBook Pro | 16GB | Owned |
| M3 MacBook | — | — | Sold; leaving Sunday |

## 5.2 Planned architecture after M5 purchase

| Role | Machine | Memory | Status |
|---|---|---:|---|
| Commander | M5 Max MacBook Pro | 128GB | Planned Hong Kong purchase |
| Secondary Forge / Research Cabinet | M1 Ultra Mac Studio | 64GB | Purchased |
| Optional Research Bureau | Atti's M1 Max MacBook Pro | 64GB | Optional purchase at Rp25m |
| Lantern | 2014 Intel MacBook Pro | 16GB | Existing utility node |
| Future Main Forge / Local Intelligence | M2 Ultra 192GB or larger | 192GB+ | Still to source |

## 5.3 Mature target architecture

| Role | Preferred machine | Function |
|---|---|---|
| Commander | M5 Max 128GB MacBook Pro | Human-facing command, review, mobile work, travel/offline AI |
| Main Forge | M2 Ultra 192GB or larger Ultra | High-memory local inference and heaviest workloads |
| Secondary Forge | M1 Ultra 64GB Studio | Sustained coding, research swarms, build/test, services |
| Research Bureau | Optional M1 Max 64GB | Separate Presidential Protocol team / overflow agents |
| Lantern | 2014 i7 16GB | Monitoring, dashboards, SSH, NAS and backup status |

---

# 6. M1 Ultra 64GB vs M1 Max 64GB

## 6.1 What the M1 Ultra improves

Compared with the M1 Max 64GB MacBook Pro, the M1 Ultra Studio offers:

- significantly stronger multi-core throughput;
- substantially stronger GPU throughput depending on exact GPU configuration;
- approximately double the memory bandwidth class;
- much better sustained cooling;
- better suitability for always-on work;
- stronger parallel workload handling;
- better desktop-node behaviour.

What it does not improve:

- maximum model size determined by unified-memory capacity remains broadly similar because both have 64GB;
- it does not unlock the 192GB-class local-model tier.

Practical interpretation:

- M1 Max 64GB = capable mobile/secondary worker;
- M1 Ultra 64GB = much better sustained stationary worker;
- M2 Ultra 192GB = new memory-capability tier.

## 6.2 Expected practical concurrency

These are working estimates, not hard limits.

M1 Ultra 64GB likely starting range:

- 4 serious heavy coding windows comfortably;
- around 6 heavy windows possible after measurement/tuning;
- 6–10 mixed coding/research CLIs;
- 12–16 lightweight cloud-research CLIs if they are not all running browsers, Docker, large builds, or local models.

Adrian should begin conservatively, measure memory pressure/swap/thermals, then increase concurrency.

---

# 7. Optional Additional Node: Atti's M1 Max 64GB vs M2 Max 32GB

A Facebook Marketplace M2 Max Mac Studio was shown at approximately:

- Rp26 million;
- 32GB unified memory;
- 512GB SSD;
- no box.

Atti's alternative:

- M1 Max MacBook Pro;
- 64GB unified memory;
- Rp25 million;
- broken Touch ID;
- storage still to confirm.

## 7.1 Recommendation for Adrian's cluster

For Adrian's specific multi-agent/research-node use, the M1 Max 64GB is generally the better addition at similar money because:

- it has twice the memory;
- it tolerates more concurrent agents, browser processes, language servers, large repos, and mixed workloads;
- it provides another 64GB memory domain;
- the M2 Max's per-task speed advantage does not compensate for losing half the memory in swarm-style work.

The M2 Max 32GB Studio is better when:

- simple desktop appliance behaviour matters most;
- built-in 10GbE matters;
- sustained cooling and one or two fast jobs matter more than concurrency;
- the node is primarily CI/build/monitoring rather than multi-agent work.

The M1 Max 64GB is better when:

- the node runs a separate Presidential Protocol research team;
- many cloud CLIs run simultaneously;
- larger repos and mixed workloads are common;
- memory headroom is more important than modestly faster single-task execution.

## 7.2 Rough node capacity estimates

M1 Max 64GB based on Adrian's actual experience:

- about 4 CLI connections in practical mixed use;
- about 2 heavy coding windows;
- potentially 6–8 lightweight research-only CLIs if carefully configured.

M2 Max 32GB rough estimate:

- around 3–5 lightweight research CLIs;
- around 2–3 mixed coding agents;
- around 1–2 genuinely heavy coding/build sessions.

The M1 Ultra remains the superior primary 64GB dry-room node.

## 7.3 Purchase conditions for Atti's machine

Before purchase verify:

- exact SSD capacity;
- battery cycle count and health;
- power button function;
- cause of Touch ID failure;
- all Thunderbolt ports;
- Wi-Fi and display;
- no MDM enrollment;
- no Activation Lock;
- Apple Diagnostics passes;
- no liquid-damage signs;
- acceptable resale discount for broken Touch ID.

---

# 8. Presidential Protocol / Multi-Agent Research Doctrine

Adrian's preferred method is collective multi-source research rather than relying on a single model's first-pass answer.

Core pattern:

1. Commander defines the question and research standard.
2. A team of independent agents researches separate angles/sources.
3. Each returns findings, evidence, risks, and unique nuggets.
4. A critic/adversarial agent challenges assumptions.
5. A verifier corroborates claims.
6. Commander or lead synthesizer assesses the collective result.
7. Final answer incorporates corroborated findings and preserves dissent/uncertainty.

A practical seven-role team on a 64GB node could be:

- 1 coordinator;
- 4 specialist researchers;
- 1 adversarial critic;
- 1 verifier/synthesizer.

For cloud-based CLI research, token/account limits and browser/process overhead may become the bottleneck before raw CPU performance.

Node-role principle:

- M5 Max Commander: assign, steer, review, synthesize.
- M1 Ultra: run the research cabinet and mixed coding team.
- Optional M1 Max: run an independent second research bureau or overflow project.
- Future 192GB+ Ultra: run large local models and memory-heavy local intelligence.

---

# 9. Why a 192GB+ Node Still Matters

Multiple 64GB/128GB machines increase parallelism but do not automatically combine into one unified memory pool.

Therefore:

- three smaller nodes can run more separate agents;
- they cannot straightforwardly load one model requiring more memory than any single node has;
- distributed inference is possible with specialist software, but network bandwidth/latency is not equivalent to local unified memory.

The 192GB node unlocks:

- larger quantized models;
- larger contexts and KV caches;
- multiple local models resident together;
- heavier embeddings/indexing;
- local privacy workflows beyond the smaller nodes.

## 9.1 192GB vs 256GB vs 512GB-class progression

M2 Ultra maximum relevant target discussed:

- 192GB unified memory.

M3 Ultra-class larger-memory options discussed conceptually:

- 256GB;
- potentially 512GB-class units depending on real availability and configuration.

Procurement doctrine:

Do not automatically upgrade from 192GB to 256GB merely because it exists.

Choose 256GB when:

- a required model/workload fits in 256GB but not 192GB;
- more simultaneous local models are needed;
- newer compute materially benefits the workload;
- price is unusually favourable.

Choose 512GB-class hardware only when:

- real workloads exceed the 192GB/256GB envelope;
- fully local inference is strategically valuable;
- privacy or API-cost reduction justifies the expense;
- the machine becomes revenue-producing infrastructure.

More Claude CLI windows alone do not justify 512GB.

---

# 10. Storage Strategy for the M1 Ultra 64GB / 1TB

The M1 Ultra has only a 1TB internal SSD, which is tight for:

- Dropbox working sets;
- Obsidian and media;
- Git repos;
- build/package caches;
- local models;
- datasets;
- project mirrors;
- temporary AI processing.

## 10.1 Current optimum external-storage recommendation

Budget discussed:

- approximately Rp8 million.

Best overall target:

- 4TB genuine NVMe SSD;
- USB4 / Thunderbolt 40Gbps enclosure;
- thermally competent aluminium design;
- active fan or strong passive cooling preferred for sustained multi-terabyte transfers;
- genuine 40Gbps cable.

Why 4TB is the sweet spot:

- 2TB provides less capacity without a major real-world external-speed advantage;
- genuine 8TB NVMe generally exceeds the budget;
- suspiciously cheap 8TB/16TB/256TB listings are likely fraudulent;
- 4TB offers enough capacity for active data and local models until the NAS/high-memory node arrives.

Expected real-world external speed from a strong 40Gbps enclosure:

- approximately 2,500–3,200MB/s depending on controller, drive, thermals, filesystem, and workload.

The SSD's advertised internal 7,000MB/s-class speed will not pass fully through the 40Gbps external interface.

## 10.2 Candidate SSD classes

Preferred value class:

- Lexar NM790 4TB, non-heatsink;
- TeamGroup MP44 4TB;
- other genuine TLC/efficient Gen4 drives if locally well-priced.

Acceptable lower-cost backup/model-storage options:

- Crucial P3 Plus 4TB;
- Kingston NV3 4TB;
- other reputable 4TB drives, with the understanding that sustained writes/endurance may be weaker depending on NAND/controller.

Potential enclosure brands/models to source:

- ORICO ACOM2 USB4 40Gbps with fan;
- UGREEN USB4 40Gbps NVMe enclosure;
- Acasis USB4/TB4 enclosure;
- OWC Express 1M2 if reasonably priced.

Hard requirement:

The exact listing must explicitly support USB4 40Gbps or Thunderbolt-class 40Gbps NVMe operation. Generic 'USB-C' is insufficient.

## 10.3 Recommended data placement

Internal 1TB:

- macOS;
- applications;
- current highest-priority repos;
- random-I/O-sensitive databases;
- active system files.

External 4TB:

- local models;
- Dropbox selected working sets;
- datasets;
- media;
- project mirrors;
- build artifacts;
- archived repos;
- temporary AI-processing files.

Format recommendation:

- APFS;
- GUID Partition Map.

Important:

One external SSD is not redundant backup. It remains one physical failure domain.

## 10.4 Sourcing status

No exact live Tokopedia SSD/enclosure listing has yet been successfully verified and selected.

Open action:

- source a genuine 4TB NVMe + genuine 40Gbps enclosure from a reputable Tokopedia seller;
- verify stock, seller reputation, controller, warranty, heatsink fit, included cable, and total under/near Rp8 million.

---

# 11. NAS Research and Recommendation

A low-end UGREEN NAS description was reviewed with:

- 1GbE networking;
- 4GB LPDDR4X RAM;
- no M.2 NVMe support;
- up to 125MB/s transfer claims;
- consumer photo/phone-backup emphasis.

Conclusion:

It may be acceptable for basic home/family backup, but it is not the preferred primary NAS for Adrian's AI cluster.

Main limitations:

- 1GbE caps practical throughput around 100–125MB/s;
- no NVMe cache/storage tier;
- 4GB RAM is limited for heavier services;
- consumer-focused architecture;
- poor fit for large model libraries, fast multi-node transfers, and professional active storage.

## 11.1 Minimum preferred NAS specification

- 4 drive bays minimum;
- 2.5GbE minimum;
- 8GB RAM minimum;
- NVMe slots;
- snapshots;
- RAID/SHR equivalent;
- UPS support;
- reputable filesystem/backup features.

## 11.2 Better target

- 4-bay or 6-bay NAS;
- 10GbE or upgrade path;
- 16GB+ RAM;
- NVMe cache or storage support;
- snapshots/versioning;
- UPS;
- offline backup rotation.

Potential product families previously discussed:

- Synology DS923+ / DS1522+-class;
- QNAP TS-464 / TVS-h474-class;
- UGREEN DXP4800 Plus / DXP6800 Pro-class rather than entry-level 1GbE units;
- TerraMaster F4-424 Pro / F6-424 Max-class.

## 11.3 Storage doctrine

- Fast USB4 NVMe SSD = active speed.
- NAS = shared capacity, snapshots, and drive redundancy.
- Offline external backup = protection from deletion, ransomware, electrical damage, theft, and bad sync.
- GitHub/cloud = code and small critical-state redundancy.

RAID is not backup.

---

# 12. Fake Storage Warning

A Tokopedia listing claiming a generic portable '256TB SSD' for approximately Rp2.1 million was reviewed.

Conclusion:

Almost certainly fraudulent/fake-capacity storage.

Red flags:

- impossible capacity-to-price ratio;
- generic branding;
- contradictory title/capacity references;
- very low review count;
- common manipulated-firmware scam pattern.

Doctrine:

Do not purchase unbranded extraordinary-capacity flash storage. A device may report a false capacity while silently corrupting or overwriting files after its real small capacity is filled.

For any suspicious storage device already purchased, test full capacity with a tool such as F3 before trusting it, and never confirm delivery before testing.

---

# 13. Hong Kong / Singapore / US Procurement Research

## 13.1 Hong Kong M5 Max route

Hong Kong is currently the preferred route for the M5 Max because:

- Adrian has friends there;
- online delivery to a trusted contact is possible;
- store pickup may be possible for some configurations;
- the observed Hong Kong price was lower than the observed Singapore price.

Observed comparison from screenshots/rates checked during conversation:

- Singapore: S$7,924 ≈ US$6,146.59.
- Hong Kong: HK$43,624 ≈ US$5,566.38.

Approximate difference:

- Hong Kong about US$580 cheaper in that comparison.

## 13.2 Apple trade-in vs private Indonesian sale

Apple Hong Kong trade-in shown for the M3 Pro MacBook:

- HK$4,800 ≈ US$612 at the rate checked.

Estimated Indonesian private-sale value discussed:

- approximately Rp23 million ≈ US$1,278 at the rate checked.

Conclusion:

Private sale in Indonesia was materially better than Apple trade-in.

Actual status:

- M3 has now been sold.

## 13.3 US timing

Adrian noted that waiting until October for the US trip could save approximately US$1,000–1,200 in flight cost compared with travelling sooner.

Therefore:

- do not make an early US trip solely for hardware unless the saving on hardware exceeds the extra travel cost and delay;
- Hong Kong is the pragmatic near-term M5 route;
- the US may still be a strong later market for rare used/refurb 192GB Ultra units.

## 13.4 Singapore

Singapore remains a possible transit/sourcing market, but no exact verified M2 Ultra 192GB unit was secured during the research.

Do not plan a trip around an unverified rare configuration.

---

# 14. Procurement Priority Order

Current recommended order:

1. Receive and validate the M1 Ultra 64GB / 1TB Studio.
2. Configure it as the first dry-room research/coding node.
3. Purchase the M5 Max 128GB MacBook Pro in Hong Kong.
4. Decide 2TB vs 4TB internal storage using the travel/self-sufficiency criteria above.
5. Add a genuine fast 4TB USB4 NVMe drive to the M1 Ultra.
6. Decide whether Atti's M1 Max 64GB at Rp25m is worth adding as a separate Research Bureau node after verifying condition/storage.
7. Source a proper NAS with at least 2.5GbE, preferably 10GbE upgradeability and NVMe support.
8. Continue searching for a genuine 192GB+ Ultra node.
9. Only jump to 256GB/512GB-class Ultra after real measured workloads demonstrate the need.

---

# 15. Immediate Implementation Checklist for Claude

## M1 Ultra arrival

- [ ] Verify About This Mac shows M1 Ultra / 64GB / 1TB.
- [ ] Verify no MDM enrollment.
- [ ] Verify Activation Lock/iCloud clean.
- [ ] Run Apple Diagnostics.
- [ ] Check SSD health and available space.
- [ ] Configure wired Ethernet.
- [ ] Enable SSH / Remote Login.
- [ ] Configure tmux.
- [ ] Install required AI CLIs and Git tooling.
- [ ] Connect Obsidian/GitHub bridge.
- [ ] Run conservative concurrency tests.

## Performance baseline

- [ ] Test 2 heavy coding windows.
- [ ] Test 4 heavy coding windows.
- [ ] Test 6 heavy coding windows only after stability.
- [ ] Record memory pressure.
- [ ] Record swap use.
- [ ] Record thermal behaviour.
- [ ] Record task completion time.
- [ ] Record token/account bottlenecks separately from hardware bottlenecks.

## External SSD

- [ ] Source live Tokopedia listings.
- [ ] Verify SSD is genuine 4TB.
- [ ] Verify enclosure is genuine 40Gbps USB4/TB-class.
- [ ] Verify included cable supports 40Gbps.
- [ ] Verify seller warranty and return policy.
- [ ] Format APFS/GUID.
- [ ] Benchmark with Blackmagic or equivalent.
- [ ] Do not treat as sole backup.

## Atti M1 Max decision

- [ ] Confirm exact SSD capacity.
- [ ] Check battery/cycles.
- [ ] Test power button.
- [ ] Investigate Touch ID failure.
- [ ] Check all ports.
- [ ] Check MDM/Activation Lock.
- [ ] Run diagnostics.
- [ ] Compare final net value against keeping/selling Adrian's own M1 Max.

## M5 Max Hong Kong

- [ ] Confirm exact Apple/store stock.
- [ ] Confirm pickup/delivery date.
- [ ] Decide 2TB vs 4TB.
- [ ] Confirm keyboard/display configuration.
- [ ] Decide AppleCare.
- [ ] Arrange trusted local receipt/inspection.

## Future 192GB+ node

- [ ] Continue verified live-listing search.
- [ ] Do not rely on sold listings.
- [ ] Compare Mac Studio and Mac Pro on actual spec/price, not form factor alone.
- [ ] Prioritize memory capacity over minor GPU-bin differences for local LLM use.
- [ ] Verify MDM, Activation Lock, serial, storage, warranty, and return protection.

---

# 16. Corrections and Superseded Assumptions

The following earlier assumptions are explicitly superseded:

1. The Indonesian M2 Ultra Mac Pro 192GB / 8TB listing is not available; it had already sold.
2. No future architecture should assume that Mac Pro is owned or pending.
3. The M3 MacBook is sold and should not be counted as a node.
4. The M1 Ultra 64GB / 1TB is purchased, not hypothetical.
5. The M5 Max 128GB is planned, not yet confirmed purchased.
6. The future 192GB+ node remains unsourced.
7. The external 4TB SSD recommendation remains conceptual until exact live Tokopedia listings are verified.
8. Concurrency numbers are operational estimates and must be benchmarked on Adrian's real toolchain.

---

# 17. Recommended Final Doctrine

- Use the M5 Max as Commander.
- Use the M1 Ultra as the first serious dry-room Research Cabinet / Secondary Forge.
- Add Atti's M1 Max only if it passes verification and a separate 64GB research bureau is worth Rp25m.
- Keep the 2014 MacBook as Lantern/watchdog.
- Continue sourcing a single 192GB+ Ultra node because high-memory local inference is a capability that smaller nodes cannot replicate.
- Buy a genuine 4TB USB4 NVMe solution for the M1 Ultra before filling its 1TB internal SSD.
- Do not buy the low-end 1GbE consumer NAS as the main cluster NAS.
- Do not trust impossible-capacity unbranded storage listings.
- Measure real concurrency before buying additional middle-tier nodes.
- Buy the next machine to solve a measured bottleneck, not merely to add another device.

Commander decides.  
Research teams investigate.  
Forge executes.  
Bridgekeeper verifies.  
Lantern watches.  
Obsidian remembers.  
GitHub bridges.  
NAS preserves.  

---

# 18. Bridge Reply to Claude

## Findings

The cluster plan has materially changed: the M1 Ultra 64GB / 1TB is purchased; the M3 is sold; the M2 Ultra Mac Pro 192GB / 8TB listing was already sold; the M5 Max 128GB remains planned; and Atti's M1 Max 64GB is an optional research-node purchase.

## Action taken

This consolidated current-state and hardware-research brief has been written to the GitHub Bridge.

## Verification required

Claude should read this complete file before making further procurement or node-architecture recommendations and should treat the corrections section as authoritative.

## Blocker

No exact live Tokopedia listing has yet been verified for the recommended genuine 4TB NVMe SSD plus 40Gbps enclosure. No 192GB+ Ultra node is currently secured.

## Recommendation

Prioritize M1 Ultra deployment and benchmarking, then M5 Max acquisition, then fast 4TB external storage, then decide on Atti's M1 Max, and continue the search for a verified 192GB+ Ultra node.