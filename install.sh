#!/usr/bin/env bash
# install.sh — Legacy shell entrypoint for the ECC installer.
#
# This wrapper resolves the real repo/package root when invoked through a
# symlinked npm bin, then delegates to the Node-based installer runtime.
# 中文说明：本脚本仅负责解析软链接后的真实路径，并转交给 Node 安装入口执行。

set -euo pipefail

SCRIPT_PATH="$0"
# 中文说明：循环解析符号链接，直到拿到真实脚本路径。
while [ -L "$SCRIPT_PATH" ]; do
    link_dir="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"
    SCRIPT_PATH="$(readlink "$SCRIPT_PATH")"
    [[ "$SCRIPT_PATH" != /* ]] && SCRIPT_PATH="$link_dir/$SCRIPT_PATH"
done
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" && pwd)"

# 中文说明：将全部参数透传给 Node 版安装器。
exec node "$SCRIPT_DIR/scripts/install-apply.js" "$@"
