#!/usr/bin/env bash
# Re-points an existing CLAUDE.md/AGENTS.md symlink at this plugin's AGENTS.md
# after a version bump. Only touches a target if it is already a symlink into
# this plugin's installed cache directory — never creates or overwrites a
# real file. Shared between the Claude Code and Codex plugin manifests, which
# both invoke this same hook (Codex honors CLAUDE_PLUGIN_ROOT/CLAUDE_PROJECT_DIR
# for compatibility, with PLUGIN_ROOT/PWD as its own fallbacks).
set -euo pipefail

plugin_root="${CLAUDE_PLUGIN_ROOT:-${PLUGIN_ROOT:-}}"
project_dir="${CLAUDE_PROJECT_DIR:-$PWD}"
plugin_agents="${plugin_root}/AGENTS.md"

repoint() {
  local target="$1"
  if [ -L "$target" ]; then
    local current_link
    current_link="$(readlink "$target")"
    case "$current_link" in
      */agentic-coding/*/AGENTS.md)
        if [ "$current_link" != "$plugin_agents" ]; then
          ln -sf "$plugin_agents" "$target"
          echo "agentic-coding: re-pointed $(basename "$target") symlink to $plugin_agents"
        fi
        ;;
    esac
  fi
}

repoint "$project_dir/CLAUDE.md"
repoint "$project_dir/AGENTS.md"
