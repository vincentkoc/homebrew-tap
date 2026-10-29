#!/usr/bin/env bash
# Print the AgentRinse formula's release metadata as KEY=value lines for
# $GITHUB_ENV, so workflow checks follow the formula instead of hard-coding a
# version. Fails if the formula's url, version and sha256 do not line up.
#
# usage: scripts/agentrinse-formula-metadata.sh [Formula/agentrinse.rb]
set -euo pipefail

formula="${1:-Formula/agentrinse.rb}"
[ -f "$formula" ] || { echo "formula not found: $formula" >&2; exit 1; }

url="$(sed -nE 's/^  url "([^"]+)"$/\1/p' "$formula")"
sha256="$(sed -nE 's/^  sha256 "([0-9a-f]{64})"$/\1/p' "$formula")"
revision="$(sed -nE 's/^  revision ([0-9]+)$/\1/p' "$formula")"

[ "$(printf '%s\n' "$url" | grep -c .)" = "1" ] || { echo "expected exactly one url in $formula" >&2; exit 1; }
[ "$(printf '%s\n' "$sha256" | grep -c .)" = "1" ] || { echo "expected exactly one sha256 in $formula" >&2; exit 1; }

version="$(printf '%s\n' "$url" |
  sed -nE 's#^https://github\.com/vincentkoc/agentrinse/releases/download/v([0-9]+\.[0-9]+\.[0-9]+)/agentrinse-([0-9]+\.[0-9]+\.[0-9]+)\.tgz$#\1 \2#p')"
read -r tag_version file_version <<<"${version:-} "
if [ -z "${tag_version:-}" ] || [ "$tag_version" != "${file_version:-}" ]; then
  echo "url does not name one agentrinse release version: $url" >&2
  exit 1
fi

keg="$tag_version"
[ -z "$revision" ] || keg="${tag_version}_${revision}"

printf 'AGENTRINSE_VERSION=%s\n' "$tag_version"
printf 'AGENTRINSE_KEG=%s\n' "$keg"
printf 'AGENTRINSE_URL=%s\n' "$url"
printf 'AGENTRINSE_SHA256=%s\n' "$sha256"
