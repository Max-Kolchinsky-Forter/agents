# Research Decision Record: Anthropic Feature-Dev Plugin

| Field        | Value                                                                               |
| ------------ | ----------------------------------------------------------------------------------- |
| **Source**   | https://github.com/anthropics/claude-plugins-official/tree/main/plugins/feature-dev |
| **Reviewed** | 2024-12-28                                                                          |
| **Status**   | Partially Adopted                                                                   |

## Summary

Official Anthropic Claude Code plugin implementing a 7-phase feature development workflow with specialized sub-agents for exploration, architecture, and review. Uses parallel agent execution, multi-approach design, and confidence-filtered reviews.

## Key Concepts

| Concept                       | Description                                                                                       |
| ----------------------------- | ------------------------------------------------------------------------------------------------- |
| 7-Phase Workflow              | Discovery → Exploration → Clarifying Qs → Architecture → Implement → Review → Summary             |
| Parallel Sub-Agents           | Launches 2-3 specialized agents (code-explorer, code-architect, code-reviewer) in specific phases |
| Clarifying Questions Phase    | Explicit phase to resolve ambiguities before design                                               |
| Multiple Architecture Options | Presents minimal, clean, and pragmatic approaches with trade-offs                                 |
| Confidence-Based Filtering    | Only reports high-confidence review issues to reduce noise                                        |
| File List Handoff             | Exploration agents return essential files to read for deeper understanding                        |

## Decision

**Adopted:**

1. Clarifying questions emphasis in Research agent
2. Multiple architecture options with recommendation in Plan agent
3. Confidence-based review filtering in Review agent

**Not Adopted:**

- Parallel sub-agents (not supported in VS Code Copilot)
- `/command` syntax (platform-specific to Claude Code)
- Full 7-phase workflow (existing 4-phase workflow already covers intent)

**Rationale:** These adoptions improve research quality, planning rigor, and review signal without changing architecture. Platform limitations prevent sub-agent orchestration; the existing workflow already aligns with the same intent.

## Comparison to Current Framework

| Feature-Dev Phase      | Current Agent | Enhancement                                 |
| ---------------------- | ------------- | ------------------------------------------- |
| Discovery + Clarifying | Research      | Add explicit clarifying questions           |
| Architecture Design    | Plan          | Present multiple approaches with trade-offs |
| Quality Review         | Review        | Add confidence scoring and filtering        |
