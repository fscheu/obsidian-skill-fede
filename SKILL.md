---
name: obsidian-skill-fede
description: "Use when working with Federico Scheu's Obsidian vault so Hermes follows vault directives, TaskNotes conventions, and notesmd-cli-based workflows instead of ad-hoc file writes."
version: 2.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [obsidian, vault, tasknotes, notesmd-cli, fede, para, content-pipeline]
    related_skills: [pm-agent, fede-ops, content-pipeline]
---

# obsidian-skill-fede

## Overview

This skill is the operational contract for working with Federico Scheu's Obsidian vault at `/home/azureuser/repos/projects/claude-second-brain`.

Its purpose is not just "edit markdown files". Its purpose is to make Hermes behave like a vault-aware operator: respect vault directives, use the TaskNotes plugin conventions, preserve PARA structure, and prefer `notesmd-cli` workflows over improvised raw file edits.

Use this skill whenever Hermes needs to read, search, create, reorganize, or update notes in Fede's vault, or when another skill needs Obsidian behavior as a dependency.

## When to Use

Use this skill when any of these are true:
- the task touches `/home/azureuser/repos/projects/claude-second-brain`;
- you need to create or update a markdown note in the vault;
- you need to create or inspect TaskNotes tasks;
- you need to process inbox items under `00_Inbox/`;
- you need to route captured content into PARA folders;
- you need content-pipeline outputs to land in the vault coherently;
- a PM/documentation workflow depends on current vault conventions.

Do not use this skill for:
- code-repo task tracking via Beads;
- arbitrary raw file writes into the vault when the user did not explicitly authorize bypassing the Obsidian workflow;
- editing unrelated non-vault repos.

## Core Rule

When operating on the vault, do not treat it like a generic filesystem.

Default behavior:
- use `notesmd-cli` for note-level operations where possible;
- read vault directives before writing;
- preserve frontmatter and review signals;
- respect TaskNotes as the persistent task system inside the vault;
- keep PARA folder semantics intact.

If the user explicitly asks to bypass the Obsidian workflow and edit raw files directly, follow that instruction, but treat it as an exception rather than the default mode.

## Canonical Paths

Vault root:
- `/home/azureuser/repos/projects/claude-second-brain`

Directive files:
- `/home/azureuser/repos/projects/claude-second-brain/CLAUDE.md`
- `/home/azureuser/repos/projects/claude-second-brain/AGENTS.md`

Machine-readable task config:
- `/home/azureuser/repos/projects/claude-second-brain/.obsidian/plugins/tasknotes/data.json`

Canonical PARA roots:
- `00_Inbox/`
- `01_Projects/`
- `02_Areas/`
- `03_Resources/`
- `04_Archive/`
- `05_Attachments/`
- `06_Metadata/`

Canonical TaskNotes folder on this VM:
- `03_Resources/TaskNotes/Tasks/`

Historical / legacy paths:
- `Inbox/`
- `03 - Resources/`

Treat legacy paths as historical references only. Read/search is fine if the user explicitly points there, but do not choose them as defaults for new content in the current vault.

## Vault Precedence Rules

When directives compete, use this order:
1. explicit current-user instruction;
2. `CLAUDE.md` in the vault;
3. `AGENTS.md` in the vault;
4. `.obsidian/plugins/tasknotes/data.json` for TaskNotes-specific defaults;
5. this skill.

Practical consequence on this VM:
- `CLAUDE.md` is newer and more complete than `AGENTS.md`;
- if they differ, prefer `CLAUDE.md`;
- use `AGENTS.md` as secondary context, not as the final authority.

## Notesmd-cli Guidance

Validated command surface on this VM (`notesmd-cli v0.3.0`):
- `notesmd-cli list`
- `notesmd-cli search`
- `notesmd-cli search-content`
- `notesmd-cli create`
- `notesmd-cli delete`
- `notesmd-cli move`
- `notesmd-cli frontmatter`
- `notesmd-cli print`
- `notesmd-cli daily`
- `notesmd-cli set-default`

Preferred usage patterns:
- list folders/notes: `notesmd-cli list --vault "<vault>"`
- search note names: `notesmd-cli search "topic" --vault "<vault>"`
- search note content: `notesmd-cli search-content "term" --vault "<vault>"`
- create note: `notesmd-cli create "path/to/note.md" --content "..." --vault "<vault>"`
- inspect/edit frontmatter: `notesmd-cli frontmatter "note" --print|--edit ... --vault "<vault>"`
- move note while updating links: `notesmd-cli move "old" "new" --vault "<vault>"`

Vault selection priority:
1. explicit `--vault` argument;
2. configured default vault in `notesmd-cli`;
3. if needed, resolve from known VM path `/home/azureuser/repos/projects/claude-second-brain`.

## Markdown Metadata Rules

When creating or modifying any markdown note in the vault, current vault policy requires:
- update or add `modified: YYYY-MM-DD` for general notes when that schema is used;
- set `leido: false` on edited/created notes so Fede can review them;
- if frontmatter is missing, add an appropriate minimal frontmatter block instead of leaving the note schema-less.

Minimum generic frontmatter when no better template exists:

```yaml
---
created: YYYY-MM-DD
modified: YYYY-MM-DD
leido: false
tags: []
---
```

Important nuance:
- TaskNotes uses its own schema with fields like `title`, `status`, `priority`, `dateCreated`, `dateModified`, `scheduled`, etc.;
- for TaskNotes, respect the plugin schema first, and still keep `leido: false`.

## TaskNotes vs Beads

This distinction is critical.

Use TaskNotes when:
- the task belongs in Fede's personal/project vault;
- the task must persist beyond the current session;
- the task is for Fede to review or complete later;
- the task should appear in Obsidian's TaskNotes plugin.

Use Beads when:
- the task is implementation work inside a software repository;
- the unit of work belongs to code planning/execution rather than vault planning;
- the repo already uses Beads as the source of truth for engineering tasks.

Rule of thumb:
- vault / life / project-management / follow-up tasks -> TaskNotes
- code changes in a repo -> Beads

## TaskNotes Rules for This Vault

Read `.obsidian/plugins/tasknotes/data.json` when TaskNotes behavior matters.

Current validated values on this VM:
- `tasksFolder`: `03_Resources/TaskNotes/Tasks`
- `inlineTaskConvertFolder`: `03_Resources/TaskNotes/Tasks`
- `defaultTaskPriority`: `normal`
- `defaultTaskStatus`: `pending`
- `taskTag`: `task`
- filename template: timestamp-based custom filenames

When creating a TaskNotes task, prefer this shape:
- `title`
- `status: pending`
- `priority: normal|high|low` as appropriate
- `dateCreated` and `dateModified` in ISO datetime form
- `leido: false`
- `tags:` including `task`
- `contexts: []`
- `projects:` with wiki links when known
- `scheduled:` if there is an explicit day or if the plugin default should apply

Do not:
- create persistent tasks as plain checkboxes in arbitrary notes;
- invent recurring/advanced TaskNotes fields unless needed;
- delete or move TaskNotes files without explicit instruction.

## Inbox and PARA Handling

Primary intake area:
- `00_Inbox/`

Use `00_Inbox/` for capture-first workflows, then route to canonical PARA destinations.

Examples:
- project material -> `01_Projects/`
- continuing responsibility -> `02_Areas/`
- reference material -> `03_Resources/`
- attachments/media -> `05_Attachments/`
- inactive/completed material -> `04_Archive/`

Do not create new permanent content under historical paths like `Inbox/` or `03 - Resources/` unless the user explicitly requests it.

## Git / Version Control Rule

The vault uses Obsidian Git automation.

Default rule:
- do not run git commit/push for the vault unless Fede explicitly asks for git operations.

The skill may edit files; it should not autonomously commit those edits.

## Content-Pipeline Support

This skill is also the Obsidian-side contract for content-pipeline outputs.

Current repo support files live under:
- `references/content-pipeline/`
- `templates/content-pipeline/`
- `content-pipeline/config.json`
- `content-pipeline/scripts/`

Operational guidance:
- use `web_extract` for straightforward static/article extraction;
- use browser fallback for dynamic/live pages when extraction quality matters;
- keep content-pipeline note output aligned with current vault metadata rules;
- treat X/Twitter, Instagram, and YouTube extraction heuristics as content-pipeline concerns, while this skill owns the Obsidian landing behavior and vault conventions.

## Boundaries with Other Skills

- `pm-agent`: owns project-state synthesis, PM decisions, and when vault updates should happen.
- `fede-ops`: captures Fede's general operating preferences and side-effect boundaries.
- `content-pipeline`: owns capture/extraction/classification flow for inbound links/media.
- `obsidian-skill-fede`: owns how vault reads/writes should behave once Obsidian is involved.

## Common Pitfalls

1. Treating `AGENTS.md` as equal to `CLAUDE.md`.
   On this VM, `CLAUDE.md` is newer. Prefer it.

2. Writing directly into the vault without respecting review metadata.
   If you edit markdown, update the appropriate metadata and set `leido: false`.

3. Creating persistent tasks as checklists in random notes.
   Use TaskNotes files in `03_Resources/TaskNotes/Tasks/` instead.

4. Using legacy paths as defaults.
   `Inbox/` and `03 - Resources/` are historical, not the current canonical write targets.

5. Mixing code-repo work with vault task tracking.
   Beads for engineering repos, TaskNotes for vault-managed follow-up.

6. Autocommitting vault changes.
   Obsidian Git is configured; do not commit unless Fede explicitly asks.

7. Assuming any markdown template is acceptable.
   Prefer current vault templates and real plugin config over invented schemas.

## Verification Checklist

- [ ] Vault root exists at `/home/azureuser/repos/projects/claude-second-brain`
- [ ] `CLAUDE.md` and `AGENTS.md` are readable
- [ ] TaskNotes config exists at `.obsidian/plugins/tasknotes/data.json`
- [ ] Canonical TaskNotes folder is `03_Resources/TaskNotes/Tasks/`
- [ ] `notesmd-cli --version` works
- [ ] New content is routed to canonical PARA paths, not legacy ones
- [ ] Markdown edits preserve/update required review metadata
- [ ] Persistent tasks are created as TaskNotes, not plain checkboxes
- [ ] Vault git operations are avoided unless explicitly requested
