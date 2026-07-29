#!/usr/bin/env bash
# claude-skills - skilleri ~/.claude/skills/ icine qurasdirir (Linux / macOS)
# Istifade:  bash install.sh          (movcud eyniadli skil uzerine yazilmir)
#            bash install.sh --force  (uzerine yazir)
set -euo pipefail

REPO_SKILLS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills"
TARGET="$HOME/.claude/skills"
FORCE=0
[[ "${1:-}" == "--force" ]] && FORCE=1

if [[ ! -d "$REPO_SKILLS" ]]; then
  echo "XETA: skills/ qovlugu tapilmadi: $REPO_SKILLS" >&2
  exit 1
fi

mkdir -p "$TARGET"

qurulan=0
atlanan=0

for dir in "$REPO_SKILLS"/*/; do
  [[ -d "$dir" ]] || continue
  name="$(basename "$dir")"
  if [[ -e "$TARGET/$name" && $FORCE -eq 0 ]]; then
    echo "ATLANDI  $name  (artiq var - uzerine yazmaq ucun --force)"
    atlanan=$((atlanan+1))
    continue
  fi
  rm -rf "$TARGET/$name"
  cp -R "$dir" "$TARGET/$name"
  echo "QURULDU  $name"
  qurulan=$((qurulan+1))
done

echo
echo "Netice: $qurulan qurashdirildi, $atlanan atlandi."
echo "Claude Code-u yeniden baslat, sonra /context ile yoxla."
