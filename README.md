# Agentic Coding Standards

Shared `AGENTS.md` instructions and Claude Code skills, kept out of individual project repos.

## Claude Code

Installs directly from this private repo:

```
/plugin marketplace add <this-private-repo-url>
/plugin install agentic-coding
```

## Codex

Symlink the shared `AGENTS.md` into Codex's global config so it applies to every project:

```
git clone <this-repo-url> ~/team-agent-standards
ln -sf ~/team-agent-standards/plugins/team-standards/AGENTS.md ~/.codex/AGENTS.md
```

## Updating

Edit `plugins/agentic-coding/AGENTS.md` and `plugins/agentic-coding/skills/`. Claude Code plugin
users pick up changes on next `/plugin update`; Codex users get them automatically via the symlink.
