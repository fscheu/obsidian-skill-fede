# X/Twitter on Hermes: primary path and fallbacks

Use this reference when migrating the content-pipeline from OpenClaw to Hermes in an X-heavy workflow.

## What changed vs OpenClaw

OpenClaw's documented primary extractor for X was `x_search`, with weak public fallbacks like `web_fetch` and `r.jina.ai`.

In Hermes, for a production-usable X-first pipeline:
- primary path should be `xurl` (official X API CLI)
- first serious fallback should be Hermes browser extraction on the live X page
- public mirror/syndication style fallbacks are low-trust only

## Findings validated on this VM (2026-04-30)

- `xurl` was installed successfully at `/home/azureuser/.local/bin/xurl`
- `xurl auth status` showed no registered apps yet, so API-backed extraction was not smoke-tested end-to-end yet
- Hermes browser could recover visible public tweet data from X directly (author, handle, text, timestamp, visible links)
- `r.jina.ai` returned HTTP 403 for tested X URLs in this environment
- `fxtwitter` / `vxtwitter` / `cdn.syndication.twimg.com` looked unreliable for production-grade extraction in this environment

## Recommended extraction ladder for X on Hermes

1. `xurl read <url-or-id>`
2. if thread signals or incomplete link metadata, follow with `xurl search ...` to reconstruct the thread
3. if `xurl` is unavailable, unauthenticated, or returns incomplete data, use Hermes browser on the live X page
4. only as a last rescue, use public mirrors/static HTML parsers for minimal text recovery — never trust them for full thread reconstruction

## Minimum acceptable extraction fields

Do not treat an X extraction as "good" unless it can recover enough data to decide:
- standalone vs thread
- whether external links exist

Minimum fields:
- `canonical_url`
- `status_id`
- `author_handle`
- `created_at`
- `text`
- `extracted_links_internal`
- `extracted_links_external`
- `thread_signals`
- `extraction_method`
- `extraction_confidence`

## Thread heuristics to preserve from the original skill

Escalate to thread reconstruction when any of these appear:
- `1/`, `2/`, `/N`, `(1)`, `Thread:`, `🧵`
- mentions `thread` or `hilo`
- ends with continuation markers like `...` or `→`
- same-author reply / self-reply metadata

## Browser fallback acceptance rule

Accept browser fallback as:
- `medium` confidence for a standalone post if author + text + timestamp are recovered
- `medium` confidence for a thread only if at least 2 same-author posts in the chain are recovered, or the extractor explicitly marks it as a partial thread

If the browser only recovers partial data, keep the note degraded and mark the source for retry rather than pretending the thread is complete.
