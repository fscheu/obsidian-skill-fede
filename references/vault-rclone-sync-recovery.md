# Vault rclone Sync Recovery

## Context

Federico's Obsidian vault at `/home/azureuser/repos/projects/claude-second-brain` syncs to OneDrive via `rclone bisync`, not via git.

Normal sync runs every 5 minutes from user crontab:

```bash
*/5 * * * * rm -f /home/azureuser/.cache/rclone/bisync/onedrive_Apps_remotely-save_claude-second-brain..home_azureuser_repos_projects_claude-second-brain.lck && rclone bisync onedrive:Apps/remotely-save/claude-second-brain /home/azureuser/repos/projects/claude-second-brain --log-level INFO --log-file /tmp/rclone-sync.log 2>&1
```

## When to Use This Runbook

Use this when vault changes made on the VM, laptop, or mobile do not appear on the other side after the usual sync window.

Typical symptom:
- a note was edited locally but does not show up in OneDrive;
- a note exists in OneDrive but is stale on the VM;
- PM/agent output written into the vault does not propagate after 10+ minutes.

## First Check

Inspect the normal sync log:

```bash
tail -50 /tmp/rclone-sync.log
```

Common failure signature:

```text
ERROR : Bisync critical error: cannot find prior Path1 or Path2 listings, likely due to critical error on prior run
ERROR : Bisync aborted. Must run --resync to recover.
```

Likely cause: bisync state got corrupted or lost after an interrupted run, manual file operations, or listing drift.

## Recovery: Force Resync

Use this only when repeated runs keep showing the prior-listings error or when OneDrive/local vault clearly diverged.

```bash
rclone bisync onedrive:Apps/remotely-save/claude-second-brain /home/azureuser/repos/projects/claude-second-brain --resync --log-level INFO --log-file /tmp/rclone-resync.log
```

Expected behavior:
- rebuilds bisync metadata from scratch;
- local and remote are reconciled again;
- takes about 1-2 minutes for this vault size;
- writes detailed output to `/tmp/rclone-resync.log`.

## Verify Recovery

Check the resync log:

```bash
tail -20 /tmp/rclone-resync.log | grep -E "(Bisync successful|Transferred)"
```

Then run one normal bisync verification pass if needed:

```bash
rclone bisync onedrive:Apps/remotely-save/claude-second-brain /home/azureuser/repos/projects/claude-second-brain --log-level INFO --log-file /tmp/rclone-sync-manual-verify.log
```

Healthy result:
- `Bisync successful`
- `No changes found` on the follow-up run, unless there were still pending edits.

## Important Directionality Note

Before resync, decide which side currently has the truth.

On this VM, local-to-remote recovery is usually the right default when the latest vault edits were made on the VM and OneDrive is stale.

Do not blindly resync if OneDrive has the authoritative version and local is behind; in that case inspect both sides first.

## After Recovery

1. Confirm the next 5-minute cron run succeeds in `/tmp/rclone-sync.log`.
2. Verify one or two recently edited notes on both local vault and OneDrive.
3. Do not treat git status as sync truth; vault sync is rclone-driven, not git-driven.

## Boundaries

- This is vault/Obsidian infrastructure, not a tech-lead-autodev concern.
- Keep this procedure with the Obsidian skill or vault ops docs, not inside development workflow skills.
