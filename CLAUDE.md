# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is the **Agentic Coding Framework** - a curated set of agents, skills, and instructions for AI-assisted coding. It synthesizes patterns from multiple frameworks (12 Factor Agents, CursorRIPER, HumanLayer ACE, Awesome Copilot) into a minimal, practical system.

**Key Design Principle**: Human-in-the-loop at leverage points. The highest value review happens at the end of research and beginning of planning—not after implementation.

## Commands

### Installation & Setup

```bash
# Install agents, skills, and instructions globally
./install.sh

# Uninstall (removes symlinks only)
./install.sh uninstall

# Validate agents and skills structure
./tests/validate-skills.sh

# Test install/uninstall process
./tests/test-install.sh
```

### Development Workflow

This is a documentation/configuration-only repository with no build, test, or lint commands. Changes are primarily markdown files defining agent behaviors and coding standards.

## Architecture

### Three-Layer System

The framework operates on three distinct layers:

1. **Agents** (`.github/agents/*.agent.md`) - Workflow phases with enforced tool restrictions
2. **Skills** (`.github/skills/*/SKILL.md`) - Auto-activated specialized capabilities
3. **Instructions** (`instructions/*.instructions.md`) - File-type coding standards

### Agent Workflow (Phase-Based)

Agents form a linear workflow with explicit handoffs:

```
Research → Plan → Implement → Review → Commit
              ↑       ↓
              └─(fix)─┘ (max 3 iterations)
```

**Tool Restrictions by Agent:**

| Agent | Tools | Purpose |
|-------|-------|---------|
| Research | Read, Glob, Grep, WebFetch | Read-only exploration; no modifications |
| Plan | Read, Glob, Grep, WebFetch | Create implementation plans; no code changes |
| Implement | Bash, Read, Write, Edit, Glob, Grep, WebFetch | Full access for executing plans |
| Review | Read, Glob, Grep, Bash | Verify quality; read + test only |
| Commit | Read, Glob, Grep, Bash | Create semantic commits |

**Critical Pattern**: Each agent has `handoffs` in frontmatter pointing to the next phase, with `send: false` to pause for human review.

### Skills (Auto-Activation)

Skills are narrow-purpose capabilities that activate based on user prompts. They differ from agents in two key ways:

1. **No tool restrictions** - Skills use whatever tools are available
2. **Auto-activation** - Triggered by keywords in `description` frontmatter

Available skills:
- `debug` - Systematic bug investigation
- `tech-debt` - Find and fix technical debt
- `architecture` - High-level design documentation
- `mentor` - Teaching through questions
- `janitor` - Cleanup and simplification
- `critic` - Challenge assumptions

**Skill Namespacing**: Personal skills at `~/.github/skills/` override framework skills with the same name.

### Instructions (File-Type Standards)

Instructions are minimal coding standards that load automatically based on file patterns via `applyTo` frontmatter field:

- `global.instructions.md` - Core principles (applies to all files)
- `python.instructions.md` - Python standards (`*.py`)
- `typescript.instructions.md` - TypeScript/React standards (`*.ts`, `*.tsx`)
- `testing.instructions.md` - Testing philosophy (`*test*`, `*spec*`)
- `terminal.instructions.md` - Shell/CLI patterns (all files)

### Installation Architecture

The `install.sh` script creates symlinks (not copies) to enable:

1. **Global availability** - Skills work across all projects
2. **Single source of truth** - Edit in this repo, changes apply everywhere
3. **Cross-platform support** - Both VS Code Copilot and Claude Code

**Symlink structure:**

```
~/.github/skills/          → .github/skills/* (framework skills)
~/.claude/skills/          → ~/.github/skills/ (compatibility symlink)
~/Library/.../Code/User/prompts/*.agent.md → .github/agents/*
~/.claude/agents/*.agent.md → .github/agents/*
```

## File Structure Semantics

### Agent Files (`.agent.md`)

Frontmatter defines behavior:

```yaml
---
name: Research                    # Display name
description: When to use this     # Selection guidance
tools: ["Read", "Glob", "Grep"]   # Enforced tool access
model: Claude Opus 4.5            # Optional model preference
handoffs:                         # Workflow transitions
  - label: Create Plan
    agent: Plan
    prompt: Based on research, create plan.
    send: false                   # Pause for human review
---
```

**Tool enforcement**: The `tools` array restricts what operations an agent can perform, preventing Plan from accidentally editing code or Research from modifying files.

### Skill Files (`SKILL.md`)

```yaml
---
name: debug                       # Skill identifier (must match directory)
description: >
  Use when tests fail, bugs occur, errors appear.
  Keywords: "failing test", "error", "bug", "crash"
  Focus on WHEN to use (symptoms), not WHAT it does.
---
```

**Auto-activation**: The `description` field is critical—it's analyzed to determine when to trigger the skill. Include symptoms and keywords, not implementation details.

### Instruction Files (`.instructions.md`)

```yaml
---
applyTo: "**/*.py"               # Glob pattern for file matching
---
```

**Hierarchy**: `global.instructions.md` always applies; file-specific instructions layer on top.

## Code Protection Markers

These are **advisory conventions** respected by skills (not programmatically enforced):

```python
# [P] Protected - never modify without approval
# [G] Guarded - ask before modifying
# [D] Debug - remove before merge
```

## Adding New Components

### New Agent

1. Create `.github/agents/my-agent.agent.md` with proper frontmatter
2. Run `./install.sh` to create symlinks
3. Agent appears in dropdown/menu immediately

### New Skill

1. Create `.github/skills/my-skill/SKILL.md` with frontmatter
2. Ensure `description` includes trigger keywords and symptoms
3. Run `./install.sh` to create symlinks
4. **Validate before deploying**: Run a task WITHOUT the skill (note failures), then WITH the skill (verify improvement)

### New Instruction

1. Create `instructions/my-file-type.instructions.md` with `applyTo` pattern
2. Run `./install.sh` to create symlinks

## Key Design Patterns

### Context Engineering

From synthesized wisdom (`docs/synthesis/prevailing-wisdom.md`):

- Keep context at 40-60% capacity
- Use structured formats (XML/custom) over raw message arrays
- Unify execution + business state in single source of truth
- Compact errors into context (limit 2-3 retries)

### Phase-Based Workflow

**Permission Boundaries** prevent common mistakes:

- Research can't accidentally modify code (no Edit/Write tools)
- Plan can't skip research (read-only tools enforce analysis first)
- Implement can't skip planning (workflow enforced via handoffs)

### Focused Agents Over Monolithic Ones

From 12-Factor Agents: "The magic number is probably 3-20 tool calls." Each agent should have a single, clear purpose with minimal tool access.

## Reference Documentation

- `docs/synthesis/prevailing-wisdom.md` - Core principles from analyzed frameworks
- `docs/synthesis/framework-comparison.md` - Analysis of source frameworks
- `docs/sources/` - Original reference materials from external frameworks
- `AGENTS.md` - Cross-agent instructions (applies to all AI agents in workspace)
- `README.md` - User-facing documentation and usage guide

## Important Conventions

1. **Agents are workflows** (select from dropdown) with tool restrictions and handoffs
2. **Skills are capabilities** (auto-activate from prompts) without tool restrictions
3. **Instructions are standards** (auto-load by file type) for coding practices
4. **Symlinks enable global use** while maintaining single source in this repo
5. **Human review at phase boundaries** is the core value proposition

## When Working in This Repository

- **Modifying agents**: Adjust tool access and handoffs carefully—these define the workflow
- **Modifying skills**: Update `description` to refine auto-activation triggers
- **Validating changes**: Run `./tests/validate-skills.sh` before committing
- **Testing install**: Run `./tests/test-install.sh` to verify symlink behavior
- **New components**: Always run `./install.sh` after adding agents/skills/instructions
