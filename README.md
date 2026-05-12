# obsidian-skill-fede

Canonical git-tracked source for Federico Scheu's Obsidian skill.

This repository is the source of truth for the skill code and support files. The intended runtime installation model is symlink-based, so Hermes loads the skill from `~/.hermes/skills/fede/obsidian-skill-fede` while the editable source stays versioned here in git.

Primary source repo:
- `/home/azureuser/projects/obsidian-skill-fede`

Primary runtime target:
- `~/.hermes/skills/fede/obsidian-skill-fede -> /home/azureuser/projects/obsidian-skill-fede`

Optional backward-compatible legacy target:
- `/home/azureuser/repos/agents/openclaw/skills/obsidian-skill-fede -> /home/azureuser/projects/obsidian-skill-fede`

## What this skill does

`obsidian-skill-fede` defines how Hermes should operate on Fede's Obsidian vault.

It is not just a markdown helper. It makes vault work consistent with:
- the vault directives in `CLAUDE.md` and `AGENTS.md`;
- the TaskNotes plugin config in `.obsidian/plugins/tasknotes/data.json`;
- the canonical PARA structure in the vault;
- `notesmd-cli` as the preferred operational interface for note-level actions.

Current vault root on this VM:
- `/home/azureuser/repos/projects/claude-second-brain`

## Repository Layout

```text
obsidian-skill-fede/
├── SKILL.md
├── README.md
├── content-pipeline/
│   ├── config.json
│   └── scripts/
├── references/
│   └── content-pipeline/
├── templates/
│   └── content-pipeline/
└── docs/
```

## Runtime Model

The repo stays editable and tracked in git.

Hermes should consume it through a symlink:

```bash
ln -s /home/azureuser/projects/obsidian-skill-fede \
  /home/azureuser/.hermes/skills/fede/obsidian-skill-fede
```

If the runtime directory already exists and is not a symlink, move it aside first after confirming every important file was migrated into the repo.

Important: Hermes skill discovery is session-cached. After changing the runtime path or major skill contents, validate from a fresh Hermes session rather than trusting the current session cache.

## Tooling Requirements

Validated on this VM:
- `notesmd-cli` in PATH
- `hermes` CLI in PATH
- vault exists at `/home/azureuser/repos/projects/claude-second-brain`
- TaskNotes config exists at `.obsidian/plugins/tasknotes/data.json`

Useful checks:

```bash
notesmd-cli --version
hermes curator status
python3 - <<'PY'
import os
for p in [
    '/home/azureuser/repos/projects/claude-second-brain',
    '/home/azureuser/repos/projects/claude-second-brain/CLAUDE.md',
    '/home/azureuser/repos/projects/claude-second-brain/AGENTS.md',
    '/home/azureuser/repos/projects/claude-second-brain/.obsidian/plugins/tasknotes/data.json',
    '/home/azureuser/repos/projects/claude-second-brain/03_Resources/TaskNotes/Tasks',
]:
    print(('OK' if os.path.exists(p) else 'MISS'), p)
PY
```

## Validation Commands

### 1. Validate SKILL.md frontmatter parses

```bash
python3 - <<'PY'
import pathlib, re, yaml
p = pathlib.Path('/home/azureuser/projects/obsidian-skill-fede/SKILL.md')
content = p.read_text()
assert content.startswith('---')
m = re.search(r'\n---\s*\n', content[3:])
assert m, 'missing closing frontmatter'
fm = yaml.safe_load(content[3:m.start()+3])
assert fm['name'] == 'obsidian-skill-fede'
assert 'description' in fm
print('frontmatter ok')
PY
```

### 2. Validate runtime path resolves to the repo

```bash
python3 - <<'PY'
import os
p = '/home/azureuser/.hermes/skills/fede/obsidian-skill-fede'
print('exists:', os.path.exists(p))
print('islink:', os.path.islink(p))
print('realpath:', os.path.realpath(p))
PY
```

### 3. Validate the skill from a fresh Hermes session

```bash
hermes -z "load skill obsidian-skill-fede and tell me its purpose" --ignore-rules
```

Or, from a normal fresh session, use the skill loader path and confirm `skill_view(name='obsidian-skill-fede')` works.

## Curator Protection

This skill is intended to remain active and should be protected from curator auto-archival once restored.

Pin command:

```bash
hermes curator pin obsidian-skill-fede
```

Check current status:

```bash
hermes curator status
```

If needed later, unpin explicitly:

```bash
hermes curator unpin obsidian-skill-fede
```

## Editing Workflow

Recommended order for substantial changes:
1. edit files in `/home/azureuser/projects/obsidian-skill-fede`;
2. validate repo-local contents;
3. sync/repair the runtime symlink only after the repo contains the full source tree;
4. validate in a fresh Hermes session;
5. keep curator protection enabled.

## Notes

- `CLAUDE.md` is the current source of truth for vault policy; `AGENTS.md` is secondary.
- Canonical TaskNotes folder on this VM is `03_Resources/TaskNotes/Tasks/`.
- Historical paths like `Inbox/` and `03 - Resources/` should not be used as defaults for new content.
- Do not commit/push vault changes unless Fede explicitly asks for git operations on the vault.
