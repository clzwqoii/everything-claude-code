---
name: everything-claude-code-conventions
description: Development conventions and patterns for everything-claude-code. JavaScript project with conventional commits.
---

# Everything Claude Code Conventions

> Generated from [clzwqoii/everything-claude-code](https://github.com/clzwqoii/everything-claude-code) on 2026-03-23

## Overview

This skill teaches Claude the development patterns and conventions used in everything-claude-code.

## Tech Stack

- **Primary Language**: JavaScript
- **Architecture**: hybrid module organization
- **Test Location**: separate

## When to Use This Skill

Activate this skill when:
- Making changes to this repository
- Adding new features following established patterns
- Writing tests that match project conventions
- Creating commits with proper message format

## Commit Conventions

Follow these commit message conventions based on 200 analyzed commits.

### Commit Style: Conventional Commits

### Prefixes Used

- `fix`
- `feat`
- `docs`

### Message Guidelines

- Average message length: ~56 characters
- Keep first line concise and descriptive
- Use imperative mood ("Add feature" not "Added feature")


*Commit message example*

```text
docs: add ECC 2.0 reference architecture from competitor research
```

*Commit message example*

```text
feat(skills): add santa-method - multi-agent adversarial verification (#760)
```

*Commit message example*

```text
perf(hooks): move post-edit-format and post-edit-typecheck to strict-only (#757)
```

*Commit message example*

```text
fix: safe Codex config sync — merge AGENTS.md + add-only MCP servers (#723)
```

*Commit message example*

```text
security: remove supply chain risks, external promotions, and unauthorized credits
```

*Commit message example*

```text
feat: pending instinct TTL pruning and /prune command (#725)
```

*Commit message example*

```text
feat: add click-path-audit skill — finds state interaction bugs (#729)
```

*Commit message example*

```text
feat(skills): add Kysely migration patterns to database-migrations (#731)
```

## Architecture

### Project Structure: Single Package

This project uses **hybrid** module organization.

### Configuration Files

- `.github/workflows/ci.yml`
- `.github/workflows/maintenance.yml`
- `.github/workflows/monthly-metrics.yml`
- `.github/workflows/release.yml`
- `.github/workflows/reusable-release.yml`
- `.github/workflows/reusable-test.yml`
- `.github/workflows/reusable-validate.yml`
- `.opencode/package.json`
- `.opencode/tsconfig.json`
- `.prettierrc`
- `eslint.config.js`
- `package.json`

### Guidelines

- This project uses a hybrid organization
- Follow existing patterns when adding new code

## Code Style

### Language: JavaScript

### Naming Conventions

| Element | Convention |
|---------|------------|
| Files | camelCase |
| Functions | camelCase |
| Classes | PascalCase |
| Constants | SCREAMING_SNAKE_CASE |

### Import Style: Relative Imports

### Export Style: Mixed Style


*Preferred import style*

```typescript
// Use relative imports
import { Button } from '../components/Button'
import { useAuth } from './hooks/useAuth'
```

## Testing

### Test Framework

No specific test framework detected — use the repository's existing test patterns.

### File Pattern: `*.test.js`

### Test Types

- **Unit tests**: Test individual functions and components in isolation
- **Integration tests**: Test interactions between multiple components/services

### Coverage

This project has coverage reporting configured. Aim for 80%+ coverage.


## Error Handling

### Error Handling Style: Try-Catch Blocks


*Standard error handling pattern*

```typescript
try {
  const result = await riskyOperation()
  return result
} catch (error) {
  console.error('Operation failed:', error)
  throw new Error('User-friendly message')
}
```

## Common Workflows

These workflows were detected from analyzing commit patterns.

### Database Migration

Database schema changes with migration files

**Frequency**: ~2 times per month

**Steps**:
1. Create migration file
2. Update schema definitions
3. Generate/update types

**Files typically involved**:
- `migrations/*`

**Example commit sequence**:
```
feat(rules): add C# language support (#704)
fix: sanitize SessionStart session summaries (#710)
feat: add MCP health-check hook (#711)
```

### Feature Development

Standard feature implementation workflow

**Frequency**: ~16 times per month

**Steps**:
1. Add feature implementation
2. Add tests for feature
3. Update documentation

**Files typically involved**:
- `manifests/*`
- `**/*.test.*`
- `**/api/**`

**Example commit sequence**:
```
fix(tests): resolve Windows CI test failures (#701)
fix: stabilize windows project metadata assertions
feat: agent description compression with lazy loading (#696)
```

### Add Or Update Skill

Adds a new skill or updates an existing skill, including documentation and sometimes integration with agents or policies.

**Frequency**: ~3 times per month

**Steps**:
1. Create or update skills/<skill-name>/SKILL.md or docs/zh-CN/skills/<skill-name>/SKILL.md or docs/tr/skills/<skill-name>/SKILL.md
2. Document architecture, patterns, or usage in the SKILL.md file
3. Optionally update AGENTS.md, README.md, or related docs to reflect the new skill

**Files typically involved**:
- `skills/*/SKILL.md`
- `docs/zh-CN/skills/*/SKILL.md`
- `docs/tr/skills/*/SKILL.md`
- `AGENTS.md`
- `README.md`

**Example commit sequence**:
```
Create or update skills/<skill-name>/SKILL.md or docs/zh-CN/skills/<skill-name>/SKILL.md or docs/tr/skills/<skill-name>/SKILL.md
Document architecture, patterns, or usage in the SKILL.md file
Optionally update AGENTS.md, README.md, or related docs to reflect the new skill
```

### Add Or Update Agent

Adds a new agent or updates an existing agent, with documentation and sometimes related skill or config updates.

**Frequency**: ~2 times per month

**Steps**:
1. Create or update agents/<agent-name>.md or docs/zh-CN/agents/<agent-name>.md or docs/tr/agents/<agent-name>.md
2. Document agent capabilities and usage
3. Optionally update AGENTS.md, README.md, or related docs

**Files typically involved**:
- `agents/*.md`
- `docs/zh-CN/agents/*.md`
- `docs/tr/agents/*.md`
- `AGENTS.md`
- `README.md`

**Example commit sequence**:
```
Create or update agents/<agent-name>.md or docs/zh-CN/agents/<agent-name>.md or docs/tr/agents/<agent-name>.md
Document agent capabilities and usage
Optionally update AGENTS.md, README.md, or related docs
```

### Add Or Update Command Doc

Adds or updates documentation for a CLI command in multiple languages.

**Frequency**: ~4 times per month

**Steps**:
1. Create or update docs/commands/<command>.md or docs/zh-CN/commands/<command>.md or docs/tr/commands/<command>.md or docs/pt-BR/commands/<command>.md
2. Document command usage, options, and examples
3. Optionally update README.md to reference the new/changed command

**Files typically involved**:
- `docs/commands/*.md`
- `docs/zh-CN/commands/*.md`
- `docs/tr/commands/*.md`
- `docs/pt-BR/commands/*.md`
- `README.md`

**Example commit sequence**:
```
Create or update docs/commands/<command>.md or docs/zh-CN/commands/<command>.md or docs/tr/commands/<command>.md or docs/pt-BR/commands/<command>.md
Document command usage, options, and examples
Optionally update README.md to reference the new/changed command
```

### Add Or Update Language Support

Adds or updates language-specific rules, patterns, or testing guides.

**Frequency**: ~2 times per month

**Steps**:
1. Create or update rules/<language>/*.md
2. Document coding style, hooks, patterns, security, and testing for the language
3. Optionally update manifests or install scripts

**Files typically involved**:
- `rules/*/coding-style.md`
- `rules/*/hooks.md`
- `rules/*/patterns.md`
- `rules/*/security.md`
- `rules/*/testing.md`
- `manifests/install-components.json`
- `scripts/lib/install-manifests.js`

**Example commit sequence**:
```
Create or update rules/<language>/*.md
Document coding style, hooks, patterns, security, and testing for the language
Optionally update manifests or install scripts
```

### Add Or Update Localization

Adds or updates documentation in a new or existing language (localization).

**Frequency**: ~2 times per month

**Steps**:
1. Create or update docs/<locale>/* (e.g., docs/zh-CN/, docs/tr/, docs/pt-BR/)
2. Translate or update multiple files: AGENTS.md, README.md, commands, skills, rules, examples, etc.
3. Update README.md to add language link and increment language count

**Files typically involved**:
- `docs/zh-CN/**/*`
- `docs/tr/**/*`
- `docs/pt-BR/**/*`
- `README.md`

**Example commit sequence**:
```
Create or update docs/<locale>/* (e.g., docs/zh-CN/, docs/tr/, docs/pt-BR/)
Translate or update multiple files: AGENTS.md, README.md, commands, skills, rules, examples, etc.
Update README.md to add language link and increment language count
```

### Feature Or Tool Development With Tests And Docs

Implements a new feature or tool, adds tests, and updates documentation.

**Frequency**: ~2 times per month

**Steps**:
1. Implement feature in scripts/, hooks/, or core directories
2. Add or update tests in tests/
3. Document the feature in README.md, AGENTS.md, or command docs

**Files typically involved**:
- `scripts/**/*.js`
- `hooks/**/*.js`
- `hooks/hooks.json`
- `tests/**/*.js`
- `README.md`
- `AGENTS.md`
- `commands/*.md`

**Example commit sequence**:
```
Implement feature in scripts/, hooks/, or core directories
Add or update tests in tests/
Document the feature in README.md, AGENTS.md, or command docs
```

### Sync Or Merge Configurations

Synchronizes or merges configuration files between ECC and downstream projects (e.g., Codex), preserving user content.

**Frequency**: ~2 times per month

**Steps**:
1. Update or create scripts/sync-ecc-to-codex.sh or scripts/codex/merge-mcp-config.js
2. Run script to merge/sync AGENTS.md or config.toml, preserving user content outside ECC-managed markers
3. Update README.md and document sync behavior

**Files typically involved**:
- `scripts/sync-ecc-to-codex.sh`
- `scripts/codex/merge-mcp-config.js`
- `.codex/AGENTS.md`
- `README.md`

**Example commit sequence**:
```
Update or create scripts/sync-ecc-to-codex.sh or scripts/codex/merge-mcp-config.js
Run script to merge/sync AGENTS.md or config.toml, preserving user content outside ECC-managed markers
Update README.md and document sync behavior
```


## Best Practices

Based on analysis of the codebase, follow these practices:

### Do

- Use conventional commit format (feat:, fix:, etc.)
- Follow *.test.js naming pattern
- Use camelCase for file names
- Prefer mixed exports

### Don't

- Don't write vague commit messages
- Don't skip tests for new features
- Don't deviate from established patterns without discussion

---

*This skill was auto-generated by [ECC Tools](https://ecc.tools). Review and customize as needed for your team.*
