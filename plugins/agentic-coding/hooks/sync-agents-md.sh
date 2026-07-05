#!/usr/bin/env bash
# Re-points an existing CLAUDE.md symlink at this plugin's AGENTS.md after
# a version bump. Only touches CLAUDE.md if it is already a symlink into
# this plugin's cache directory — never creates or overwrites a real file.
set -euo pipefail

target="${CLAUDE_PROJECT_DIR:-$PWD}/CLAUDE.md"
plugin_agents="${CLAUDE_PLUGIN_ROOT}/AGENTS.md"

if [ -L "$target" ]; then
  current_link="$(readlink "$target")"
  case "$current_link" in
    */agentic-coding/agentic-coding/*/AGENTS.md)
      if [ "$current_link" != "$plugin_agents" ]; then
        ln -sf "$plugin_agents" "$target"
        echo "agentic-coding: re-pointed CLAUDE.md symlink to $plugin_agents"
      fi
      ;;
  esac
fi
