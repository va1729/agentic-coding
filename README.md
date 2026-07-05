# Agentic Coding Standards

Shared `AGENTS.md` instructions and Claude Code skills, kept out of individual project repos.

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

The installed path is version-pinned, so re-point the symlink to the new
`<version>` directory after running `/plugin update`.

Since this symlinked file is local to your machine, keep it out of the project's
git status without touching the shared `.gitignore` — add it to the project's
git exclude instead:

```
echo "CLAUDE.md" >> /path/to/project/.git/info/exclude
```

## Codex

Symlink the shared `AGENTS.md` into Codex's global config so it applies to every project:

```
git clone <this-repo-url> ~/agentic-coding
ln -sf ~/agentic-coding/plugins/agentic-coding/AGENTS.md ~/.codex/AGENTS.md
```

## Updating

Edit `plugins/agentic-coding/AGENTS.md` and `plugins/agentic-coding/skills/`. Claude Code plugin
users pick up changes on next `/plugin update`; Codex users get them automatically via the symlink.
