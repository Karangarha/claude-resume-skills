#!/usr/bin/env bash
# install.sh — install claude-resume-skills into Claude Code's skills folder.
#
# From a clone of the repo:
#   bash install.sh                      all skills  ->  ~/.claude/skills   (every project)
#   bash install.sh --project            all skills  ->  ./.claude/skills   (this project only)
#   bash install.sh ats-beater           one skill
#   bash install.sh --target DIR         custom destination
#   bash install.sh --list               show the skills this repo ships
#
# Without cloning (downloads the latest main branch to a temp dir first):
#   curl -fsSL https://raw.githubusercontent.com/Karangarha/claude-resume-skills/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/Karangarha/claude-resume-skills/main/install.sh | bash -s -- --project resume-guide
#
# Re-running overwrites an installed skill with the repo's version (that is how you upgrade).
set -euo pipefail

REPO_URL="https://github.com/Karangarha/claude-resume-skills"
TARBALL="$REPO_URL/archive/refs/heads/main.tar.gz"

usage() {
  cat <<'EOF'
install.sh — install claude-resume-skills into Claude Code's skills folder.

  bash install.sh                      all skills  ->  ~/.claude/skills   (every project)
  bash install.sh --project            all skills  ->  ./.claude/skills   (this project only)
  bash install.sh ats-beater           one skill
  bash install.sh --target DIR         custom destination
  bash install.sh --list               show the skills this repo ships

Without cloning:
  curl -fsSL https://raw.githubusercontent.com/Karangarha/claude-resume-skills/main/install.sh | bash
  curl -fsSL https://raw.githubusercontent.com/Karangarha/claude-resume-skills/main/install.sh | bash -s -- --project resume-guide
EOF
}

target="${HOME}/.claude/skills"
list_only=0
skills=()

while [ $# -gt 0 ]; do
  case "$1" in
    --project)   target="$(pwd)/.claude/skills" ;;
    --target)    shift; target="${1:?--target needs a directory}" ;;
    --target=*)  target="${1#--target=}" ;;
    --list)      list_only=1 ;;
    -h|--help)   usage; exit 0 ;;
    -*)          echo "unknown option: $1" >&2; usage; exit 2 ;;
    *)           skills+=("$1") ;;
  esac
  shift
done

# Where are the skills? Next to this script when run from a clone; otherwise download.
src=""
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [ -n "$script_dir" ] && [ -d "$script_dir/skills" ]; then
  src="$script_dir/skills"
else
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' EXIT
  echo "Downloading ${REPO_URL} (main) ..."
  curl -fsSL "$TARBALL" | tar -xz -C "$tmp"
  src="$(find "$tmp" -mindepth 2 -maxdepth 2 -type d -name skills | head -n 1)"
  [ -n "$src" ] || { echo "download did not contain a skills/ folder" >&2; exit 1; }
fi

available=()
for d in "$src"/*/; do
  [ -f "$d/SKILL.md" ] && available+=("$(basename "$d")")
done
[ ${#available[@]} -gt 0 ] || { echo "no skills found in $src" >&2; exit 1; }

if [ "$list_only" -eq 1 ]; then
  for s in "${available[@]}"; do
    desc="$(sed -n 's/^description: *//p' "$src/$s/SKILL.md" | head -n 1 | tr -d '"' | cut -c1-110)"
    printf '%-14s %s...\n' "$s" "$desc"
  done
  exit 0
fi

if [ ${#skills[@]} -eq 0 ]; then
  skills=("${available[@]}")
fi

mkdir -p "$target"
for s in "${skills[@]}"; do
  if [ ! -f "$src/$s/SKILL.md" ]; then
    echo "no such skill: $s  (available: ${available[*]})" >&2
    exit 1
  fi
  rm -rf "${target:?}/$s"
  cp -R "$src/$s" "$target/$s"
  echo "installed  $s  ->  $target/$s"
done

echo
echo "Done. In Claude Code, invoke a skill by name (/ats-beater, /resume-guide) or just ask —"
echo "the description in each SKILL.md triggers it. ats-beater works best with poppler-utils"
echo "(pdftotext, pdffonts) and the pdfplumber Python package installed."
