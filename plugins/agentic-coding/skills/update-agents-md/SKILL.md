---
name: update-agents-md
description: Add or edit a convention/rule in this plugin's AGENTS.md, then commit (and, after confirmation, push) the change to the agentic-coding git repo. Triggers on "update AGENTS.md", "add this to AGENTS.md", "remember this convention", "add a rule to the plugin".
---

Use this skill when the user asks to add, edit, or remove a convention in this
plugin's `AGENTS.md` so it becomes a standing instruction across every project
that imports it.

Repo root: `/Users/vivek/Workspace/agentic-coding`
Target file: `plugins/agentic-coding/AGENTS.md` (relative to repo root)

Steps:

1. `cd /Users/vivek/Workspace/agentic-coding && git status` — confirm the
   working tree is clean before editing. If it isn't, stop and ask the user
   how to handle the pre-existing changes rather than bundling them in.
2. Edit `plugins/agentic-coding/AGENTS.md`:
   - Add the new rule under the most relevant existing `##` section, or
     create a new section if none fits.
   - Match the file's existing style: terse bullet, the rule itself first,
     with rationale only if it's non-obvious.
   - Don't rewrite unrelated sections or reformat the whole file — a single
     targeted edit, per this repo's own "Editing Style" conventions.
3. `git add plugins/agentic-coding/AGENTS.md`
4. Commit with a Conventional Commits message (e.g. `feat: add rule about X`
   or `docs: update AGENTS.md wording`) — this repo enforces that convention
   on itself.
5. Show the user the diff and the new commit hash, then explicitly ask
   "Push to origin/<current-branch> now?" — do not push without an explicit
   yes on *this* invocation, even if a previous invocation was approved.
6. Only after the user confirms, run `git push origin <current-branch>` and
   report success.

Do not touch any other file in this repo as part of this skill unless the
user explicitly asks for it.
