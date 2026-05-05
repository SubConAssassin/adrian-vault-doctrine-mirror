# Wiki Log

Chronological, append-only. One entry per operation.

Format:
```
## [YYYY-MM-DD] <op> | <title>
```

Operations: `ingest`, `query`, `lint`, `update`, `init`.

Utility: `grep "^## \[" wiki/log.md | tail -5` returns the last 5 operations.

---

## [2026-05-05] update | Session shutdown — phone remote test

Adrian prompted from phone while out. Session ran on Linux vault mirror (doctrine only — not Mac-native).

**Done:** OSB Provenance Certificate System designed and filed (`canonical/concepts/osb-provenance-certificate-system.md`). CEO schedule updated (task #7 closed).

**Gaps identified:**
- Phone prompts reach Linux vault mirror only — Mac is unreachable remotely. Tailscale + persistent Claude Code session needed on Mac before next trip.
- Email monitoring daemon does not exist. Erica email went unalerted for several days.
- Dispatcher protocol is concurrency control, not remote access routing.

**Next session first actions:** Read Erica's email + draft response. Commission email monitoring daemon. Set up and verify Tailscale remote access.

---

## [2026-04-14] init | wiki created

Wiki initialized with the `llm-wiki-setup` skill. Layout: `flat`.

Ready to ingest. Drop a source into `raw/` and ask: "Ingest the new source I just added."
