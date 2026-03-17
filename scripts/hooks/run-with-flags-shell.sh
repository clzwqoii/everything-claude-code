#!/usr/bin/env bash
set -euo pipefail

# 中文说明：该包装脚本根据 profile 开关决定是否执行真实 hook，
# 未启用时原样透传 stdin，保证主流程无感。

HOOK_ID="${1:-}"
REL_SCRIPT_PATH="${2:-}"
PROFILES_CSV="${3:-standard,strict}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_ROOT="${CLAUDE_PLUGIN_ROOT:-$(cd "${SCRIPT_DIR}/../.." && pwd)}"

# Preserve stdin for passthrough or script execution
INPUT="$(cat)"

if [[ -z "$HOOK_ID" || -z "$REL_SCRIPT_PATH" ]]; then
  # 中文说明：参数不完整时，不做任何处理，直接透传输入。
  printf '%s' "$INPUT"
  exit 0
fi

# Ask Node helper if this hook is enabled
ENABLED="$(node "${PLUGIN_ROOT}/scripts/hooks/check-hook-enabled.js" "$HOOK_ID" "$PROFILES_CSV" 2>/dev/null || echo yes)"
if [[ "$ENABLED" != "yes" ]]; then
  # 中文说明：当前 profile 未启用该 hook，跳过执行。
  printf '%s' "$INPUT"
  exit 0
fi

SCRIPT_PATH="${PLUGIN_ROOT}/${REL_SCRIPT_PATH}"
if [[ ! -f "$SCRIPT_PATH" ]]; then
  # 中文说明：目标脚本不存在时仅告警并透传输入，不中断调用方。
  echo "[Hook] Script not found for ${HOOK_ID}: ${SCRIPT_PATH}" >&2
  printf '%s' "$INPUT"
  exit 0
fi

printf '%s' "$INPUT" | "$SCRIPT_PATH"
