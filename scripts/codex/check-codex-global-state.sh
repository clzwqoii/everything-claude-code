#!/usr/bin/env bash
set -euo pipefail

# ECC Codex global regression sanity check.
# Validates that global ~/.codex state matches expected ECC integration.
# 中文说明：该脚本用于检查全局 Codex 环境是否按 ECC 预期完成安装与配置。

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"

CONFIG_FILE="$CODEX_HOME/config.toml"
AGENTS_FILE="$CODEX_HOME/AGENTS.md"
PROMPTS_DIR="$CODEX_HOME/prompts"
SKILLS_DIR="$CODEX_HOME/skills"
HOOKS_DIR_EXPECT="${ECC_GLOBAL_HOOKS_DIR:-$CODEX_HOME/git-hooks}"
SANITY_PROFILE="${ECC_SANITY_PROFILE:-strict}"
EXPECTED_MIN_PROMPTS="${ECC_EXPECT_MIN_PROMPTS:-43}"

failures=0
warnings=0
checks=0

# 中文说明：统一输出结果并累计统计。
ok() {
  checks=$((checks + 1))
  printf '[OK] %s\n' "$*"
}

warn() {
  checks=$((checks + 1))
  warnings=$((warnings + 1))
  printf '[WARN] %s\n' "$*"
}

fail() {
  checks=$((checks + 1))
  failures=$((failures + 1))
  printf '[FAIL] %s\n' "$*"
}

# 中文说明：检查目标文件是否存在。
require_file() {
  local file="$1"
  local label="$2"
  if [[ -f "$file" ]]; then
    ok "$label exists ($file)"
  else
    fail "$label missing ($file)"
  fi
}

# 中文说明：检查 config.toml 中是否包含指定模式。
check_config_pattern() {
  local pattern="$1"
  local label="$2"
  if rg -n "$pattern" "$CONFIG_FILE" >/dev/null 2>&1; then
    ok "$label"
  else
    fail "$label"
  fi
}

# 中文说明：检查 config.toml 中是否不存在指定模式。
check_config_absent() {
  local pattern="$1"
  local label="$2"
  if rg -n "$pattern" "$CONFIG_FILE" >/dev/null 2>&1; then
    fail "$label"
  else
    ok "$label"
  fi
}

printf 'ECC GLOBAL SANITY CHECK\n'
printf 'Repo: %s\n' "$REPO_ROOT"
printf 'Codex home: %s\n\n' "$CODEX_HOME"
printf 'Sanity profile: %s\n' "$SANITY_PROFILE"
printf 'Expected minimum prompts: %s\n\n' "$EXPECTED_MIN_PROMPTS"

require_file "$CONFIG_FILE" "Global config.toml"
require_file "$AGENTS_FILE" "Global AGENTS.md"

if [[ -f "$AGENTS_FILE" ]]; then
  if rg -n '^# Everything Claude Code \(ECC\) — Agent Instructions' "$AGENTS_FILE" >/dev/null 2>&1; then
    ok "AGENTS contains ECC root instructions"
  else
    fail "AGENTS missing ECC root instructions"
  fi

  if rg -n '^# Codex Supplement \(From ECC \.codex/AGENTS\.md\)' "$AGENTS_FILE" >/dev/null 2>&1; then
    ok "AGENTS contains ECC Codex supplement"
  else
    fail "AGENTS missing ECC Codex supplement"
  fi
fi

if [[ -f "$CONFIG_FILE" ]]; then
  # 中文说明：配置文件项检查（功能开关、profile、MCP 段落等）。
  check_config_pattern '^multi_agent\s*=\s*true' "multi_agent is enabled"
  check_config_absent '^\s*collab\s*=' "deprecated collab flag is absent"

  if [[ "$SANITY_PROFILE" == "strict" ]]; then
    check_config_pattern '^persistent_instructions\s*=' "persistent_instructions is configured"
    check_config_pattern '^\[profiles\.strict\]' "profiles.strict exists"
    check_config_pattern '^\[profiles\.yolo\]' "profiles.yolo exists"
  else
    if rg -n '^persistent_instructions\s*=' "$CONFIG_FILE" >/dev/null 2>&1; then
      ok "persistent_instructions is configured"
    else
      warn "persistent_instructions is not configured (optional in slim mode)"
    fi

    if rg -n '^\[profiles\.strict\]' "$CONFIG_FILE" >/dev/null 2>&1; then
      ok "profiles.strict exists"
    else
      warn "profiles.strict missing (optional in slim mode)"
    fi

    if rg -n '^\[profiles\.yolo\]' "$CONFIG_FILE" >/dev/null 2>&1; then
      ok "profiles.yolo exists"
    else
      warn "profiles.yolo missing (optional in slim mode)"
    fi
  fi

  for section in \
    'mcp_servers.github' \
    'mcp_servers.memory' \
    'mcp_servers.sequential-thinking' \
    'mcp_servers.context7-mcp'
  do
    if rg -n "^\[$section\]" "$CONFIG_FILE" >/dev/null 2>&1; then
      ok "MCP section [$section] exists"
    else
      fail "MCP section [$section] missing"
    fi
  done

  if rg -n '^\[mcp_servers\.context7\]' "$CONFIG_FILE" >/dev/null 2>&1; then
    warn "Duplicate [mcp_servers.context7] exists (context7-mcp is preferred)"
  else
    ok "No duplicate [mcp_servers.context7] section"
  fi
fi

declare -a required_skills=(
  api-design
  article-writing
  backend-patterns
  coding-standards
  content-engine
  e2e-testing
  eval-harness
  frontend-patterns
  frontend-slides
  investor-materials
  investor-outreach
  market-research
  security-review
  strategic-compact
  tdd-workflow
  verification-loop
)

if [[ -d "$SKILLS_DIR" ]]; then
  # 中文说明：核对必需技能目录是否齐全。
  missing_skills=0
  for skill in "${required_skills[@]}"; do
    if [[ -d "$SKILLS_DIR/$skill" ]]; then
      :
    else
      printf '  - missing skill: %s\n' "$skill"
      missing_skills=$((missing_skills + 1))
    fi
  done

  if [[ "$missing_skills" -eq 0 ]]; then
    ok "All 16 ECC Codex skills are present"
  else
    fail "$missing_skills required skills are missing"
  fi
else
  fail "Skills directory missing ($SKILLS_DIR)"
fi

if [[ -f "$PROMPTS_DIR/ecc-prompts-manifest.txt" ]]; then
  ok "Command prompts manifest exists"
else
  fail "Command prompts manifest missing"
fi

if [[ -f "$PROMPTS_DIR/ecc-extension-prompts-manifest.txt" ]]; then
  ok "Extension prompts manifest exists"
else
  fail "Extension prompts manifest missing"
fi

command_prompts_count="$(find "$PROMPTS_DIR" -maxdepth 1 -type f -name 'ecc-*.md' 2>/dev/null | wc -l | tr -d ' ')"
if [[ "$command_prompts_count" -ge "$EXPECTED_MIN_PROMPTS" ]]; then
  ok "ECC prompts count is $command_prompts_count (expected >= $EXPECTED_MIN_PROMPTS)"
else
  fail "ECC prompts count is $command_prompts_count (expected >= $EXPECTED_MIN_PROMPTS)"
fi

hooks_path="$(git config --global --get core.hooksPath || true)"
# 中文说明：检查全局 Git hooksPath 与 hook 文件是否正确安装。
if [[ -n "$hooks_path" ]]; then
  if [[ "$hooks_path" == "$HOOKS_DIR_EXPECT" ]]; then
    ok "Global hooksPath is set to $HOOKS_DIR_EXPECT"
  else
    warn "Global hooksPath is $hooks_path (expected $HOOKS_DIR_EXPECT)"
  fi
else
  fail "Global hooksPath is not configured"
fi

if [[ -x "$HOOKS_DIR_EXPECT/pre-commit" ]]; then
  ok "Global pre-commit hook is installed and executable"
else
  fail "Global pre-commit hook missing or not executable"
fi

if [[ -x "$HOOKS_DIR_EXPECT/pre-push" ]]; then
  ok "Global pre-push hook is installed and executable"
else
  fail "Global pre-push hook missing or not executable"
fi

if command -v ecc-sync-codex >/dev/null 2>&1; then
  ok "ecc-sync-codex command is in PATH"
else
  warn "ecc-sync-codex is not in PATH"
fi

if command -v ecc-install-git-hooks >/dev/null 2>&1; then
  ok "ecc-install-git-hooks command is in PATH"
else
  warn "ecc-install-git-hooks is not in PATH"
fi

if command -v ecc-check-codex >/dev/null 2>&1; then
  ok "ecc-check-codex command is in PATH"
else
  warn "ecc-check-codex is not in PATH (this is expected before alias setup)"
fi

printf '\nSummary: checks=%d, warnings=%d, failures=%d\n' "$checks" "$warnings" "$failures"
if [[ "$failures" -eq 0 ]]; then
  printf 'ECC GLOBAL SANITY: PASS\n'
else
  printf 'ECC GLOBAL SANITY: FAIL\n'
  exit 1
fi
