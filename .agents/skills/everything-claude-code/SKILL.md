```markdown
# everything-claude-code Development Patterns

> Auto-generated skill from repository analysis

## Overview

This skill teaches you the core development patterns, coding conventions, and collaborative workflows used in the `everything-claude-code` JavaScript repository. You'll learn how to contribute new skills, agents, commands, install targets, and documentation, as well as how to keep catalogs and manifests in sync. The guide also covers code style, testing approaches, and the use of standardized `/commands` for common tasks.

---

## Coding Conventions

**File Naming**
- Use `camelCase` for JavaScript files and directories.
  - Example: `installTargets.js`, `mySkillDirectory/`

**Import Style**
- Use relative imports for internal modules.
  ```js
  // Good
  const utils = require('../lib/utils');
  // Bad
  const utils = require('lib/utils');
  ```

**Export Style**
- Mixed: Both `module.exports` and ES6 `export`/`export default` are used.
  ```js
  // CommonJS
  module.exports = function myFunction() { ... };

  // ES6
  export function myFunction() { ... }
  export default myFunction;
  ```

**Commit Messages**
- Use [Conventional Commits](https://www.conventionalcommits.org/) with these prefixes:
  - `feat`: New feature
  - `fix`: Bug fix
  - `docs`: Documentation changes
  - `chore`: Maintenance, refactoring, or tooling
- Keep commit messages concise (~58 characters on average).

---

## Workflows

### Add New Skill or Agent
**Trigger:** When introducing a new skill or agent to the system  
**Command:** `/add-skill`

1. Create or update `SKILL.md` in `skills/<skill-name>/` or `.agents/skills/<agent-name>/`.
2. Optionally, add an agent definition in `agents/<agent-name>.md`.
3. Update `manifests/install-modules.json` to register the new skill/agent.
4. Update `AGENTS.md` and/or `README.md` to reflect the addition.
5. Optionally, update `docs/zh-CN/AGENTS.md` and `docs/zh-CN/README.md` for localization.
6. If needed, add or update tests for catalog validation.

**Example:**
```bash
# Add a new skill
/add-skill myNewSkill
```

---

### Add or Update Command Workflow
**Trigger:** When introducing or updating a CLI or agent workflow command  
**Command:** `/add-command`

1. Create or update `commands/<command-name>.md`.
2. For new commands, add YAML frontmatter and documentation sections (Purpose, Usage, Output, etc.).
3. If related to agents or skills, update `AGENTS.md` and/or `README.md`.
4. If the command produces artifacts, document output locations.
5. Optionally, add or update tests for command validation.

---

### Add New Install Target or Adapter
**Trigger:** When supporting a new platform, plugin, or integration  
**Command:** `/add-install-target`

1. Create install/uninstall scripts in a new directory (e.g., `.codebuddy/`, `.gemini/`).
2. Add or update the install target entry in `scripts/lib/install-targets/<target>.js`.
3. Update `manifests/install-modules.json` and `schemas/ecc-install-config.schema.json`.
4. Update `scripts/lib/install-manifests.js` and `scripts/lib/install-targets/registry.js` as needed.
5. Add or update tests for install targets.
6. Update `README.md` or related docs.

---

### Sync or Update Catalogs and Manifests
**Trigger:** When adding, removing, or updating skills/agents/commands  
**Command:** `/sync-catalogs`

1. Update `manifests/install-modules.json` and/or `package.json`.
2. Update `scripts/ci/catalog.js` or related sync scripts.
3. Update `tests/ci/validators.test.js` or related catalog validation tests.
4. Update `AGENTS.md`, `README.md`, and/or `WORKING-CONTEXT.md`.
5. Optionally, update localization docs.

---

### Add or Update Hooks and Hook Scripts
**Trigger:** When adding, fixing, or refactoring hooks for automation or CI/CD  
**Command:** `/add-hook`

1. Edit `hooks/hooks.json` to add or update hook definitions.
2. Create or update scripts in `scripts/hooks/*.js` or `.sh` for hook logic.
3. Update or add tests for hook behavior in `tests/hooks/*.test.js`.
4. Optionally, update related documentation.

---

### Dependency Bump via Dependabot
**Trigger:** When Dependabot detects an outdated dependency  
**Command:** `/bump-dependency`

1. Update dependency version in `package.json`, `yarn.lock`, or workflow YAML.
2. Commit with a standardized message and changelog links.
3. Optionally, update `.github/dependabot.yml` for grouping or schedule.

---

### Add or Update Skill Rules or Examples
**Trigger:** When enhancing a skill with new rules or usage examples  
**Command:** `/add-skill-rule`

1. Create or update `rules/*.md` or `rules/*.tsx` in `skills/<skill-name>/rules/`.
2. Update `SKILL.md` for the skill if needed.
3. Optionally, update `examples/<skill-name>/README.md`.

---

### Documentation Sync or Update
**Trigger:** When updating documentation to reflect codebase changes  
**Command:** `/sync-docs`

1. Edit `README.md`, `AGENTS.md`, or `the-shortform-guide.md`.
2. Edit or create `WORKING-CONTEXT.md`.
3. Update `docs/zh-CN/*.md` for localization.
4. Edit `.claude-plugin/README.md` or `.codex-plugin/README.md` for plugin docs.

---

## Testing Patterns

- **Test File Pattern:** All test files use the `*.test.js` naming convention.
- **Framework:** Not explicitly specified; likely using Jest, Mocha, or similar.
- **Location:** Tests are placed alongside related code or in `tests/` directories.
- **Example:**
  ```js
  // skills/mySkill/rules/myRule.test.js
  describe('myRule', () => {
    it('should behave as expected', () => {
      // test logic here
    });
  });
  ```

---

## Commands

| Command           | Purpose                                                        |
|-------------------|----------------------------------------------------------------|
| /add-skill        | Add a new skill or agent, including documentation and catalog  |
| /add-command      | Add or update a command workflow                               |
| /add-install-target | Add support for a new install target or integration          |
| /sync-catalogs    | Synchronize catalogs and manifests after changes               |
| /add-hook         | Add or update a hook and its scripts                           |
| /bump-dependency  | Bump dependencies via Dependabot                               |
| /add-skill-rule   | Add or update rules/examples for a skill                       |
| /sync-docs        | Synchronize or update documentation                            |
```
