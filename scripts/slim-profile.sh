#!/usr/bin/env bash
set -euo pipefail

# ECC 精简配置脚本（用于 main-slim 分支）
# 技术栈预设：frontend + python + php
# 中文说明：按保留清单裁剪仓库内容，生成精简版分支。
# 中文说明：建议在裁剪完成后按下列顺序执行（手动命令，不由本脚本自动执行）：
# 1) 复核改动：git status && git diff --stat
# 2) 提交裁剪：git add -A && git commit -m "chore: apply slim profile"
# 3) 将当前精简配置同步到本机使用环境（按你的使用方式二选一）：
#    - Claude Code 侧安装：在仓库根目录执行 ./install.sh --dry-run typescript php python  
#    - Codex 侧同步：在仓库根目录执行 bash scripts/sync-ecc-to-codex.sh
# 4) 验证命令是否可用：
#    /learn
#    /eval
#    /tdd
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

# 保留清单（按需调整）
# 中文说明：此配置为“极简 + 长期维护”预设：
# - continuous-learning-v2：核心 instinct/evolve 工作流
# - configure-ecc：后续扩展/重装时的交互式安装入口
# - skill-stocktake：用于周期性盘点技能与命令，降低长期漂移风险
# - tdd-workflow：测试驱动开发（RED -> GREEN -> REFACTOR）
KEEP_SKILLS=(
  continuous-learning-v2
  configure-ecc
  skill-stocktake
  tdd-workflow
  # 中文说明：/eval 推荐配套该技能；若本地没有可从 GitHub 拉取后保留。
  eval-harness
)

# 中文说明：命令执行顺序建议如下（从日常到周期性）：
# 1) /learn            -> 先沉淀阶段经验
# 2) /eval define/check <feature-name>  -> 定义并执行验收评估
#    /tdd <requirement>                 -> 按 TDD 完成功能实现（可在 2) 内迭代）
# 3) /instinct-status  -> 查看当前学习状态
# 4) /instinct-export  -> 先导出备份（可选）
# 5) /instinct-import  -> 需要时导入外部经验
# 6) /evolve           -> 周期性聚类演化
# 7) /promote          -> 将高价值项目直觉提升为全局
# 8) /projects         -> 跨项目巡检与对比
# 中文说明：推荐节奏
# - 每天/每阶段：1 -> 2 -> 3
# - 每周：6 -> 7 -> 3 -> 8（演化/提升后先复核状态，再做跨项目巡检）
# - 迁移/换机：4 -> 5 -> 3

KEEP_COMMANDS=(
  # 顺序 1：先做“学习沉淀”。
  # 作用：提炼当前会话中的模式、踩坑与可复用经验。
  # 步骤：1) 阶段结束时执行 2) 审核提炼结果 3) 需要时转为 instinct/skill。
  learn.md

  # 顺序 2：再做“验收评估”。
  # 作用：按验收标准进行结构化评估（通过/评分/量表）。
  # 步骤：1) 首次执行 /eval define <feature-name> 定义标准
  #      2) 开发阶段执行 /tdd <requirement>（测试先行）
  #      3) 阶段执行 /eval check <feature-name>
  #      4) 里程碑执行 /eval report <feature-name> 并补齐缺口。

  eval.md
  tdd.md

  # 顺序 3：查看学习状态与置信度变化。
  # 作用：查看当前 instinct/learning 状态与统计。
  # 步骤：1) 日开始或阶段结束执行 2) 检查新增与置信度 3) 决定后续整理动作。
  instinct-status.md

  # 顺序 4（可选）：导出备份，建议在重大改动前执行。
  # 作用：导出 instincts，便于备份、迁移、跨环境同步。
  # 步骤：1) 执行导出 2) 保存导出文件 3) 在目标环境用 /instinct-import 导入。
  instinct-export.md

  # 顺序 5（可选）：导入外部经验后再校验状态。
  # 作用：从文件导入 instincts，快速恢复或共享经验库。
  # 步骤：1) 准备导入文件 2) 执行导入 3) 用 /instinct-status 验证结果。
  instinct-import.md

  # 顺序 6：周期性执行聚类演化。
  # 作用：聚类与演化 instincts，减少重复并提升可用性。
  # 步骤：1) 累积一批 instincts 后执行 2) 复核聚类结果 3) 合并或拆分条目。
  evolve.md

  # 顺序 7：把高价值结果提升到更稳定层级。
  # 作用：将高价值 instinct 提升为更稳定的资产（如规则/技能候选）。
  # 步骤：1) 选择高置信度条目 2) 执行提升 3) 人工确认最终落地内容。
  promote.md

  # 顺序 8：最后做跨项目巡检，避免作用域污染。
  # 作用：查看项目维度的学习资产与状态，避免跨项目污染。
  # 步骤：1) 切换项目后执行 2) 校验作用域 3) 决定是否同步或隔离。
  projects.md
)

KEEP_AGENTS=(
  # 中文说明：/tdd 对应的执行代理。
  tdd-guide.md
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
