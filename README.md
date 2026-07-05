# Agentic Coding Standards

Shared `AGENTS.md` instructions and skills for Claude Code and Codex, kept out of individual project repos.

## Claude Code

Installs directly from this private repo:

```
/plugin marketplace add <this-private-repo-url>
/plugin install agentic-coding
```

This gives you the skills, but Claude Code does not automatically feed the
plugin's `AGENTS.md` conventions into a project as instructions. To have a
project actually follow them, symlink the project's `CLAUDE.md` (or
`AGENTS.md`) to the installed plugin's copy — no separate clone needed:

```
ln -sf ~/.claude/plugins/cache/agentic-coding/agentic-coding/<version>/AGENTS.md /path/to/project/CLAUDE.md
```

The installed path is version-pinned, so a `/plugin update` bump would
normally break the symlink — a `SessionStart` hook shipped with the plugin
(`plugins/agentic-coding/hooks/`) detects that and re-points it to the new
`<version>` directory automatically at the start of your next session.

Since this symlinked file is local to your machine, keep it out of the project's
git status without touching the shared `.gitignore` — add it to the project's
git exclude instead:

```
echo "CLAUDE.md" >> /path/to/project/.git/info/exclude
```

## Codex

Codex also has a plugin system, and this repo doubles as a Codex plugin
marketplace via `.agents/plugins/marketplace.json`. Install the same way as
Claude Code:

```
codex plugin marketplace add <this-private-repo-url>
codex plugin install agentic-coding
```

This gives you the skills, but — same as Claude Code — Codex does not
automatically feed the plugin's `AGENTS.md` conventions into a project just
because the plugin is installed; Codex only auto-loads a project's *own*
`AGENTS.md` at session start. To have a project follow these conventions,
symlink the project's `AGENTS.md` to the installed plugin's copy:

```
ln -sf ~/.codex/plugins/cache/agentic-coding/agentic-coding/<version>/AGENTS.md /path/to/project/AGENTS.md
```

The installed path is version-pinned, so a `codex plugin marketplace upgrade`
bump would normally break the symlink — the same `SessionStart` hook shipped
with the plugin (`plugins/agentic-coding/hooks/`) re-points it to the new
`<version>` directory automatically at the start of your next session (Codex
hooks honor `CLAUDE_PLUGIN_ROOT`/`CLAUDE_PROJECT_DIR` for compatibility).

Since this symlinked file is local to your machine, keep it out of the
project's git status without touching the shared `.gitignore` — add it to
the project's git exclude instead:

```
echo "AGENTS.md" >> /path/to/project/.git/info/exclude
```

## Updating

Edit `plugins/agentic-coding/AGENTS.md` and `plugins/agentic-coding/skills/`. Claude Code plugin
users pick up changes on next `/plugin update`; Codex plugin users pick them up on next
`codex plugin marketplace upgrade`.
