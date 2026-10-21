#!/usr/bin/env bash
# Install the apprentice skills from this checkout by symlinks, for Claude Code.
#
#   scripts/install.sh [--force] [--dry-run] [--uninstall]
#   bash <(curl -fsSL https://raw.githubusercontent.com/rshingleton/apprentice/main/scripts/install.sh)
#
# Run from a pipe (no checkout around it), it clones APPRENTICE_REPO into
# APPRENTICE_HOME (default ~/.local/share/apprentice), or pulls that clone,
# then runs the clone's copy with the same options.
#
# Skills: skills/<name> -> ~/.claude/skills/<name> and ~/.agents/skills/<name>
#
# An existing link or directory that is not ours is left alone unless --force.
# Using the Claude Code plugin instead? Skip this script; the plugin carries
# the skills itself.
set -euo pipefail

# Piped (`bash <(curl ...)`, `curl | bash`), the source is a pipe or unset.
src="${BASH_SOURCE[0]:-}"
root=""
[ -f "$src" ] && root="$(cd "$(dirname "$src")/.." && pwd -P)"
force=0 dry=0 uninstall=0
for arg in "$@"; do
  case "$arg" in
    --force) force=1 ;;
    --dry-run) dry=1 ;;
    --uninstall) uninstall=1 ;;
    -h | --help)
      if [ -f "$src" ]; then sed -n '2,15p' "$src"; else echo "usage: install.sh [--force] [--dry-run] [--uninstall]"; fi
      exit 0 ;;
    *) echo "unknown option: $arg" >&2; exit 2 ;;
  esac
done

# No checkout here: we were piped in. Fetch or refresh the clone and hand over.
if [ ! -f "$root/scripts/install.sh" ] || [ ! -d "$root/skills" ]; then
  repo="${APPRENTICE_REPO:-https://github.com/rshingleton/apprentice.git}"
  home="${APPRENTICE_HOME:-$HOME/.local/share/apprentice}"
  command -v git >/dev/null || { echo "apprentice needs git on PATH" >&2; exit 1; }
  if [ -d "$home/.git" ]; then
    if [ "$dry" = 0 ] && [ "$uninstall" = 0 ]; then
      echo "updating $home"
      git -C "$home" pull --ff-only --quiet
    fi
  elif [ "$dry" = 1 ] || [ "$uninstall" = 1 ]; then
    echo "would clone $repo into $home; nothing installed from there yet"
    exit 0
  else
    echo "cloning $repo into $home"
    mkdir -p "$(dirname "$home")"
    git clone --quiet -- "$repo" "$home"
  fi
  exec bash "$home/scripts/install.sh" "$@"
fi

skill_dirs=("$HOME/.claude/skills" "$HOME/.agents/skills")

run() {
  if [ "$dry" = 1 ]; then echo "would: $*"; else "$@"; fi
}

# link <source> <target>: create or refresh a symlink we own.
link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    return 0
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if [ "$force" = 0 ]; then
      echo "skip  $dst (exists: $(readlink "$dst" 2>/dev/null || echo 'not a link'); --force to replace)"
      return 0
    fi
    run rm -rf "$dst"
  fi
  run ln -s "$src" "$dst"
  [ "$dry" = 1 ] || echo "link  $dst"
}

# unlink_ours <dir> <prefix>: remove every symlink in <dir> that points under
# <prefix>, including links to skills since renamed or removed.
unlink_ours() {
  local entry target
  for entry in "$1"/*; do
    [ -L "$entry" ] || continue
    target="$(readlink "$entry")"
    case "$target" in
      "$2"/*)
        run rm "$entry"
        [ "$dry" = 1 ] || echo "unlink $entry"
        ;;
    esac
  done
}

if [ "$uninstall" = 1 ]; then
  for dir in "${skill_dirs[@]}"; do
    unlink_ours "$dir" "$root/skills"
  done
  exit 0
fi

for dir in "${skill_dirs[@]}"; do
  run mkdir -p "$dir"
  for skill in "$root"/skills/*/; do
    [ -d "$skill" ] || continue
    link "${skill%/}" "$dir/$(basename "$skill")"
  done
done

echo "apprentice installed from $root"
