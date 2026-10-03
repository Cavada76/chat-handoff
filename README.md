# Session Handoff for Claude

Long chats get compacted, and every time it happens you lose detail: decisions you made, file names, where you left off.
You can't reliably catch the moment right before compaction, and rewriting a handoff after every message burns tokens.

This plugin does what experienced users do by hand: **hand off at a natural stopping point, start fresh, resume from one short file.** Say

> save a handoff

and Claude writes a short `HANDOFF.md` with the goal, decisions, **what was verified and what was only assumed**, files, open questions and the exact next step. In a new chat or session, say

> resume from the handoff

and Claude reads it, restates where you are in three lines, and checks the assumptions before building on them.

## Install

**Claude.ai / Claude desktop app (chat):** download `session-handoff-skill.zip` from Releases, then Settings → Capabilities → Skills → Upload. Works in a plain chat, in Projects, and with a connected folder.

**Claude Code**
```
/plugin marketplace add Cavada76/session-handoff
/plugin install session-handoff@session-handoff
```

## What you get in Claude Code

The skill, plus two small hooks (bash, no dependencies):

- **Early warning.** When the session's context passes 120k tokens, you see a one-line notice, and Claude offers a handoff at the next natural stopping point, not mid-task. It warns again every 50k tokens. Change this with `SESSION_HANDOFF_TOKENS` and `SESSION_HANDOFF_STEP`.
- **Recovery after compaction.** If compaction happens anyway, Claude is told to re-read `HANDOFF.md` before continuing.
- **Resume without naming the file.** When a session starts in a folder with a `HANDOFF.md`, Claude knows it's there, so "where were we?" just works.

## Why it works

- **One file, overwritten.** A pointer to the current state, not a growing transcript.
- **Verified vs assumed.** The next session doesn't treat the last session's guesses as facts.
- **Written once per chunk of work**, not after every message, so it costs almost nothing.

### Tip for the chat app

A skill can't watch how long your chat is. Add this line to your Project instructions or personal preferences so Claude offers a handoff by itself:

> When our chat gets long (about 15–20 messages) or we finish a chunk of work, offer to save a handoff.

## Privacy

Runs locally, makes no network calls, and writes only `HANDOFF.md` to your folder. See the [Privacy Policy](PRIVACY.md).

MIT licensed.
