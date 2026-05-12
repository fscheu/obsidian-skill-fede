# Hermes shadow validation findings

Validated during the May 2026 migration review on Fede's VM.

## Infra confirmed ready
- Hermes `web` toolset enabled
- Hermes `browser` toolset enabled
- Tavily configured
- Firecrawl configured
- `yt-dlp` installed
- `uv` installed
- Instagram cookies present
- YouTube cookies present
- inbox exists at `00_Inbox/Links-To-Process/`
- output exists at `00_Inbox/Content-Pipeline/`

## Extraction results
### Web
`web_extract` worked on a public article (`https://paulgraham.com/startupideas.html`) and is a valid practical replacement for old `web_fetch` guidance.

### X
- `xurl` is installed, but may be unusable until OAuth is completed
- on this VM, `xurl read` returned `401 Unauthorized` before OAuth was fixed
- Hermes browser successfully recovered a public post's text, handle, visible date, and basic metrics
- operational conclusion: keep `xurl` as primary, but degrade quickly to browser when auth is missing or response quality is insufficient

## Operational implication
The content-pipeline is no longer blocked on broad Hermes infra. The remaining blockers are operational:
1. finish `xurl` auth for the VM
2. run a broader 3-link shadow pass (X + web + Instagram/YouTube)
3. only then create a Hermes cron and enable automatic inbox marking
