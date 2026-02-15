---
name: obsidian-skill-fede
description: OpenClaw skill to interact with Obsidian vaults using our custom notesmd-cli fork.
metadata:
  {
    "openclaw":
      {
        "requires": { "bins": ["notesmd-cli"] },
        "install":
          [
            {
              "id": "node",
              "kind": "command",
              "command": "notesmd-cli",
              "label": "Requires notesmd-cli in PATH",
            }
          ],
      },
  }
---

# Obsidian Skill (obsidian-skill-fede)

This skill provides read/search/write/edit capabilities for Obsidian vaults by invoking our fork of notesmd-cli. It operates directly on the vault folder and does not require the Obsidian desktop application to be installed.

Features
- List notes and folders
- Search notes and note content (fuzzy)
- Create, read, update, delete notes
- Manage frontmatter fields
- Support for templates via the notesmd-cli template processing extension

Usage
- Ensure notesmd-cli (our fork) is installed and available on PATH.
- Configure default vault using notesmd-cli set-default "{vault-name}" or pass --vault to commands.

Example invocations (internally the skill runs notesmd-cli commands):

- List vault root
  notesmd-cli list --vault "{vault-name}"

- Search notes
  notesmd-cli search "topic" --vault "{vault-name}"

- Create note from template
  notesmd-cli create "notes/{{slug}}.md" --content "{{rendered_template}}" --vault "{vault-name}"

Configuration
- SKILL.md metadata indicates the external binary requirement (notesmd-cli).
- You can point this skill to a local notesmd-cli binary or install from GitHub releases.

License: MIT
