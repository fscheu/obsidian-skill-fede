# obsidian-skill-fede

OpenClaw skill to interact with Obsidian vaults using our custom notesmd-cli fork.

This skill invokes `notesmd-cli` (our fork of NotesMD CLI) to operate on a local Obsidian vault without requiring the Obsidian desktop app.

## Features
- List notes and folders
- Search notes and note content (fuzzy)
- Create, read, update, delete notes
- Manage YAML frontmatter
- Create notes from templates using notesmd-cli template processing

## Requirements
- `notesmd-cli` must be installed and available in PATH (use the fork at https://github.com/fscheu/notesmd-cli or install from releases).

## Configuration: vaultPath
This skill supports a skill-level configuration field `vaultPath` (filesystem path to the Obsidian vault). The skill resolves which vault to use with this priority:

1) Explicit `--vault` parameter passed to the command
2) Skill config `vaultPath` (set in SKILL.md or via OpenClaw skill configuration)
3) notesmd-cli default (set via `notesmd-cli set-default`)

To configure `vaultPath` locally, edit `SKILL.md` and set the `metadata.openclaw.config.vaultPath` value, or use your OpenClaw skill configuration UI if available.

Example (set in SKILL.md):

```yaml
metadata:
  {
    "openclaw":
      {
        "config": {
          "vaultPath": "/home/azureuser/obsidian-vault"
        }
      }
  }
```

## Example usage (internal commands invoked by the skill)

- List vault root (skill will prefer configured vaultPath if set):

```
notesmd-cli list --vault "{vault-name}"
```

- Search notes:

```
notesmd-cli search "topic" --vault "{vault-name}"
```

- Create note from template (example flow):

```
notesmd-cli create "notes/{{slug}}.md" --content "{{rendered_template}}" --vault "{vault-name}"
```

## Installation (development)
Clone this repo and edit files locally. The skill expects `notesmd-cli` to be available in PATH. To test:

```bash
# ensure notesmd-cli (your fork) is installed or on PATH
notesmd-cli --version

# run notesmd-cli directly against a test vault
notesmd-cli list --vault /home/azureuser/obs-vault-test
```

## Contributing
Fork the repository, make changes, and open a pull request. If a change is generic and useful, consider contributing it back to the main notesmd-cli upstream.

## License
MIT
