#!/usr/bin/env bash
set -euo pipefail

# Minimal OpenAI Whisper transcription helper for obsidian-skill-fede content-pipeline.
# Requirements:
# - curl
# - OPENAI_API_KEY in the environment
#
# Usage:
#   transcribe_openai_whisper.sh /path/to/audio.m4a
#   transcribe_openai_whisper.sh /path/to/audio.m4a --json
#   transcribe_openai_whisper.sh /path/to/audio.m4a --language es --out /tmp/transcript.txt

in="${1:-}"
if [[ -z "$in" || "$in" == "-h" || "$in" == "--help" ]]; then
  cat <<'USAGE' >&2
Usage: transcribe_openai_whisper.sh <audio_file> [--model whisper-1] [--language <lang>] [--prompt <text>] [--json] [--out <path>]
USAGE
  exit 2
fi
shift || true

if [[ ! -f "$in" ]]; then
  echo "Audio file not found: $in" >&2
  exit 2
fi

: "${OPENAI_API_KEY:?OPENAI_API_KEY is required}"

model="whisper-1"
language=""
prompt=""
want_json=0
out=""
api_url="${OPENAI_AUDIO_TRANSCRIPTIONS_URL:-https://api.openai.com/v1/audio/transcriptions}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --model) model="$2"; shift 2 ;;
    --language) language="$2"; shift 2 ;;
    --prompt) prompt="$2"; shift 2 ;;
    --json) want_json=1; shift ;;
    --out) out="$2"; shift 2 ;;
    *) echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

fmt="text"
if [[ $want_json -eq 1 ]]; then
  fmt="json"
fi

args=(
  --silent
  --show-error
  --fail
  -X POST "$api_url"
  -H "Authorization: Bearer ${OPENAI_API_KEY}"
  -F "file=@${in}"
  -F "model=${model}"
  -F "response_format=${fmt}"
)

if [[ -n "$language" ]]; then
  args+=( -F "language=${language}" )
fi

if [[ -n "$prompt" ]]; then
  args+=( -F "prompt=${prompt}" )
fi

if [[ -n "$out" ]]; then
  curl "${args[@]}" > "$out"
else
  curl "${args[@]}"
fi
