---
title: The Grind Protocol — Unbounded Background Assimilation
type: doctrine
status: canonical
tier: 2
firewall_class: working-internal
created: 2026-05-01
last_updated: 2026-05-01
applies_to: [claude, antigravity]
related:
  - canonical/concepts/24-7-operating-model.md
  - canonical/concepts/agent-budget-framework.md
  - canonical/concepts/doctrine-no-more-overnight-bouncing.md
---

# The Grind Protocol

## 1. Purpose & Failure Mode Addressed
An LLM is not a human employee. If a human is given 6 hours to do 5 tasks, they pace themselves. If an LLM is given 6 hours to do 5 tasks, it completes them in 10 minutes at compute speed and then enters an idle wait-state for 5 hours and 50 minutes. This wastes immense productivity when the operator (Adrian) is away from the machine (e.g., sleeping, traveling).

**The Grind Protocol** solves the "idle LLM" problem. When the operator is away, the system must shift from "Conversational Checklist Execution" to "Continuous Background Bulk-Ingestion."

## 2. The Mechanism (The Batch Daemon)
Conversational UI windows (like the Claude desktop app or Antigravity interface) cannot loop infinitely without user prompts. To achieve 24/7 grinding:

1. **The Python/Bash Runner:** The active agent must write and execute a local background daemon (e.g., `grind-assimilation.py`).
2. **The Target Workload:** The script targets massive, unbounded workloads—specifically, the 2 TB Dropbox archive, the legacy ChatGPT chat logs, and the raw audio/video forensic queues.
3. **The API Bridge:** The script reads one file from the disk, sends it directly to the Anthropic/Gemini API via a system call, receives the synthesized markdown, writes it to the Hive Mind `canonical/` or `working/` directories, and then pulls the next file.

## 3. Memory Pressure & Crash Prevention
*Why past overnight scripts failed:* They tried to load too many files into a single context window or relied on a conversational interface that accumulated memory pressure until it crashed.

**The Grind Protocol Rule of Isolation:**
- The background script must process **one file at a time**.
- The API call must be stateless. It passes the system prompt, the file content, and receives the output. It does NOT retain conversational history.
- By treating each file as a discrete API hit, memory pressure is zero. The script can run 10,000 files continuously without ever crashing the system or exceeding RAM.

## 4. Execution Invocation
When Adrian announces he is leaving the machine (e.g., "I'm going to Denpasar for 3 hours, execute the Grind Protocol"), the agent MUST:
1. Immediately acknowledge the time constraint.
2. Confirm the exact directory (e.g., the local Dropbox mount or the iCloud extraction folder) the script will target.
3. Launch the script via a detached background terminal process (`nohup python3 grind-assimilation.py &` or similar).
4. Inform Adrian he is clear to leave the machine.

## 5. Telemetry & Observability
The running script must append a timestamp and a success/fail status to `working/_events/grind-telemetry.md` for every single file processed. 

When Adrian returns, he does not read a 10-minute LLM completion report. He reads the telemetry file to see the exact velocity and volume of gigabytes crunched while he was away.
