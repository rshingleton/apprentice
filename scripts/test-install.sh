#!/usr/bin/env bash
# Checks scripts/install.sh against a temporary HOME, never the real one.
#
#   scripts/test-install.sh
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
installer="$root/scripts/install.sh"
tmp="$(cd "$(mktemp -d)" && pwd -P)"
trap 'rm -rf "$tmp"' EXIT
export HOME="$tmp/home"
mkdir -p "$HOME"
skills=(mentor-plan mentor-scaffold mentor-hint mentor-diagnose mentor-review mentor-tutor)

fail() { echo "FAIL: $*" >&2; exit 1; }
linked() { [ -L "$1" ] && [ "$(readlink "$1")" = "$root/skills/$(basename "$1")" ]; }

# 1. install links every skill into both skill dirs
bash "$installer" >/dev/null
for dir in .claude/skills .agents/skills; do
  for s in "${skills[@]}"; do linked "$HOME/$dir/$s" || fail "$dir/$s not linked"; done
done

# 2. a second run links nothing new
out="$(bash "$installer")"
! grep -Eq "^(link|skip)" <<<"$out" || fail "second run changed or skipped something"

# 3. a foreign entry is skipped, then replaced under --force
rm "$HOME/.claude/skills/mentor-plan"
mkdir "$HOME/.claude/skills/mentor-plan"
out="$(bash "$installer")"
grep -q "^skip" <<<"$out" || fail "foreign dir was not skipped"
[ -d "$HOME/.claude/skills/mentor-plan" ] && [ ! -L "$HOME/.claude/skills/mentor-plan" ] || fail "foreign dir was touched"
bash "$installer" --force >/dev/null
linked "$HOME/.claude/skills/mentor-plan" || fail "--force did not replace the foreign dir"

# 4. uninstall removes ours and leaves a foreign link alone
ln -s /tmp "$HOME/.claude/skills/other-skill"
bash "$installer" --uninstall >/dev/null
for dir in .claude/skills .agents/skills; do
  for s in "${skills[@]}"; do [ ! -e "$HOME/$dir/$s" ] || fail "$dir/$s survived uninstall"; done
done
[ -L "$HOME/.claude/skills/other-skill" ] || fail "uninstall removed a foreign link"

# 5. dry-run writes nothing
rm -rf "$HOME" && mkdir -p "$HOME"
out="$(bash "$installer" --dry-run)"
grep -q "would" <<<"$out" || fail "dry-run printed nothing"
[ -z "$(ls -A "$HOME")" ] || fail "dry-run wrote to HOME"

# 6. piped mode: dry-run and uninstall without a clone write nothing and clone nothing
rm -rf "$HOME" && mkdir -p "$HOME"
cp "$installer" "$tmp/lone-install.sh"
for opt in --dry-run --uninstall; do
  out="$(APPRENTICE_REPO="$tmp/none" APPRENTICE_HOME="$tmp/clone" bash "$tmp/lone-install.sh" "$opt")"
  grep -q "^would clone" <<<"$out" || fail "piped $opt did not report 'would clone'"
  [ ! -e "$tmp/clone" ] && [ -z "$(ls -A "$HOME")" ] || fail "piped $opt wrote something"
done

# 7. piped mode clones, then pulls new commits
src="$tmp/src"
mkdir "$src"
(cd "$root" && tar --exclude=.git -cf - skills scripts) | tar -xf - -C "$src"
git -C "$src" init -q
git -C "$src" add -A
git -C "$src" -c user.name=test -c user.email=test@example.com commit -q -m "test source"
APPRENTICE_REPO="$src" APPRENTICE_HOME="$tmp/clone" bash "$tmp/lone-install.sh" >/dev/null
[ -d "$tmp/clone/.git" ] || fail "piped mode did not clone"
for s in "${skills[@]}"; do [ "$(readlink "$HOME/.claude/skills/$s")" = "$tmp/clone/skills/$s" ] || fail "$s not linked to the clone"; done
touch "$src/marker"
git -C "$src" add marker
git -C "$src" -c user.name=test -c user.email=test@example.com commit -q -m "new commit"
out="$(APPRENTICE_REPO="$src" APPRENTICE_HOME="$tmp/clone" bash "$tmp/lone-install.sh")"
grep -q "^updating" <<<"$out" || fail "second piped run did not report updating"
[ -e "$tmp/clone/marker" ] || fail "second piped run did not pull the new commit"

# 8. unknown option is refused with status 2
status=0
bash "$installer" --nope 2>/dev/null || status=$?
[ "$status" = 2 ] || fail "unknown option exited $status, not 2"

echo "install tests passed"
