---
title: Knowledge RAG Architecture (L4 Layer)
type: doctrine
status: canonical
tier: 2
firewall_class: working-internal
last_updated: 2026-05-06
related:
  - canonical/concepts/doctrine/knowledge-architecture.md
  - episodic/decisions/2026-05-06-knowledge-architecture-adoption.md
---

# Knowledge RAG Architecture (L4 Layer)

This doctrine governs the implementation and maintenance of the L4 Retrieval-Augmented Generation (RAG) query layer within the Adrian-Vault ecosystem. It establishes the technical standards, privacy firewalls, and architectural flows for local semantic search capabilities available to all operational agent systems.

## 1. Zero External Spend Principle

All RAG embedding and vector querying processes are strictly mandated to run completely **locally** on Adrian's M3 Pro machine.
- **Model:** `bge-m3` served locally via Ollama.
- **Vector Database:** `Qdrant` running inside a local Docker container (port 6333).
- **APIs:** No external LLM embedding APIs (OpenAI, Voyage, Cohere) are authorized to ingest vault data.

## 2. Component Architecture

The vault-wide semantic search stack operates on the following topology:

1. **Vault Corpus (File System):** The physical markdown source of truth.
2. **Chunking & Embedding Engine (`tools/rag/embed-vault.py`):** An idempotent Python script that processes markdown logic, strips `strictly-private` content, slices text into ~350-word chunks (50-word overlap), and embeds them into vectors using the local Ollama instance.
3. **Local Vector DB (`infrastructure/rag/docker-compose.yml`):** The Qdrant datastore handling indexing and high-speed semantic queries.
4. **Agent Retrieval API (`tools/rag/rag-mcp-server/mcp_server.py`):** An MCP (Model Context Protocol) server exposing the `search_vault(query, k, filters)` tool to Claude Code, Antigravity, and other future agents.

## 3. Strict Firewall Constraints

The RAG index represents a heavily synthesized vector representation of the vault. To maintain security, the embedder respects hard-coded exclusions:

**ALWAYS INCLUDED (Zone 1 / 2 / raw integration):**
- `canonical/` (excluding `_archive/`)
- `companies/`
- `working/drafts-pending/`
- `episodic/`
- `raw/whatsapp-archives/`
- `raw/facebook-import/posts/`
- `raw/chatgpt-import/`
- `working/voice-corpus/`

**NEVER INCLUDED (Zone 0 / System / Private):**
- Any directory titled `private-do-not-share`
- Any markdown file possessing `firewall_class: strictly-private` in its frontmatter
- File patterns matching: `recording-68-*`, `*-PRIVATE.*`, `family-strictly-private-*`
- Volatile directories (`.git`, `.claude`, `working/_runtime/`, etc.)
- Binary assets

## 4. Metadata and Filtering

Every embedded chunk is structured with extensive metadata payloads (JSON) in Qdrant, derived dynamically from the markdown frontmatter and file path heuristics.

This enables advanced filtering capabilities, allowing agents to execute targeted queries such as:
> *"Retrieve passages regarding Subconscious Surgery (venture filter) that possess a tier=1 status, excluding strictly-private data."*

## 5. Maintenance and Re-embedding

The `embed-vault.py` script relies on filesystem modification time (`mtime`) hashing to ensure idempotent executions. The script only vectors diffs (files created or modified since the last run), drastically minimizing token burn and processing time during background operations.
