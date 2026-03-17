#!/usr/bin/env bash
set -euo pipefail

# Install ECC git safety hooks globally via core.hooksPath.
# Usage:
#   ./scripts/codex/install-global-git-hooks.sh
#   ./scripts/codex/install-global-git-hooks.sh --dry-run
# 中文说明：将 ECC 提供的 pre-commit / pre-push 以全局方式安装到 core.hooksPath。

MODE="apply"
if [[ "${1:-}" == "--dry-run" ]]; then
  MODE="dry-run"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
SOURCE_DIR="$REPO_ROOT/scripts/codex-git-hooks"
DEST_DIR="${ECC_GLOBAL_HOOKS_DIR:-$HOME/.codex/git-hooks}"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$HOME/.codex/backups/git-hooks-$STAMP"

log() {
  # 中文说明：统一日志前缀，便于识别脚本输出来源。
  printf '[ecc-hooks] %s\n' "$*"
}

run_or_echo() {
  # 中文说明：dry-run 模式只打印命令，apply 模式实际执行。
  if [[ "$MODE" == "dry-run" ]]; then
    printf '[dry-run] %s\n' "$*"
  else
    eval "$*"
  fi
}

if [[ ! -d "$SOURCE_DIR" ]]; then
  log "Missing source hooks directory: $SOURCE_DIR"
  exit 1
fi

log "Mode: $MODE"
log "Source hooks: $SOURCE_DIR"
log "Global hooks destination: $DEST_DIR"

if [[ -d "$DEST_DIR" ]]; then
  # 中文说明：若目标目录已存在，先做时间戳备份，避免覆盖丢失。
  log "Backing up existing hooks directory to $BACKUP_DIR"
  run_or_echo "mkdir -p \"$BACKUP_DIR\""
  run_or_echo "cp -R \"$DEST_DIR\" \"$BACKUP_DIR/hooks\""
fi

run_or_echo "mkdir -p \"$DEST_DIR\""
run_or_echo "cp \"$SOURCE_DIR/pre-commit\" \"$DEST_DIR/pre-commit\""
run_or_echo "cp \"$SOURCE_DIR/pre-push\" \"$DEST_DIR/pre-push\""
run_or_echo "chmod +x \"$DEST_DIR/pre-commit\" \"$DEST_DIR/pre-push\""

if [[ "$MODE" == "apply" ]]; then
  prev_hooks_path="$(git config --global core.hooksPath || true)"
  if [[ -n "$prev_hooks_path" ]]; then
    log "Previous global hooksPath: $prev_hooks_path"
  fi
fi
run_or_echo "git config --global core.hooksPath \"$DEST_DIR\""

log "Installed ECC global git hooks."
log "Disable per repo by creating .ecc-hooks-disable in project root."
log "Temporary bypass: ECC_SKIP_PRECOMMIT=1 or ECC_SKIP_PREPUSH=1"
