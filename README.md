# Agentic Coding Framework

A curated set of **agents**, **skills**, and **instructions** for AI-assisted coding—synthesized from multiple frameworks into something minimal and actually useful.

## TL;DR

Clone the repo, run `./install.sh`, and get:

- **5 Agents** (Research → Plan → Implement → Review → Commit) with enforced tool access, preferred models, and handoff buttons between phases
- **6 Skills** that auto-activate based on your prompts (debug, tech-debt, architecture, mentor, janitor, critic)
- **5 Instructions** files with coding standards that load automatically based on file type

Works with **VS Code Copilot** and **Claude Code**. Use `/agent` or `/skills` in CLI, or the Chat menu in VS Code.

## Quick Start

```bash
git clone https://github.com/mcouthon/agents.git
cd agents
./install.sh
```

> **Model recommendation:** Claude Opus 4.5 is a game changer for heavy lifting. When Sonnet struggles, Opus delivers.

## Why This Exists

I've been reading up on AI coding frameworks that people have been sharing, and decided to roll several of them into something I'd actually understand and be happy with. The main sources were:

- [12 Factor Agents](./docs/sources/12-factor-agents/)
- [CursorRIPER](./docs/sources/cursorriper/)
- [HumanLayer's ACE Framework](./docs/sources/humanlayer/)
- [Awesome Copilot](./docs/sources/awesome-copilot/)

See [docs/synthesis/prevailing-wisdom.md](./docs/synthesis/prevailing-wisdom.md) for the synthesized principles, or [docs/synthesis/framework-comparison.md](./docs/synthesis/framework-comparison.md) for analysis of the source material.

## Key Insight: Human-in-the-Loop

**The highest leverage point for humans is at the end of research and the beginning of the plan.**

A human can skim 30 seconds and provide a sentence of feedback that could save the agent hours of incorrect implementation. The workflow is designed around this—Research hands off to Plan, and you review before Implement begins.

## The Core Workflow (Custom Agents)

For substantial changes, use the **agent picker dropdown** (or `/agent` in CLI) to select workflow phases:

```
Research → Plan → Implement → Review → Commit
                      ↑          ↓
                      └─(fix)────┘ (max 3 iterations)
```

| Agent       | Purpose                       | Tool Access | Handoff To                                      |
| ----------- | ----------------------------- | ----------- | ----------------------------------------------- |
| `Research`  | Deep codebase exploration     | Read-only   | → Plan                                          |
| `Plan`      | Create implementation plans   | Read-only   | → Implement                                     |
| `Implement` | Execute planned changes       | Full access | → Review                                        |
| `Review`    | Verify implementation quality | Read + Test | → Commit (pass) / Implement (fix) / Plan (fail) |
| `Commit`    | Create semantic commits       | Git + Read  | ✅ Done                                         |

**Why agents?** Each phase has **enforced tool restrictions** (Plan can't accidentally edit code) and **handoff buttons** to guide you to the next step.

## Utility Skills (Auto-Activate)

Skills provide particular capabilities without needing a full agent—they serve a narrow purpose. Use `/skills` in CLI, or trust VS Code to call them automatically based on your prompts:

| You Say                     | Skill Activated |
| --------------------------- | --------------- |
| "This test is failing"      | `debug`         |
| "Find code smells"          | `tech-debt`     |
| "Document the architecture" | `architecture`  |
| "Teach me how this works"   | `mentor`        |
| "Clean up dead code"        | `janitor`       |
| "Challenge my approach"     | `critic`        |

No manual switching required for skills—just ask naturally.

## Available Skills

| Skill          | Purpose                         |
| -------------- | ------------------------------- |
| `debug`        | Systematic bug investigation    |
| `tech-debt`    | Find and fix technical debt     |
| `architecture` | High-level design documentation |
| `mentor`       | Teaching through questions      |
| `janitor`      | Cleanup and simplification      |
| `critic`       | Challenge assumptions           |

## Code Protection Markers

Use these advisory markers in code comments. Skills will respect them:

```python
# [P] Protected - never modify without approval
# [G] Guarded - ask before modifying
# [D] Debug - remove before merge
```

## Instructions (File-Type Standards)

These are minimal files meant to always be part of the context—common ground rules and recommendations (e.g., what to do if the agent is stuck). They load automatically based on file patterns.

| File                       | Applies To       | Purpose                           |
| -------------------------- | ---------------- | --------------------------------- |
| global.instructions.md     | All files        | Core principles, inviolable rules |
| terminal.instructions.md   | All files        | Shell/CLI patterns                |
| python.instructions.md     | `*.py`           | Python coding standards           |
| typescript.instructions.md | `*.ts, *.tsx`    | TypeScript/React standards        |
| testing.instructions.md    | `*test*, *spec*` | Testing philosophy and patterns   |

## Testing

Validate structure:

```bash
./tests/validate-skills.sh   # Validates agents and skills
```

Test install/uninstall:

```bash
./tests/test-install.sh
```

Manual test scenarios: `tests/scenarios/skill-activation.md`

## Installation Targets

After running `./install.sh`:

| Component            | Installed To                                          |
| -------------------- | ----------------------------------------------------- |
| Agents (VS Code)     | `~/Library/Application Support/Code/User/prompts/`    |
| Agents (Claude Code) | `~/.claude/agents/`                                   |
| Skills               | `~/.github/skills/` (with `~/.claude/skills` symlink) |
| Instructions         | `~/Library/Application Support/Code/User/prompts/`    |

## File Structure

```
.github/
├── agents/               # Custom agents (select from dropdown)
│   ├── research.agent.md
│   ├── plan.agent.md
│   ├── implement.agent.md
│   └── review.agent.md
└── skills/               # Agent skills (auto-activate)
    ├── debug/
    ├── tech-debt/
    ├── architecture/
    ├── mentor/
    ├── janitor/
    └── critic/

instructions/             # File-type coding standards (see above to enable)
├── global.instructions.md
├── python.instructions.md
├── typescript.instructions.md
├── testing.instructions.md
└── terminal.instructions.md

tests/                    # Validation and testing
├── validate-skills.sh
├── test-install.sh
└── scenarios/

docs/
├── synthesis/            # Framework design principles
│   ├── prevailing-wisdom.md
│   └── framework-comparison.md
├── sources/              # Reference materials used to build this
└── meta/                 # Historical build prompts
```

## Adding Your Own

### Custom Agent

Create a new agent file:

```
.github/agents/my-agent.agent.md
```

With this structure:

```yaml
---
name: My Agent
description: What this agent does and when to use it.
tools: ["codebase", "search", "editFiles"] # Available tools
model: Claude Sonnet 4 # Optional: specific model
handoffs: # Optional: workflow transitions
  - label: Next Step
    agent: other-agent
    prompt: Continue with the next phase.
    send: false
---
# My Agent Instructions

Your detailed instructions here.
```

Run `./install.sh` to create symlinks.

### Agent Skill

Create a new skill directory:

```
.github/skills/my-skill/
└── SKILL.md
```

With this structure:

```yaml
---
name: my-skill
description: >
  What this skill does. Include trigger keywords for auto-activation.
  Triggers: "keyword1", "keyword2", "when to use this".
---
# My Skill Instructions

Your detailed instructions here (< 500 lines recommended).
```

Run `./install.sh` to create symlinks.

## Agents vs Skills: When to Use Which

| Use Case                           | Use       |
| ---------------------------------- | --------- |
| Need enforced tool restrictions    | **Agent** |
| Need handoffs between phases       | **Agent** |
| Want auto-activation from prompts  | **Skill** |
| Cross-platform (CLI, coding agent) | **Skill** |
| Role-based workflow phases         | **Agent** |
| Specialized methodologies          | **Skill** |

## Troubleshooting

**Skills not auto-activating:**

1. Run `./install.sh` to ensure symlinks exist
2. Check `~/.github/skills/` for your skills
3. Be more explicit: "Use research mode to explore..."

**Need to uninstall:**

```bash
./install.sh uninstall  # Remove all global symlinks
```

## Further Reading

- **[docs/synthesis/prevailing-wisdom.md](./docs/synthesis/prevailing-wisdom.md)** - Core principles and design patterns
- **[docs/synthesis/framework-comparison.md](./docs/synthesis/framework-comparison.md)** - Analysis of source frameworks
- **[docs/sources/12-factor-agents/](./docs/sources/12-factor-agents/)** - 12 Factor Agents principles
