---
name: obsidian-skill-fede
description: OpenClaw skill to interact with Obsidian vaults using our custom notesmd-cli fork.
metadata:
  openclaw:
    requires:
      bins: [notesmd-cli]
    config:
      vaultPath:
        type: string
        description: >-
          Filesystem path to the Obsidian vault used by this skill. If unset,
          commands should accept --vault or use notesmd-cli set-default.
        default: ""
    install:
      - id: node
        kind: command
        command: notesmd-cli
        label: Requires notesmd-cli in PATH
---

# Obsidian Skill (obsidian-skill-fede)

This skill provides read/search/write/edit capabilities for Obsidian vaults by invoking our fork of `notesmd-cli`.

It is **vault-aware**: when operating inside a structured vault (e.g. Claudesidian / PARA / BASB), the skill must respect the vault’s own directives and conventions.

## Features

- List notes and folders
- Search notes and note content (fuzzy)
- Create, read, update, delete notes
- Manage YAML frontmatter fields
- Support for templates via the notesmd-cli template processing extension

## Vault selection

How the skill resolves which vault to use (priority order):

1) Explicit `--vault` parameter passed to the command
2) Skill config `vaultPath` (if non-empty)
3) `notesmd-cli` default (set via `notesmd-cli set-default`)

## Vault-awareness: Claudesidian / PARA / BASB conventions (Fede)

When the vault contains these files, treat them as *operational directives*:

- `CLAUDE.md` (**source of truth**) — vault guidelines
- `AGENTS.md` — legacy/secondary guidelines (read, but prefer `CLAUDE.md` if conflicting)

Additionally, prefer *machine-readable* configuration when present:

- TaskNotes plugin config: `.obsidian/plugins/tasknotes/data.json`

### Canonical structure (PARA)

Prefer these canonical folders when creating/moving new content:

- `00_Inbox/`
- `01_Projects/`
- `02_Areas/`
- `03_Resources/`
- `04_Archive/`
- `05_Attachments/`
- `06_Metadata/`

Treat these as **legacy** (read/search OK, but do not write new content there unless explicitly requested):

- `Inbox/` (old inbox to be migrated)
- `03 - Resources/` (legacy resources path)

### Frontmatter and review workflow

If the vault directives require it (Fede’s default): when you **create or modify any markdown note** in the vault, enforce:

- Update/add `modified: YYYY-MM-DD`
- Set `leido: false`
- If missing frontmatter: add a minimal frontmatter block appropriate to the note type

Do not over-invent schemas: prefer existing vault templates and conventions.

### Git / version control

If the vault uses Obsidian Git automation: **do not commit** unless explicitly instructed by Fede.

## Task management: TaskNotes (Obsidian) vs Beads (dev repos)

This vault uses the **TaskNotes** plugin (file-per-task). The skill should prefer TaskNotes for personal/project/action tasks **inside the vault**, except when the user is clearly working inside a **software repository** where tasks are tracked via **Beads**.

Decision rule of thumb:

- Task is about *vault / life / projects / areas* → create/update a **TaskNotes task file**
- Task is about *implementing code changes in a specific repo* → track via **Beads** (not TaskNotes)

### TaskNotes rules (agent-critical)

- Do **not** create tasks as plain checkboxes in regular notes.
- Prefer reading `.obsidian/plugins/tasknotes/data.json` to discover:
  - canonical `tasksFolder`
  - legacy `inlineTaskConvertFolder`
  - default statuses/priorities
- When creating a task:
  - create it in `tasksFolder`
  - set `status: pending` by default
  - set `tags: [task]`
  - include `dateCreated` + `dateModified` timestamps (ISO)
  - include `leido: false`
- Never delete or move task files unless explicitly instructed.
- Never create recurring tasks unless explicitly instructed (plugin-managed complexity).

## Inbox processing (stage 1)

Primary goal: help organize and make interaction with the vault “smart”, respecting PARA.

- Prefer scanning/processing `00_Inbox/`.
- Treat `Inbox/` as legacy input; avoid writing there.
- When a note clearly represents an actionable item:
  - create a TaskNotes task (intelligently) without requiring an explicit “create task” phrase
  - *unless* the context is a software repo task → use Beads instead

## Link capture & transcription (stage 2 – planned)

Planned future flows (not mandatory for stage 1):

- Web URLs → capture via `web_fetch` (or vault scripts if configured)
- YouTube → transcript extraction/summarization via dedicated OpenClaw skills
- Instagram → via dedicated OpenClaw skills
- X/Twitter → TBD (likely separate skill or best-effort capture)

## Notesmd-cli usage (examples)

- List vault root:
  - `notesmd-cli list --vault "{vault}"`

- Search notes:
  - `notesmd-cli search "topic" --vault "{vault}"`

- Create note:
  - `notesmd-cli create "path/to/note.md" --content "..." --vault "{vault}"`

License: MIT
