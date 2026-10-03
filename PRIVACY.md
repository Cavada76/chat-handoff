# Privacy Policy – session-handoff

_Last updated: 2026-10-04_

This plugin is a set of instructions for Claude plus two small local shell scripts (hooks) for Claude Code. It has no server and the author collects no data.

**What it reads:** in Claude Code, the hooks read the token counts in the current session's transcript file to estimate how full the context is, and check whether `HANDOFF.md` exists in the project folder. When you ask to resume, Claude reads `HANDOFF.md` and the files it lists.

**What it writes:** `HANDOFF.md` with a summary of your current work, when you ask for a handoff. The warning hook stores one number (the last warning level) in a temporary file named after the session ID. Files are written only to your own computer or Claude workspace.

**What it sends:** nothing. The scripts make no network requests and contain no analytics or tracking.

**Retention:** the author receives and retains no data. `HANDOFF.md` stays where it was saved until you delete it; the temporary file is cleared by your operating system.

**Claude itself:** your conversation and the files you share with Claude are handled by Anthropic under its own privacy policy: https://www.anthropic.com/legal/privacy

**Contact:** open an issue at https://github.com/Cavada76/session-handoff/issues
