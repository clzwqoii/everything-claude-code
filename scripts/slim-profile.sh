#!/usr/bin/env bash
set -euo pipefail

# Slim profile for ECC fork branch (main-slim)
# Tech stack preset: frontend + python + php
# 中文说明：按保留清单裁剪仓库内容，生成精简版分支。
# 中文说明：建议在裁剪完成后按下列顺序执行（手动命令，不由本脚本自动执行）：
# 1) 复核改动：git status && git diff --stat
# 2) 提交裁剪：git add -A && git commit -m "chore: apply slim profile"
# 3) 将当前精简配置同步到本机使用环境（按你的使用方式二选一）：
#    - Claude Code 侧安装：在仓库根目录执行 ./install.sh --dry-run typescript php python  
#    - Codex 侧同步：在仓库根目录执行 bash scripts/sync-ecc-to-codex.sh
# 4) 验证命令是否可用：
#    /skill-create
#    /instinct-status
#    /instinct-import <file>
#    /instinct-export
#    /evolve
#    /promote
#    /projects



# 推荐顺序（你现在这个场景）

# 先在仓库执行精简脚本（如果还没执行）。
# 执行 ./install.sh --dry-run typescript php python  （安装到 Claude Code）。
# 执行 scripts/sync-ecc-to-codex.sh（同步到 Codex）。
# 分别在两个工具里验证命令可用性。
# 更稳妥做法

# 先跑 dry-run 看变化：
# bash sync-ecc-to-codex.sh --dry-run
# ./install.sh --dry-run typescript php python  
# 确认后再正式执行。

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "[错误] 当前目录不是 Git 仓库。"
  exit 1
fi

CURRENT_BRANCH="$(git branch --show-current)"
if [[ "$CURRENT_BRANCH" != "main-slim" ]]; then
  echo "[警告] 当前分支是 '$CURRENT_BRANCH'（预期为 main-slim）。"
  echo "[警告] 3 秒后继续执行..."
  sleep 3
fi

# Keep lists (edit as needed)
# 中文说明：此配置为“极简 + 长期维护”预设：
# - continuous-learning-v2：核心 instinct/evolve 工作流
# - configure-ecc：后续扩展/重装时的交互式安装入口
# - skill-stocktake：用于周期性盘点技能与命令，降低长期漂移风险
KEEP_SKILLS=(
  continuous-learning-v2
  configure-ecc
  skill-stocktake
)

KEEP_COMMANDS=(
  skill-create.md
  instinct-status.md
  instinct-import.md
  instinct-export.md
  evolve.md
  promote.md
  projects.md
)

KEEP_AGENTS=(
  # 中文说明：该工作流主要依赖命令与技能，不依赖专门 agent。
)

KEEP_RULE_DIRS=(
  # 中文说明：你会写 TS/PHP，所以保留对应规则；skills 仍保持最小集。
  common
  python
  typescript
  php
)

contains() {
  # 中文说明：判断某个值是否出现在保留列表中。
  local needle="$1"
  shift
  for item in "$@"; do
    if [[ "$item" == "$needle" ]]; then
      return 0
    fi
  done
  return 1
}

prune_skill_dirs() {
  # 中文说明：删除不在 KEEP_SKILLS 中的技能目录。
  local base="skills"
  [[ -d "$base" ]] || return 0

  while IFS= read -r -d '' dir; do
    local name
    name="$(basename "$dir")"
    if ! contains "$name" "${KEEP_SKILLS[@]}"; then
      rm -rf "$dir"
      echo "[删除] skills/$name"
    fi
  done < <(find "$base" -mindepth 1 -maxdepth 1 -type d -print0)
}

prune_command_files() {
  # 中文说明：删除不在 KEEP_COMMANDS 中的命令文件。
  local base="commands"
  [[ -d "$base" ]] || return 0

  while IFS= read -r -d '' file; do
    local name
    name="$(basename "$file")"
    if ! contains "$name" "${KEEP_COMMANDS[@]}"; then
      rm -f "$file"
      echo "[删除] commands/$name"
    fi
  done < <(find "$base" -mindepth 1 -maxdepth 1 -type f -name "*.md" -print0)
}

prune_agent_files() {
  # 中文说明：删除不在 KEEP_AGENTS 中的 agent 文件。
  local base="agents"
  [[ -d "$base" ]] || return 0

  while IFS= read -r -d '' file; do
    local name
    name="$(basename "$file")"
    if ! contains "$name" "${KEEP_AGENTS[@]}"; then
      rm -f "$file"
      echo "[删除] agents/$name"
    fi
  done < <(find "$base" -mindepth 1 -maxdepth 1 -type f -name "*.md" -print0)
}

prune_rule_dirs() {
  # 中文说明：删除不在 KEEP_RULE_DIRS 中的规则目录。
  local base="rules"
  [[ -d "$base" ]] || return 0

  while IFS= read -r -d '' dir; do
    local name
    name="$(basename "$dir")"
    if ! contains "$name" "${KEEP_RULE_DIRS[@]}"; then
      rm -rf "$dir"
      echo "[删除] rules/$name"
    fi
  done < <(find "$base" -mindepth 1 -maxdepth 1 -type d -print0)
}

print_counts() {
  # 中文说明：输出裁剪后的目录数量统计。
  echo
  echo "==== 精简统计 ===="
  echo "技能目录：$(find skills -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')"
  echo "命令文件：$(find commands -mindepth 1 -maxdepth 1 -type f -name "*.md" 2>/dev/null | wc -l | tr -d ' ')"
  echo "代理文件：$(find agents -mindepth 1 -maxdepth 1 -type f -name "*.md" 2>/dev/null | wc -l | tr -d ' ')"
  echo "规则目录：$(find rules -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')"
  echo "=================="
  echo
}

main() {
  # 中文说明：执行裁剪主流程并输出后续建议。
  echo "[信息] 正在应用精简配置，目录：$ROOT_DIR"
  prune_skill_dirs
  prune_command_files
  prune_agent_files
  prune_rule_dirs
  print_counts

  echo "[信息] 精简完成，请先执行：git status 检查改动"
  echo "[信息] 提交命令：git add -A && git commit -m \"chore: apply slim profile\""
  echo "[信息] 然后安装/同步：./install.sh --dry-run typescript php python  或  bash scripts/sync-ecc-to-codex.sh"
}

main "$@"
