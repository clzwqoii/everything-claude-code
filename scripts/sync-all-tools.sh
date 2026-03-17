#!/usr/bin/env bash
set -euo pipefail

# 一键同步入口：
# 1) 固定执行 Claude Code 与 Codex 的同步。
# 2) Copilot/Gemini/iFlow/Qwen 通过环境变量传入命令后可自动执行。
#
# 用法：
#   bash scripts/sync-all-tools.sh --dry-run
#   bash scripts/sync-all-tools.sh
#
# 可选环境变量（示例）：
#   export COPILOT_SYNC_CMD='code --install-extension GitHub.copilot-chat'
#   export GEMINI_SYNC_CMD='echo "replace with your gemini sync command"'
#   export IFLOW_SYNC_CMD='echo "replace with your iflow sync command"'
#   export QWEN_SYNC_CMD='echo "replace with your qwen sync command"'

MODE="apply"
if [[ "${1:-}" == "--dry-run" ]]; then
  MODE="dry-run"
fi

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT_DIR"

log() {
  printf '[sync-all] %s\n' "$*"
}

run_cmd() {
  local tool_name="$1"
  local cmd="$2"
  if [[ "$MODE" == "dry-run" ]]; then
    log "[dry-run][$tool_name] $cmd"
  else
    log "[$tool_name] 执行中..."
    eval "$cmd"
    log "[$tool_name] 完成"
  fi
}

run_optional_env_cmd() {
  local tool_name="$1"
  local env_name="$2"
  local cmd="${!env_name:-}"

  if [[ -z "$cmd" ]]; then
    log "[$tool_name] 未配置（设置 $env_name 后可接入一键同步）"
    return 0
  fi

  run_cmd "$tool_name" "$cmd"
}

main() {
  log "模式：$MODE"
  log "仓库：$ROOT_DIR"

  run_cmd "Claude" "./install.sh"
  if [[ "$MODE" == "dry-run" ]]; then
    run_cmd "Codex" "bash scripts/sync-ecc-to-codex.sh --dry-run"
  else
    run_cmd "Codex" "bash scripts/sync-ecc-to-codex.sh"
  fi

  run_optional_env_cmd "Copilot" "COPILOT_SYNC_CMD"
  run_optional_env_cmd "Gemini" "GEMINI_SYNC_CMD"
  run_optional_env_cmd "iFlow" "IFLOW_SYNC_CMD"
  run_optional_env_cmd "Qwen" "QWEN_SYNC_CMD"

  log "全部流程结束。"
}

main "$@"
