# 04 — Legacy 2014 Intel i7 / 16GB MacBook Pro Role

## Summary

Adrian's old 2014 Intel i7 MacBook Pro with 16GB RAM is still useful, but not as a heavy AI machine.

It should be used as a low-cost, low-risk utility node on the LAN.

Codename: **Lantern**.

## Why keep it in the system

Even though it is too weak for modern heavy AI workloads, it can still provide value because it can remain available without consuming the attention or thermal headroom of the stronger machines.

Useful qualities:

- Already owned.
- Can sit on LAN permanently.
- Can run terminal sessions.
- Can display dashboards.
- Can provide emergency access to the network.
- Can monitor NAS / backups / uptime.
- Can act as a cheap screen for status.

## Do not use it for

Avoid:

- Heavy Claude Code sessions.
- Antigravity heavy IDE windows.
- Local LLM inference beyond very small models.
- Large repo indexing.
- Big builds.
- Multi-agent orchestration.
- Any mission-critical write-heavy role.

It has 16GB RAM and old Intel thermals. Treat it as a utility terminal, not a compute node.

## Best roles

### 1. Dashboard display

Use it as a permanent dashboard showing:

- active sessions;
- Forge status;
- Bridgekeeper status;
- NAS health;
- backup progress;
- network health;
- current handoff/blocker state.

Possible dashboard files:

```text
AI-OPS/ACTIVE_SESSIONS.md
AI-OPS/DAILY_STATUS.md
AI-OPS/BACKUP_STATUS.md
AI-OPS/BLOCKERS.md
```

### 2. SSH control terminal

Use it as an always-available terminal into:

- M2 Ultra Mac Studio;
- M1 Max Bridgekeeper;
- NAS;
- router/admin tools if needed.

Example:

```bash
ssh adrian@mac-studio.local
ssh adrian@m1-bridgekeeper.local
ssh admin@nas.local
```

### 3. LAN health monitor

Run lightweight checks:

```bash
ping mac-studio.local
ping m1-bridgekeeper.local
ping nas.local
ping github.com
```

Could write periodic status to a local text file or bridge file.

### 4. Backup watcher

Use it to monitor, not perform, heavy backups.

Examples:

- tail backup logs;
- monitor NAS web dashboard;
- confirm external drive mounted/unmounted;
- warn if backup has not completed.

### 5. Obsidian reference station

It can open Obsidian or a markdown viewer for read-only reference.

Caution: avoid simultaneous editing of important Obsidian notes from this machine if iCloud sync is fragile.

### 6. Emergency fallback admin machine

If Commander is travelling, Forge is busy, and Bridgekeeper is in a process, Lantern can still:

- SSH in;
- kill stuck jobs;
- check logs;
- restart services;
- confirm NAS health;
- read bridge files.

## Suggested lightweight tmux layout

```text
tmux session: lantern
0: lan-health
1: forge-ssh
2: bridgekeeper-ssh
3: nas-status
4: backup-tail
5: bridge-readonly
```

## Example status script concept

A simple script can run every few minutes:

```bash
#!/bin/bash
DATE=$(date)
echo "# LAN Status" > ~/lan-status.md
echo "Updated: $DATE" >> ~/lan-status.md
echo "" >> ~/lan-status.md
for HOST in mac-studio.local m1-bridgekeeper.local nas.local; do
  if ping -c 1 -W 1 "$HOST" >/dev/null 2>&1; then
    echo "- $HOST: OK" >> ~/lan-status.md
  else
    echo "- $HOST: DOWN" >> ~/lan-status.md
  fi
done
```

This should stay local unless explicitly promoted to the GitHub bridge.

## Security caution

Because it is an older Intel Mac:

- Keep it patched as far as practical.
- Do not expose it directly to the internet.
- Use LAN-only or Tailscale-only access.
- Disable unnecessary services.
- Do not store primary credentials on it unless needed.
- Avoid making it a single point of failure.

## Final role

Lantern is not for AI horsepower.

It is for visibility, resilience, and low-level control.

In the cluster metaphor:

- Commander decides.
- Forge builds.
- Bridgekeeper verifies.
- Lantern watches.
