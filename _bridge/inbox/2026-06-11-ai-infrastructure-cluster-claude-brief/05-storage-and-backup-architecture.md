# 05 — Storage and Backup Architecture

## Objective

Design storage for Adrian's AI infrastructure so it is fast, redundant, and cost-effective.

Do not confuse three separate needs:

1. Fast active storage.
2. Long-term redundant archive.
3. Disaster recovery/offline backup.

Each should be handled differently.

## Recommended storage layers

| Layer | Recommended hardware | Purpose |
|---|---|---|
| Fast active drive | USB4 / Thunderbolt NVMe SSD, 4TB–8TB | Active AI projects, model shuttle, clone, fast local transfer |
| Redundant archive | 4-bay or 6-bay NAS with NAS HDDs | Long-term storage, snapshots, shared LAN data |
| Offline backup | External HDD/SSD stored unplugged | Protection from ransomware, electrical faults, accidental deletion |
| Cloud/GitHub | GitHub / cloud storage | Code, markdown state, small critical files |

## Fast SSD recommendation

For the M2 Ultra Mac Studio, a direct USB4 / Thunderbolt NVMe SSD is best for speed.

Suggested pattern:

- 1 x 4TB or 8TB USB4 NVMe drive for active backup/work mirror.
- Prefer fan-cooled or thermally competent enclosure for multi-terabyte transfers.
- Avoid ordinary USB 3.x HDDs or SATA SSDs for high-speed active work.

Tokopedia-style build pattern:

- USB4 / Thunderbolt 40Gbps NVMe enclosure.
- 4TB NVMe SSD such as Lexar NM790, WD SN850X non-heatsink, Samsung 990 Pro, or comparable.

Caution:

- Factory heatsink SSDs may not fit slim enclosures.
- Verify enclosure supports macOS and 40Gbps mode.
- Verify actual selected listing stock, not just configurable menu claims.

## NAS recommendation

For long-term cost-effective backup, a NAS or RAID box is more efficient than many external SSDs.

Recommended baseline:

- 4-bay NAS.
- 4 x 8TB or 4 x 12TB NAS HDDs.
- RAID 5 / SHR.
- UPS battery backup.
- Snapshots enabled.
- Ethernet, ideally 10GbE if budget allows.

Recommended stronger setup:

- 6-bay NAS.
- 6 x 8TB or 6 x 12TB NAS HDDs.
- RAID 6 / SHR-2.
- UPS.
- 10GbE.
- Snapshot schedule.

## Capacity examples

Approximate usable capacity:

| Drives | RAID mode | Usable capacity | Fault tolerance |
|---|---|---:|---|
| 4 x 8TB | RAID 5 / SHR | ~24TB | 1 drive failure |
| 4 x 12TB | RAID 5 / SHR | ~36TB | 1 drive failure |
| 4 x 16TB | RAID 5 / SHR | ~48TB | 1 drive failure |
| 6 x 8TB | RAID 6 / SHR-2 | ~32TB | 2 drive failures |
| 6 x 12TB | RAID 6 / SHR-2 | ~48TB | 2 drive failures |
| 6 x 16TB | RAID 6 / SHR-2 | ~64TB | 2 drive failures |

## NAS vs direct SSD

| Feature | USB4 NVMe SSD | NAS |
|---|---|---|
| Speed | Very high, direct-attached | Moderate to high depending on Ethernet |
| Cost per TB | High | Lower |
| Redundancy | None unless duplicated | Built in with RAID/SHR |
| Portability | Excellent | Poor |
| Multi-machine access | Manual / single machine | Excellent |
| Best use | Active project mirror | Archive, backup, shared storage |

## Important rule

RAID is not backup.

RAID protects against drive failure. It does not protect against:

- accidental deletion;
- corrupted files;
- ransomware;
- theft;
- fire/water/electrical damage;
- bad sync propagating to all copies.

Therefore:

- NAS RAID is one layer.
- Offline backup is another layer.
- GitHub/cloud for critical small files is another layer.

## Backup routing by data type

| Data type | Primary location | Backup route |
|---|---|---|
| Code repos | Local SSD + GitHub | GitHub + NAS snapshot |
| Obsidian vault | iCloud + local | GitHub doctrine mirror + NAS backup |
| AI models | Forge local SSD / external SSD | NAS archive if expensive to reacquire |
| Client/business docs | Local + Obsidian/NAS | NAS + offline encrypted backup |
| Media/transcripts | NAS | Offline drive or second NAS/cloud if critical |
| Active project mirror | USB4 NVMe SSD | NAS after each session |

## Recommended backup rhythm

Daily:

- Git push important code changes.
- Bridgekeeper checks uncommitted work.
- Obsidian/iCloud sync check.
- NAS snapshot.

Weekly:

- External offline backup rotation.
- Verify one restore sample.
- Check SMART/drive health.
- Check NAS free space.

Monthly:

- Full archive snapshot.
- Review old model/data folders.
- Test disaster recovery path.
- Clean obsolete generated files.

## Dry-room hardware recommendation

Ideal physical layout:

- M2 Ultra Mac Studio wired Ethernet.
- M1 Max Bridgekeeper wired Ethernet if stationary.
- NAS wired Ethernet.
- UPS shared by NAS + Mac Studio + network switch/router where practical.
- M5 Max docked on Ethernet when at desk; Wi-Fi when mobile.
- 2014 i7 on Wi-Fi or Ethernet as low-load dashboard.

## 10GbE recommendation

If NAS is part of active workflow, use 10GbE where possible.

Priority order:

1. NAS with 10GbE or upgrade card.
2. Mac Studio 10GbE.
3. 10GbE switch.
4. Ethernet adapter/dock for M5 Max when docked.

Without 10GbE, NAS is still useful for backup/archive, but less suitable for active heavy files.

## Recommended final storage architecture

Minimum serious setup:

- 1 x 4TB/8TB USB4 NVMe SSD for active fast work.
- 1 x 4-bay NAS with 4 x 8TB or 4 x 12TB drives.
- 1 x offline external backup drive.

Better setup:

- 2 x USB4 NVMe SSDs, one active and one rotated/offline.
- 6-bay NAS with RAID 6 / SHR-2.
- UPS.
- 10GbE.
- Monthly offline backup.

For Adrian's AI infrastructure, the best answer is not SSD or NAS. It is:

- SSD for speed.
- NAS for capacity and redundancy.
- Offline backup for true safety.
