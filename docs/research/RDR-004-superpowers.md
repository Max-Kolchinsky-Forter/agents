# Research Decision Record: Superpowers

| Field        | Value                                        |
| ------------ | -------------------------------------------- |
| **Source**   | https://github.com/obra/superpowers          |
| **Reviewed** | 2025-12-29                                   |
| **Status**   | Partially Adopted - Ideas for Future Updates |

## Summary

Superpowers is a comprehensive skills-based development workflow framework for AI coding agents, built on a composable library of ~15 "skills" that enforce Test-Driven Development, systematic debugging, and spec-driven development. It features auto-activating skills, mandatory workflows (brainstorming → planning → implementation → review), and TDD-inspired skill creation methodology where skills themselves are tested using pressure scenarios before deployment.

## Key Concepts

| Concept                            | Description                                                                                                                                          |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Skills as TDD**                  | Skills are tested using "pressure scenarios" with subagents - watch agent fail without skill (RED), write skill (GREEN), close loopholes (REFACTOR)  |
| **Mandatory Workflows**            | Skills are not suggestions - if relevant skill exists, agent MUST use it. Enforced through emphatic instructions and skill descriptions              |
| **Auto-Activation**                | Rich YAML descriptions with trigger keywords enable automatic skill discovery and loading based on task context                                      |
| **Subagent-Driven Dev**            | Dispatch fresh subagent per implementation task with two-stage review (spec compliance, then code quality) for fast iteration                        |
| **Skill Namespace**                | Personal skills (`~/.claude/skills/`) override superpowers skills, enabling local customization                                                      |
| **Progressive Disclosure**         | SKILL.md for core content (<500 lines), separate files for heavy reference, inline code for patterns                                                 |
| **Claude Search Optimization**     | YAML `description` field optimized for discovery - triggers/symptoms only, NOT workflow summary (prevents agent from following description vs skill) |
| **Brainstorming Skill**            | Forces design-before-coding through Socratic questioning, writes design docs before implementation                                                   |
| **Testing Anti-Patterns**          | Reference material documenting common testing failures (over-mocking, test-after-code) included in TDD skill                                         |
| **Verification-Before-Completion** | Skill that prevents "works on my machine" - requires evidence that bugs are actually fixed                                                           |

## Decision

**Adopted:**

1. **TDD-Based Skill Testing** - Add to writing-skills guidelines: skills should be validated with test scenarios before deployment
2. **Rich Skill Descriptions** - Enhance skill description guidance to include concrete trigger keywords for better discovery
3. **Skill Namespace Concept** - Document that personal/local skills can override framework skills
4. **Progressive Disclosure Pattern** - Codify <500 line guidance for main skill files, separate heavy reference
5. **Testing Anti-Patterns Reference** - Consider adding common pitfalls documentation to testing.instructions.md

**Not Adopted (Current State):**

- Mandatory workflow enforcement (too prescriptive for our "advisory" philosophy)
- Subagent-driven development (platform-specific, requires tool support)
- Git worktrees workflow (opinionated, not universally applicable)
- Emphatic/forceful tone in instructions (conflicts with our minimal approach)
- Command system (`/superpowers:brainstorm`, etc.) - we use agent modes instead

**Rationale:**

Superpowers has excellent ideas around **skill quality** (TDD testing, rich descriptions, progressive disclosure) that enhance our framework without adding complexity. However, its **mandatory workflows** and **prescriptive tone** conflict with our philosophy of minimal, advisory guidance that respects developer choice.

The skill testing methodology is particularly valuable - using pressure scenarios with subagents to validate that skills actually prevent common failures. This is like unit testing for documentation.

The framework is heavily optimized for Claude Code with specific tool integrations (Task tool, TodoWrite, subagents) that don't translate to our VS Code/Claude Code hybrid approach. We focus on IDE-agnostic patterns.

## Comparison to Current Framework

**Similarities:**

- Both use phase-based workflows (Research/Plan/Implement vs Brainstorming/Planning/Implementation)
- Both emphasize Test-Driven Development
- Both use YAML frontmatter for skill/agent metadata
- Both support custom skill/agent creation
- Both value context management

**Key Differences:**

| Aspect                 | Our Framework                       | Superpowers                                  |
| ---------------------- | ----------------------------------- | -------------------------------------------- |
| **Tone**               | Advisory, minimal                   | Mandatory, emphatic ("YOU MUST")             |
| **Enforcement**        | Tool restrictions in agent modes    | Social pressure + repeated emphasis          |
| **Platform**           | VS Code + Claude Code hybrid        | Claude Code optimized                        |
| **Skill Activation**   | Manual with `/skills` or natural    | Auto-activation with emphatic instructions   |
| **Workflow Structure** | 5 agents (Research→Plan→...→Commit) | Skills-based with commands                   |
| **Documentation**      | Synthesis from multiple frameworks  | Single cohesive system                       |
| **Philosophy**         | Own your prompts and control flow   | Follow proven workflows                      |
| **Testing Skills**     | Not formalized                      | TDD methodology with pressure scenario tests |

**Notable Overlap:**
Both frameworks recognize that **skills need structure** (YAML frontmatter, clear descriptions) and that **phase-based workflows** prevent jumping straight to code. Superpowers goes further with skill quality assurance through testing.

**Potential Enhancements:**

1. **Add skill testing guidance** - Document how to validate skills work (simplified version of their pressure scenario approach)
2. **Enhance skill descriptions** - Add examples of rich, keyword-laden descriptions that enable better discovery
3. **Document skill organization** - Adopt their progressive disclosure pattern (main file <500 lines, separate reference files)
4. **Testing anti-patterns** - Consider adding a reference section in testing.instructions.md with common pitfalls
5. **Verification checklist** - Inspired by their verification-before-completion skill, add completion criteria to agent modes

## Notes

- **12.4k GitHub stars** - This is a widely-adopted, battle-tested framework
- Jesse Vincent (obra) is extremely responsive to feedback and iterates based on real-world usage
- The writing-skills skill is meta-documentation on how to write skills - excellent reference
- Anthropic best practices are integrated directly into the framework
- Heavy focus on preventing the "I thought I fixed it" problem through verification requirements
- The "Iron Law" of no skill without failing test is hardcore but effective for quality
