#!/usr/bin/env bash
# SessionStart hook: after compaction, point Claude back to HANDOFF.md; on startup/resume/clear,
# mention an existing HANDOFF.md so "resume" works without the user naming the file.
input=$(cat)
field() { printf '%s' "$input" | sed -n "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"\([^\"]*\)\".*/\1/p" | head -n 1; }

source=$(field source)
cwd=$(field cwd | sed 's/\\\\/\//g')
session=$(field session_id | tr -cd 'A-Za-z0-9-')
file="${cwd:-.}/HANDOFF.md"

# Context shrank: let context-check.sh warn again from the first threshold.
if [ "$source" = "compact" ] || [ "$source" = "clear" ]; then
  rm -f "${TMPDIR:-/tmp}/chat-handoff-${session:-unknown}" 2>/dev/null
fi

updated=""
[ -f "$file" ] && updated=$(date -r "$file" '+%Y-%m-%d %H:%M' 2>/dev/null)

out() { # $1 = context for Claude, $2 = optional message shown to the user
  if [ -n "$2" ]; then
    printf '{"systemMessage":"%s","hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$2" "$1"
  else
    printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}\n' "$1"
  fi
}

if [ "$source" = "compact" ]; then
  if [ -f "$file" ]; then
    out "[chat-handoff] The context was just compacted, so details from earlier in this session may be lost. HANDOFF.md in the project folder was last updated ${updated}. Read it now before continuing, then bring it up to date with the chat-handoff skill." \
        "Context was compacted. Claude will re-read HANDOFF.md before continuing."
  else
    out "[chat-handoff] The context was just compacted, so details from earlier in this session may be lost. At the next natural stopping point, offer to save a handoff with the chat-handoff skill so the work can continue in a fresh session."
  fi
elif [ -f "$file" ]; then
  out "[chat-handoff] A HANDOFF.md from ${updated} exists in this folder. If the user's request continues that work (for example: resume, continue, where were we), read it first and follow the chat-handoff skill's resume steps. Otherwise ignore it."
fi
exit 0
