#!/usr/bin/env bash
# UserPromptSubmit hook: when this session's context passes a threshold, nudge once per step
# so the user can save a handoff before auto-compaction. No dependencies beyond grep/sed.
# Tune with SESSION_HANDOFF_TOKENS (first warning, default 120000) and SESSION_HANDOFF_STEP (default 50000).
input=$(cat)
field() { printf '%s' "$input" | sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" | head -n 1; }

transcript=$(field transcript_path | sed 's/\\\\/\//g')
session=$(field session_id | tr -cd 'A-Za-z0-9-')
[ -n "$transcript" ] && [ -f "$transcript" ] || exit 0

# The last main-thread API response holds the current context size.
line=$(grep '"usage"' "$transcript" | grep -v '"isSidechain":true' | tail -n 1)
[ -n "$line" ] || exit 0
num() { printf '%s' "$line" | grep -o "\"$1\":[0-9]*" | head -n 1 | cut -d: -f2; }
a=$(num input_tokens); b=$(num cache_creation_input_tokens); c=$(num cache_read_input_tokens)
tokens=$(( ${a:-0} + ${b:-0} + ${c:-0} ))

threshold=${SESSION_HANDOFF_TOKENS:-120000}
step=${SESSION_HANDOFF_STEP:-50000}
[ "$tokens" -ge "$threshold" ] || exit 0
level=$(( (tokens - threshold) / step + 1 ))

state="${TMPDIR:-/tmp}/session-handoff-${session:-unknown}"
last=$(cat "$state" 2>/dev/null)
[ "$level" -gt "${last:-0}" ] || exit 0
printf '%s' "$level" > "$state" 2>/dev/null

k=$(( tokens / 1000 ))
msg="Context is at about ${k}k tokens. At the next natural stopping point, say \\\"save a handoff\\\" and continue in a fresh session."
ctx="[session-handoff] This session's context is about ${k}k tokens. Long contexts give weaker answers and get auto-compacted. Do not interrupt the current task. When you reach a natural stopping point, tell the user in one line and offer to save a handoff with the session-handoff skill so they can continue in a fresh session."
printf '{"systemMessage":"%s","hookSpecificOutput":{"hookEventName":"UserPromptSubmit","additionalContext":"%s"}}\n' "$msg" "$ctx"
