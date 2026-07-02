#!/usr/bin/env bash
# jigeumlab-skills 설치 스크립트
# 사용법:
#   ./install.sh          # Codex CLI  → ~/.agents/skills
#   ./install.sh claude   # Claude Code → ~/.claude/skills
set -euo pipefail

TARGET="${1:-codex}"
SRC="$(cd "$(dirname "$0")/skills" && pwd)"

case "$TARGET" in
  codex)  DEST="$HOME/.agents/skills" ;;
  claude) DEST="$HOME/.claude/skills" ;;
  *) echo "알 수 없는 대상: $TARGET (codex | claude)"; exit 1 ;;
esac

mkdir -p "$DEST"
cp -R "$SRC"/* "$DEST"/
echo "✅ $(ls -1 "$SRC" | wc -l | tr -d ' ')개 스킬 → $DEST 설치 완료"
