# cl-plugin-structure

A Claude Code & Cowork plugin documenting how to build plugins, skills, slash commands, hooks, MCP servers, and channels — plus the **Folder Architecture: Routing-Table Pattern** (CLAUDE.md → workspace rooms → on-demand skills) and the full token-optimization research baseline.

## Install (Cowork)

Open the **Customize** menu → **Plugins** → **Add marketplace** → paste:

```
https://github.com/TheDigitalGriot/cl-plugin-structure
```

Cowork will read `.claude-plugin/marketplace.json` and offer the `cl-plugin-structure` plugin for install.

## Install (Claude Code CLI)

```bash
claude plugin marketplace add https://github.com/TheDigitalGriot/cl-plugin-structure
claude plugin install cl-plugin-structure --scope user
```

## What's inside

A single comprehensive skill (`skills/cl-plugin-structure/`) that fires whenever you mention building a plugin, a skill, a slash command, a hook, an MCP server, a marketplace, or ask about plugin.json/SKILL.md structure. Bundled references:

- **SKILL.md** — the manifest + component matrix + frontmatter rules + portable paths + dev workflow
- **references/folder-architecture-routing.md** — the routing-table pattern, four-leaks audit, naming conventions
- **references/token-optimization-research.md** — context-rot, autoresearch, Attention Residuals, progressive disclosure, observational memory, compaction survival, MCP token patterns, plugin audit checklist
- **references/component-patterns.md, hook-events.md, mcp-patterns.md, channel-patterns.md, command-patterns.md, cowork-compatibility.md, manifest-reference.md, settings-local-md.md** — per-component deep dives
- **examples/** — minimal, standard, and advanced plugin examples
- **scripts/** — validators for hooks, frontmatter, agent specs, settings

## Surface compatibility

Skills + MCP servers work on both Claude Code and Cowork. Hooks, LSP, output-styles, bin/, and slash commands are Claude Code-only. See `skills/cl-plugin-structure/references/cowork-compatibility.md` for the per-component matrix.

## Validation

After modifying any plugin component, run:

```bash
claude plugin validate .
```

Schema validation is authoritative for both Claude Code and Cowork.

## Version

`0.7.0` — adds the Folder Architecture routing-table pattern (framing adapted from Clief Sundberg's Quantum Quill Lyceum, Section 3).

## License

MIT
