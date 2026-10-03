---
name: chat-handoff
description: Chat handoff. Use when the user says "save a handoff", "write a handoff", "handoff", "handover", "wrap up this chat", "save where we are", "before this chat gets compacted", "continue in a new chat", "pick up where we left off", "resume from the handoff", "read HANDOFF.md", or when a long chat or session is nearing its context limit. Saves the current state of the work (goal, decisions, verified vs assumed facts, files, open questions, exact next step) to one short HANDOFF.md that is overwritten each time, and resumes a fresh chat or session from it - so nothing is lost to compaction.
---

# Chat Handoff

Long chats get compacted, and compaction loses the details that matter: decisions, file names, where you left off.
The fix is not to race compaction. Hand off at a natural stopping point, start fresh, and resume from one short file.
Reply in the user's language; keep the file's headings in English so every session can find them.

## Save a handoff

1. **Write it from what actually happened in this conversation.** Don't invent progress. If something was
   discussed but never confirmed or tested, it goes under *Assumed*, not *Verified*.
2. **Overwrite, never append.** One current file, under ~60 lines. Drop anything that is done and no longer
   affects the next step. A handoff is a pointer to the state, not a transcript.
3. **Use exactly this structure** (omit a section only if it would be empty):

   ```markdown
   # Handoff: {short name of the work}
   _Updated {YYYY-MM-DD HH:MM} · {chat or session it came from, if known}_

   ## Goal
   One or two sentences: what we are trying to achieve and what "done" looks like.

   ## Status
   Where things stand right now, in 2-4 bullets.

   ## Decisions
   - {decision} — {why, in a few words}

   ## Verified
   - {facts we checked: tests passed, file exists, user confirmed, numbers looked up}

   ## Assumed (not yet checked)
   - {guesses, things the previous session believed but never confirmed}

   ## Files
   - `{path or file name}` — {what it is / what changed}

   ## Open questions
   - {question} ({who must answer: user or Claude})

   ## Next step
   The single exact action to take first in the new session.

   ## Read first
   - {persistent files the next session should open before working, e.g. CLAUDE.md, project notes, a plan}
   ```

4. **Save it where the next session will find it:**
   - **You can write to the user's project folder** (Claude Code, Cowork, or a folder connected in the app):
     write `HANDOFF.md` in the project root, or the folder the user names.
   - **Plain chat without a project folder:** create `HANDOFF.md` as a file the user can download
     (in claude.ai, save to `/mnt/user-data/outputs/HANDOFF.md`), and also show the full content in one
     code block so it can be copied. If the user works in a claude.ai Project, suggest adding the file to the
     Project's files and replacing the old one.
5. **Tell the user how to continue**, in two short lines:
   - Claude Code: "Run `/clear` (or open a new session) and say *resume from the handoff*."
   - Chat app: "Start a new chat (in the same Project, if you use one), attach or paste HANDOFF.md, and say *resume from the handoff*."

Keep the save itself cheap: write the file once at the end of a chunk of work. Don't rewrite it after every message.

## Resume from a handoff

1. **Find it:** `HANDOFF.md` in the working folder, an attached file, Project files, or text the user pasted.
   If none exists, say so and ask what to pick up; don't guess from memory.
2. **Read the files listed under *Read first*** before anything else.
3. **Restate in three lines:** the goal, where things stand, and the next step. Then go.
4. **Treat *Assumed* as unproven.** Before building on an assumed item, check it cheaply (open the file,
   run the test, ask the user). Move it to *Verified* once checked.
5. Update `HANDOFF.md` when the next chunk of work is done.

## When to suggest a handoff yourself

Offer once, briefly, at a natural stopping point, never mid-task:
- a chunk of work is finished and the conversation is long (roughly 15-20 exchanges, or many large files read);
- the context was just compacted, or a system message says the context is filling up;
- the user says the chat feels slow, forgetful or confused.

If the context was just compacted and a `HANDOFF.md` exists, read it before continuing and bring it up to date.
