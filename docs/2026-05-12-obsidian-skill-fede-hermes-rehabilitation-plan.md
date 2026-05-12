# obsidian-skill-fede Hermes Rehabilitation Plan

> For Hermes: this plan is the working contract to convert the current partially-migrated repo into a functional Hermes skill while preserving git as source of truth and restoring the repo<->runtime symlink pattern.

Goal: leave `obsidian-skill-fede` functional as a real Hermes skill, aligned with the current Obsidian vault directives, with all supporting content-pipeline assets tracked in git from `/home/azureuser/projects/obsidian-skill-fede`.

Architecture:
- Git-tracked source of truth remains `/home/azureuser/projects/obsidian-skill-fede`.
- Hermes runtime path should become a symlink: `~/.hermes/skills/fede/obsidian-skill-fede -> /home/azureuser/projects/obsidian-skill-fede`.
- Legacy OpenClaw symlink may remain if useful, but Hermes is the primary target.
- All content-pipeline support files currently stranded under `~/.hermes/skills/fede/obsidian-skill-fede/` should be migrated into the repo before switching the Hermes path to a symlink.

Tech stack:
- Hermes local user skill format
- `notesmd-cli` v0.3.0
- Obsidian vault at `/home/azureuser/repos/projects/claude-second-brain`
- TaskNotes plugin config at `.obsidian/plugins/tasknotes/data.json`
- Git-tracked markdown/json/bash assets

---

## Current State Summary

Validated state on this VM:
- Source repo exists: `/home/azureuser/projects/obsidian-skill-fede`
- Source repo currently contains only `SKILL.md` and `README.md`
- Hermes runtime directory exists at `~/.hermes/skills/fede/obsidian-skill-fede` but does not contain `SKILL.md`
- Hermes therefore cannot load the skill (`skill_view(name='obsidian-skill-fede')` fails)
- Runtime directory contains 7 useful orphaned assets:
  - `content-pipeline/config.json`
  - `content-pipeline/scripts/transcribe_openai_whisper.sh`
  - `references/content-pipeline/hermes-shadow-validation.md`
  - `references/content-pipeline/x-hermes-fallbacks.md`
  - `templates/content-pipeline/article.md`
  - `templates/content-pipeline/instagram.md`
  - `templates/content-pipeline/project-inbox.md`
- Source `SKILL.md` is directionally good but stale:
  - written as an OpenClaw skill
  - lacks Hermes-style frontmatter and structure
  - references `web_fetch`
  - assumes legacy paths still exist (`Inbox/`, `03 - Resources/`)
- Vault guidance confirms:
  - `CLAUDE.md` is newer and should be source of truth
  - `AGENTS.md` is older and secondary
  - `modified` + `leido: false` are required when editing markdown notes
  - TaskNotes canonical folder is `03_Resources/TaskNotes/Tasks`
  - `04_Archive` is canonical in the vault

---

## Constraints and Decisions

### Keep
- Repo-first workflow with git tracking in `/home/azureuser/projects/obsidian-skill-fede`
- Symlink-based runtime exposure
- `notesmd-cli` as the core filesystem/vault operator
- Vault-aware behavior driven by `CLAUDE.md`, `AGENTS.md`, and TaskNotes config

### Change
- Rewrite the skill as Hermes-native, not OpenClaw-native
- Import the orphaned content-pipeline files into the repo
- Remove or demote stale OpenClaw-specific wording and fallback assumptions
- Add explicit verification and activation steps
- Include a curator-protection step so the restored skill is pinned/marked to avoid being archived again

### Do not do in the repo-edit phase
- Do not modify `~/.hermes/config.yaml`
- Do not switch the Hermes runtime directory to a symlink until repo contents are complete and reviewed
- Do not claim the skill is healthy until a fresh Hermes session can load it

---

## Target End State

At the end of the full rehabilitation:
- `/home/azureuser/projects/obsidian-skill-fede` contains the complete skill source tree
- `~/.hermes/skills/fede/obsidian-skill-fede` is a symlink to that repo
- `skill_view(name='obsidian-skill-fede')` works in a fresh Hermes session
- `SKILL.md` explicitly reflects current Hermes + vault reality
- `README.md` documents repo-source + symlink activation workflow
- content-pipeline references/templates/config/script are tracked in git
- the skill no longer depends on stale OpenClaw framing to be understandable or usable
- the skill is explicitly marked/pinned in the curator workflow so it is not auto-archived again once restored

---

## Phase 1 — Repo Source Rehabilitation

### Objective
Make `/home/azureuser/projects/obsidian-skill-fede` the complete, canonical, git-tracked source of the skill.

### Files to modify
- Modify: `/home/azureuser/projects/obsidian-skill-fede/SKILL.md`
- Modify: `/home/azureuser/projects/obsidian-skill-fede/README.md`

### Files to create/import
- Create: `/home/azureuser/projects/obsidian-skill-fede/references/content-pipeline/hermes-shadow-validation.md`
- Create: `/home/azureuser/projects/obsidian-skill-fede/references/content-pipeline/x-hermes-fallbacks.md`
- Create: `/home/azureuser/projects/obsidian-skill-fede/templates/content-pipeline/article.md`
- Create: `/home/azureuser/projects/obsidian-skill-fede/templates/content-pipeline/instagram.md`
- Create: `/home/azureuser/projects/obsidian-skill-fede/templates/content-pipeline/project-inbox.md`
- Create: `/home/azureuser/projects/obsidian-skill-fede/content-pipeline/config.json`
- Create: `/home/azureuser/projects/obsidian-skill-fede/content-pipeline/scripts/transcribe_openai_whisper.sh`
- Create: `/home/azureuser/projects/obsidian-skill-fede/docs/2026-05-12-obsidian-skill-fede-hermes-rehabilitation-plan.md`

### Required edits in `SKILL.md`
1. Convert frontmatter to Hermes-style:
   - add `version`, `author`, `license`
   - add `metadata.hermes.tags`
   - add `metadata.hermes.related_skills`
   - keep name `obsidian-skill-fede`
   - update description to a proper "Use when ..." style line
2. Rewrite body structure to a modern Hermes skill layout:
   - `# obsidian-skill-fede`
   - `## Overview`
   - `## When to Use`
   - `## Canonical Paths`
   - `## Vault Precedence Rules`
   - `## TaskNotes vs Beads`
   - `## Content-Pipeline Support`
   - `## Common Pitfalls`
   - `## Verification Checklist`
3. Replace stale OpenClaw wording with Hermes wording.
4. Keep `CLAUDE.md` as source of truth and `AGENTS.md` as secondary.
5. Update path guidance to current canonical vault layout:
   - keep PARA roots
   - mark `Inbox/` and `03 - Resources/` as historical only, not live defaults
6. Align metadata rules with current vault directives:
   - markdown edits require `modified`
   - markdown edits require `leido: false`
   - TaskNotes fields should respect plugin config
7. Replace `web_fetch` references with Hermes-relevant guidance:
   - `web_extract` for straightforward extraction
   - browser fallback where dynamic/live pages are required
8. Clarify boundary between this skill and PM/Tech Lead/content-pipeline domain workflows.
9. Add explicit mention that direct raw vault writes are disallowed unless the user explicitly requests bypassing the Obsidian workflow.

### Required edits in `README.md`
1. Reframe the repo as the canonical source tree for the skill.
2. Document the intended runtime symlink pattern for Hermes.
3. Document the legacy OpenClaw symlink only as optional/backward-compatible.
4. Add a repo layout section showing:
   - `SKILL.md`
   - `README.md`
   - `references/`
   - `templates/`
   - `content-pipeline/`
5. Add validation commands:
   - frontmatter parse check
   - `notesmd-cli --version`
   - path existence checks
   - fresh-session `skill_view(name='obsidian-skill-fede')`
6. Document activation caveat: current Hermes session caches skills; new sessions are needed after installing/updating the skill path.

### Required review of imported content-pipeline files
Before copying them in unchanged, verify each file against the current Hermes/vault reality.

Specific checks:
- `content-pipeline/config.json`
  - confirm vault path is correct
  - confirm inbox/output paths exist
  - update extractor naming if `web_fetch_*` fields are misleading
  - check whether `script` path should be repo-relative after migration
- `content-pipeline/scripts/transcribe_openai_whisper.sh`
  - remove reliance on `~/.openclaw/openclaw.json`
  - make env-only or Hermes-friendly credential behavior explicit
  - confirm shell syntax is valid after sanitizing secret-redacted lines
- `templates/content-pipeline/article.md`
  - add or evaluate `modified` / `leido: false`
  - confirm fields fit the current vault conventions
- `templates/content-pipeline/instagram.md`
  - same frontmatter review as above
- `templates/content-pipeline/project-inbox.md`
  - confirm generated note rules are compatible with vault conventions
- `references/content-pipeline/*.md`
  - keep as evidence/reference docs, but update wording if it still sounds transitional or OpenClaw-centric

---

## Phase 2 — Runtime Activation via Symlink

### Objective
Replace the broken Hermes runtime directory with a symlink to the repo source.

### Preconditions
- Phase 1 repo contents complete
- repo diff reviewed
- imported content-pipeline assets committed or at least staged in the repo
- no important runtime-only file remains outside git

### Steps
1. Inventory current runtime directory one last time:
   - `~/.hermes/skills/fede/obsidian-skill-fede`
2. Verify every file in that directory now exists in the repo.
3. Move the current runtime directory aside safely.
4. Create symlink:
   - `~/.hermes/skills/fede/obsidian-skill-fede -> /home/azureuser/projects/obsidian-skill-fede`
5. Verify the symlink target resolves correctly.
6. Apply curator protection to the restored skill so it will not be archived again.
7. Start a fresh Hermes session and confirm the skill is visible.

### Notes
This phase touches `~/.hermes/skills/`, so it should be done only after explicit review/approval of the repo edits and activation command.

---

## Phase 3 — Functional Validation

### Objective
Prove the skill is not only present but operationally coherent.

### Validation checklist
- [ ] `notesmd-cli --version` works
- [ ] source repo has expected files
- [ ] runtime path is a symlink to the repo
- [ ] `skill_view(name='obsidian-skill-fede')` works in a fresh session
- [ ] `SKILL.md` content matches current vault rules (`CLAUDE.md` > `AGENTS.md`)
- [ ] canonical TaskNotes path matches plugin config
- [ ] stale legacy paths are clearly marked non-canonical
- [ ] imported content-pipeline files are present in git
- [ ] README documents installation/activation accurately
- [ ] curator protection/pin is applied so the skill will not be archived again

### Nice-to-have smoke tests
- Dry-run a `notesmd-cli list` against the vault
- Dry-run a frontmatter read on a known note
- Confirm a sample TaskNotes note shape in the vault matches the documented expectations

---

## Proposed Execution Order for the Actual Work

1. Rewrite `SKILL.md`
2. Rewrite `README.md`
3. Import orphaned content-pipeline assets into the repo
4. Normalize imported files for Hermes/vault reality
5. Run repo-local validation checks
6. Review diff
7. Only then switch the Hermes path to a symlink
8. Validate in a fresh Hermes session

---

## Risks

1. Runtime drift risk
The runtime directory currently contains files not present in git. If the symlink is created before migrating them, they will be lost from the active path.

2. Skill loader cache confusion
Even after fixing the repo and symlink, the current session may still not see the skill. Validation must include a fresh session.

3. Template/frontmatter mismatch
The imported content-pipeline templates currently use frontmatter fields that may be insufficient for the current vault rules. They need review before being treated as canonical.

4. Hidden OpenClaw assumptions
The transcription helper and some docs still assume OpenClaw-era credential/config behavior.

---

## Minimal Acceptance Criteria

The rehabilitation is complete only if all of these are true:
- Hermes can load the skill from the symlinked repo source
- the repo contains the full source tree needed by the skill
- the skill documentation matches the current Obsidian vault directives
- the content-pipeline support files are no longer stranded only in `~/.hermes/skills/...`
- the repo remains the single editable source of truth under git

---

## Immediate Next Step

Execute Phase 1 only: rehab the repo source tree under `/home/azureuser/projects/obsidian-skill-fede`, including importing the orphaned content-pipeline assets and rewriting the docs for Hermes-native operation.
