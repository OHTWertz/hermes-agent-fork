#!/bin/bash
set -e

# Mirror dashboard-ref-only's startup: create every directory hermes expects
# and seed a default config.yaml if the volume is empty. Without these,
# `hermes dashboard` endpoints that hit logs/, sessions/, cron/, etc. can fail
# with opaque errors even though no auth is actually involved.
mkdir -p /data/.hermes/cron /data/.hermes/sessions /data/.hermes/logs \
         /data/.hermes/memories /data/.hermes/skills /data/.hermes/pairing \
         /data/.hermes/hooks /data/.hermes/image_cache /data/.hermes/audio_cache \
         /data/.hermes/workspace
# SOUL.md: repo is source of truth — overwrite the volume copy on every boot
# so edits to SOUL.md in this repo take effect on redeploy without manual sync.
[ -f /app/SOUL.md ] && cp /app/SOUL.md /data/.hermes/SOUL.md

# skills/: repo is source of truth — sync each repo skill into the volume on
# every boot. Uses rsync semantics via cp -R: existing volume-only skills
# (e.g. agent-generated via skill_manage) are preserved, but repo skills
# always reflect the latest committed version.
if [ -d /app/skills ]; then
  for skill_dir in /app/skills/*/; do
    skill_name=$(basename "$skill_dir")
    rm -rf "/data/.hermes/skills/$skill_name"
    cp -R "$skill_dir" "/data/.hermes/skills/$skill_name"
  done
fi

if [ ! -f /data/.hermes/config.yaml ] && [ -f /opt/hermes-agent/cli-config.yaml.example ]; then
  cp /opt/hermes-agent/cli-config.yaml.example /data/.hermes/config.yaml
fi

[ ! -f /data/.hermes/.env ] && touch /data/.hermes/.env

# Clear any stale gateway PID file left over from the previous container.
# `hermes gateway` writes /data/.hermes/gateway.pid on start but does not
# remove it on SIGTERM. Since /data is a persistent volume, the file
# survives container restarts and causes every subsequent boot to exit with
# "ERROR gateway.run: PID file race lost to another gateway instance".
# No hermes process can be running at this point (we're pre-exec in a fresh
# container), so removing the file unconditionally is safe.
rm -f /data/.hermes/gateway.pid

exec python /app/server.py
