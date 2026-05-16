---
title: AG Workspace Persistence Protocol
type: protocol
status: authoritative
tier: 1
date: 2026-05-16
---

# AG Workspace Persistence Protocol

## 1. The "Seismic-Class" Gap
Antigravity workspaces operate in isolated execution contexts (e.g., `~/.gemini/antigravity/brain/...`). When AG performs deep synthesis, research, or codebase generation that is not explicitly written to a canonical Vault path, the knowledge is "orphaned." Subsequent dispatches and Claude Desktop sessions have no access to it, resulting in perceived amnesia.

## 2. The Persistence Discipline
**Every AG session MUST conclude with a state-export to the Vault.**

1. **Working State Export:** If a task is incomplete, AG must write a `.md` summary of its progress, open questions, and next steps to `working/handoffs/`.
2. **Canonical Promotion:** If a task generates validated intelligence, AG must write the finalized content to the appropriate `companies/`, `canonical/`, or `working/` directory.
3. **No Phantom Files:** Do not rely on files existing only in the `brain/scratch/` directory. They effectively do not exist to the rest of the Hive Mind.

## 3. Enforcement
This discipline is non-negotiable. Before signaling completion to the user or closing out a task, AG must verify that all created value has been committed to the visible `Adrian-Vault` filesystem.
