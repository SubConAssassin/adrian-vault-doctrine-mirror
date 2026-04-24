# Apple Mail Access — Canonical Protocol
**Established:** 2026-04-24
**Status:** LIVE — tested and working

---

## Account Details
- **Address:** adrian.photon@me.com / adrian.photon@icloud.com (same account)
- **Mail store:** `~/Library/Mail/V10/C1A7C638-4AB3-43D0-81B8-6A4BD7A8B241/`
- **Total inbox emails:** 63,433+
- **Mailboxes:** INBOX, Sent Messages, Archive, Drafts, Junk, Deleted Messages

## Working Access Method — Direct Disk Read
```python
import os, glob, email, email.header

base = os.path.expanduser('~/Library/Mail/V10/C1A7C638-4AB3-43D0-81B8-6A4BD7A8B241/')
emlx_files = glob.glob(base + '**/*.emlx', recursive=True)
emlx_files = [f for f in emlx_files if '.partial.' not in f]
emlx_files.sort(key=os.path.getmtime, reverse=True)  # most recent first

for path in emlx_files:
    with open(path, 'rb') as f:
        content = f.read()
    idx = content.find(b'\n')  # skip emlx byte-count prefix line
    raw = content[idx+1:]
    msg = email.message_from_bytes(raw)
    frm = msg.get('From', '')
    subj = msg.get('Subject', '')
    date = msg.get('Date', '')
```

## Search Pattern
```python
# Search by sender
targets = ['someone@domain.com']
if any(t in frm.lower() for t in targets):
    # hit

# Fast grep pre-filter (upper bound, not exact)
# grep -rl 'domain.com' ~/Library/Mail/V10/.../ --include='*.emlx' | wc -l
```

## NEVER USE
- `tell application "Mail" to ...` — AppleScript Mail automation
- Reason: Scripts run from Claude Helper.app subprocess (separate TCC entity)
- Even with permission granted to Claude.app in System Settings → Automation, the Helper subprocess has its own TCC entry and fails silently

## Execute Python scripts
```
ALWAYS write to file first, then execute:
Filesystem:write_file → /Users/adriantaffinder/Documents/Adrian-Vault/working/script.py
do shell script "/opt/homebrew/bin/python3 /path/to/script.py 2>&1"

NEVER use heredoc in osascript — escape chars mangled by shell layer
```
