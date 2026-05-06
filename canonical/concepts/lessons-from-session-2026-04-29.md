---
title: Lessons from Session — 2026-04-29 (Vault Autosave + Frictionless Protocol)
type: lesson
status: canonical
tier: 2
firewall_class: working-internal
created: 2026-04-29
last_updated: 2026-04-29
related:
  - canonical/concepts/lessons-learned.md
  - canonical/concepts/frictionless-operator-doctrine.md
---

# Lessons from Session — 2026-04-29 (Vault Autosave + Frictionless Protocol)

Status: canonical
Type: session-lessons
Applies to: all future Claude/Antigravity sessions

---

## Headline learnings

### 1. TCC blocks launchd-spawned shells from accessing ~/Documents/

**Confirmed empirically this session.** Attempted to install `com.adrianvault.autosave` launchd LaunchAgent to auto-run `save-vault` on vault changes. Failed at two levels:

- **Level 1:** When wrapper script lived at `~/Documents/Adrian-Vault/bin/vault-autosave.sh`, launchd-spawned `/bin/zsh` could not even open it. Error: `/bin/zsh: can't open input file: ...vault-autosave.sh`. Fixed by relocating to `~/bin/vault-autosave.sh`.
- **Level 2:** Even with wrapper outside Documents, `git` running under launchd-spawned zsh failed with `fatal: Unable to read current working directory: Operation not permitted` when `cd`'d into `~/Documents/Adrian-Vault/`.

**Root cause:** macOS TCC sandbox. Processes spawned by launchd LaunchAgents do not inherit Full Disk Access from the user's interactive context. Already documented in partition protocol ("NOT shell — TCC blocks") — confirmed for git/vault path specifically.

**Workaround in effect:** Agent-driven save-vault. Each agent calls `save-vault` itself under its own context (which has FDA inherited from host app):
- **Claude** → osascript `do shell script "/bin/zsh -c 'source ~/.zshrc; cd ~/Documents/Adrian-Vault && save-vault'"` after every vault edit
- **Antigravity** → runs `save-vault` directly after vault writes (already operates under user shell context)
- **Manual edits** (Obsidian) → desktop "Save Adrian Vault to GitHub.command" or `save-vault` in Terminal

**If true autosave wanted later:** one-time click — System Settings → Privacy & Security → Full Disk Access → add `/bin/zsh`. Wrapper at `~/bin/vault-autosave.sh` and plist at `bin/launchd/com.adrianvault.autosave.plist` are staged for that path.

### 2. Frictionless protocol — paste targets in fenced code blocks ALWAYS

Adrian is dyslexic. Any text he must copy-paste (Terminal commands, code, prompts) MUST go in a fenced code block — Claude UI renders these with a one-click copy button. Highlighting + Cmd-C is unacceptable friction.

**Never** use inline backticks or plain text for paste-targets. This is now a HARD RULE in `ADRIAN_INTERACTION_PROTOCOL.md` and saved to Claude memory.

### 3. CEO Execution Protocol enforcement — failure mode observed

Twice this session Claude lapsed into asking permission instead of executing:
- After diagnosing the TCC blocker, asked "Next action: tear down the broken launchd job?" instead of just doing it.
- Earlier, asked "confirm and I install it now myself" when Adrian had already authorised execution under frictionless terms.

**Rule reinforcement:** If executable with available tools and the user has previously authorised the work-stream, execute. No permission loops. The Decision format (Recommendation/Why/Downside/Next action) is for ambiguous strategic choices, not for routine continuation of an authorised task.

### 4. osascript heredoc warning — empirically reconfirmed

Tried to use `cat <<EOF` heredoc inside `do shell script` to write a multi-line file at `~/bin/`. Failed with `syntax error: Expected """ but found unknown token`. The double-escape between AppleScript and shell makes heredocs unreliable.

**Pattern that works:** Write file to a Filesystem-accessible location (Desktop, Documents) via `Filesystem:write_file`, then `cp` via osascript to the target outside the Filesystem MCP's allowed dirs. Already in user memory ("never osascript heredocs") — confirmed today.

### 5. MCP layer can stall mid-session

Filesystem and Control your Mac MCPs both went unresponsive simultaneously for ~4 minutes during the ChatGPT cleanup task. Recovered after Adrian was given the option to restart Claude Desktop (in this case they self-recovered).

**Behaviour when stalled:** Surface the blocker to Adrian quickly, recommend Claude Desktop restart, do not silent-retry indefinitely.

### 6. GitHub mirror scope is narrow by design

`.gitignore` whitelist only pushes:
- `canonical/concepts/`
- `wiki/hot.md`, `wiki/index.md`, `wiki/log.md`
- `raw/.gitkeep`
- Root infra: `CLAUDE.md`, `AGENTS.md`, `.gitignore`, **`ADRIAN_INTERACTION_PROTOCOL.md`** (force-tracked despite gitignore deny rule)

`canonical/projects/`, `canonical/people/`, `working/`, `episodic/`, `procedural/`, `bin/`, `tools/`, `08-Archive/` are local-only.

**Implication:** GitHub is **not** a full disaster-recovery backup. If MacBook is lost, ~95% of vault is gone unless separate full-disk backup exists (Time Machine / Backblaze / iCloud Drive). Worth a separate decision Adrian flagged for later.

---

## Files added/modified this session

**Whitelist (will push to GitHub):**
- `ADRIAN_INTERACTION_PROTOCOL.md` — heredoc artifact removed; HARD RULE on paste targets added
- `canonical/concepts/claude-ack-interaction-protocol.md` — bridge round-trip with ChatGPT
- `canonical/concepts/chatgpt-to-claude-cleanup-request.md` — bridge round-trip
- `canonical/concepts/claude-ack-chatgpt-cleanup.md` — bridge round-trip
- `canonical/concepts/lessons-from-session-2026-04-29.md` — this file

**Local only:**
- `~/bin/vault-autosave.sh` — relocated outside Documents/, kept staged for future FDA scenario
- `bin/launchd/com.adrianvault.autosave.plist` — kept staged for future FDA scenario
- `bin/vault-autosave.sh` — original location, no longer pointed at by plist (can be removed)
- `working/handoffs/2026-04-28-claude-to-antigravity-vault-autosave-install.md` — marked SUPERSEDED-tcc-blocked
- `working/handoffs/2026-04-29-session-closeout.md` — session closeout

**Removed:**
- `~/Library/LaunchAgents/com.adrianvault.autosave.plist` — bootout + rm (was failing on every fire)

---

## For next session — pickups

1. ChatGPT bridge round-trip is now testable end-to-end via canonical/concepts/. ChatGPT can read Claude's responses from GitHub.
2. If Adrian wants full-vault disaster recovery, separate conversation needed — current GitHub scope is intentionally narrow for privacy.
3. Antigravity should be told (via AG-targeted handoff in next session) that the autosave install commission is SUPERSEDED — do not execute it.
4. The `bin/vault-autosave.sh` legacy file inside the vault can be deleted at next cleanup pass; nothing references it anymore.
