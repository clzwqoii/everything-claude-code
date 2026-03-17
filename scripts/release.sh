#!/usr/bin/env bash
set -euo pipefail

# Release script for bumping plugin version
# Usage: ./scripts/release.sh VERSION
# 中文说明：用于统一升级版本号并执行提交、打 tag、推送。

VERSION="${1:-}"
ROOT_PACKAGE_JSON="package.json"
PLUGIN_JSON=".claude-plugin/plugin.json"
MARKETPLACE_JSON=".claude-plugin/marketplace.json"
OPENCODE_PACKAGE_JSON=".opencode/package.json"

# Function to show usage
usage() {
  # 中文说明：参数不合法时输出帮助并退出。
  echo "Usage: $0 VERSION"
  echo "Example: $0 1.5.0"
  exit 1
}

# Validate VERSION is provided
if [[ -z "$VERSION" ]]; then
  echo "Error: VERSION argument is required"
  usage
fi

# Validate VERSION is semver format (X.Y.Z)
if ! [[ "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: VERSION must be in semver format (e.g., 1.5.0)"
  exit 1
fi

# Check current branch is main
CURRENT_BRANCH=$(git branch --show-current)
if [[ "$CURRENT_BRANCH" != "main" ]]; then
  echo "Error: Must be on main branch (currently on $CURRENT_BRANCH)"
  exit 1
fi

# Check working tree is clean
# 中文说明：发布前要求工作区干净，避免夹带未提交变更。
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Error: Working tree is not clean. Commit or stash changes first."
  exit 1
fi

# Verify versioned manifests exist
for FILE in "$ROOT_PACKAGE_JSON" "$PLUGIN_JSON" "$MARKETPLACE_JSON" "$OPENCODE_PACKAGE_JSON"; do
  if [[ ! -f "$FILE" ]]; then
    echo "Error: $FILE not found"
    exit 1
  fi
done

# Read current version from plugin.json
OLD_VERSION=$(grep -oE '"version": *"[^"]*"' "$PLUGIN_JSON" | head -1 | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
if [[ -z "$OLD_VERSION" ]]; then
  echo "Error: Could not extract current version from $PLUGIN_JSON"
  exit 1
fi
echo "Bumping version: $OLD_VERSION -> $VERSION"

update_version() {
  # 中文说明：兼容 macOS 与 Linux 的 sed -i 差异。
  local file="$1"
  local pattern="$2"
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "$pattern" "$file"
  else
    sed -i "$pattern" "$file"
  fi
}

# Update all shipped package/plugin manifests
update_version "$ROOT_PACKAGE_JSON" "s|\"version\": *\"[^\"]*\"|\"version\": \"$VERSION\"|"
update_version "$PLUGIN_JSON" "s|\"version\": *\"[^\"]*\"|\"version\": \"$VERSION\"|"
update_version "$MARKETPLACE_JSON" "0,/\"version\": *\"[^\"]*\"/s|\"version\": *\"[^\"]*\"|\"version\": \"$VERSION\"|"
update_version "$OPENCODE_PACKAGE_JSON" "s|\"version\": *\"[^\"]*\"|\"version\": \"$VERSION\"|"

# Stage, commit, tag, and push
# 中文说明：发布链路：暂存 -> 提交 -> 打标签 -> 推送分支与标签。
git add "$ROOT_PACKAGE_JSON" "$PLUGIN_JSON" "$MARKETPLACE_JSON" "$OPENCODE_PACKAGE_JSON"
git commit -m "chore: bump plugin version to $VERSION"
git tag "v$VERSION"
git push origin main "v$VERSION"

echo "Released v$VERSION"
