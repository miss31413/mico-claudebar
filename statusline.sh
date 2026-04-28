#!/bin/bash
# ~/.claude/statusline.sh
# 視覺化 Claude Code 狀態列

input=$(cat)

# ── 解析 JSON ──────────────────────────────────────────
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
DIR=$(echo "$input"   | jq -r '.workspace.current_dir // ""')
PCT=$(echo "$input"   | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)

# 取得 git branch（失敗也不會噴錯）
BRANCH=""
if [ -n "$DIR" ] && cd "$DIR" 2>/dev/null; then
  BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
fi

# ── 進度條 ─────────────────────────────────────────────
BAR_WIDTH=10
FILLED=$(( PCT * BAR_WIDTH / 100 ))
EMPTY=$(( BAR_WIDTH - FILLED ))
BAR=$(printf '█%.0s' $(seq 1 $FILLED 2>/dev/null))$(printf '░%.0s' $(seq 1 $EMPTY 2>/dev/null))

# ── 顏色（ANSI） ───────────────────────────────────────
RESET='\033[0m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
DIM='\033[2m'

if   [ "$PCT" -ge 90 ]; then COLOR=$RED
elif [ "$PCT" -ge 70 ]; then COLOR=$YELLOW
else                         COLOR=$GREEN
fi

# ── 組合輸出 ───────────────────────────────────────────
FOLDER="${DIR##*/}"

OUTPUT="◆ ${MODEL}"

[ -n "$FOLDER" ] && OUTPUT="${OUTPUT}  ▸ ${FOLDER}"
[ -n "$BRANCH" ] && OUTPUT="${OUTPUT}  ⎇ ${BRANCH}"

OUTPUT="${OUTPUT}  ▓ ${COLOR}[${BAR}]${RESET} ${COLOR}${PCT}%${RESET}"

echo -e "$OUTPUT"
