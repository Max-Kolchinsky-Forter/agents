# Cross-Agent Instructions

Instructions that apply to all AI agents working in this repository.

## Code Protection Markers

Respect these advisory markers in code comments:

| Marker | Meaning                                            |
| ------ | -------------------------------------------------- |
| `[P]`  | Protected - Never modify without explicit approval |
| `[G]`  | Guarded - Requires human review before changes     |
| `[D]`  | Debug - Temporary code, remove before merge        |

## Repository Structure

This is an agentic coding framework. Key locations:

| Path              | Contents                                                                          |
| ----------------- | --------------------------------------------------------------------------------- |
| `.github/agents/` | Custom agent definitions (Research, Plan, Implement, Review)                      |
| `.github/skills/` | Agent skill definitions (debug, tech-debt, architecture, mentor, janitor, critic) |
| `instructions/`   | File-type coding standards                                                        |
| `docs/sources/`   | Reference materials from external frameworks                                      |
| `docs/synthesis/` | Framework design principles and analysis                                          |

## Conventions

- Follow existing patterns in the codebase
- Run `./install.sh` after modifying agents or skills
- See [README.md](README.md) for full documentation and usage instructions
