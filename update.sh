#!/usr/bin/env bash
# Pin the latest T3 Code nightly in source.json. Needs gh (and coreutils).
set -euo pipefail
cd "$(dirname "$0")"

tag=$(gh api 'repos/pingdotgg/t3code/releases?per_page=30' \
  --jq '[.[] | select(.tag_name | test("-nightly\\."))][0].tag_name')
version=${tag#v}
[[ "$version" =~ ^[0-9A-Za-z.+-]+$ ]] || { echo "unexpected tag: $tag" >&2; exit 1; }
asset="t3-${version}-linux-x64.tar.gz"
url="https://github.com/pingdotgg/t3code/releases/download/${tag}/${asset}"

hex=$(gh release download "$tag" -R pingdotgg/t3code -p SHA256SUMS -O - | awk -v a="$asset" '$2 == a { print $1 }')
[ -n "$hex" ] || { echo "no checksum for $asset" >&2; exit 1; }
# Nix's hash format (SRI): sha256- + the checksum in base64.
hash="sha256-$(printf '%s' "${hex^^}" | basenc --base16 -d | base64 -w0)"

cat > source.json <<EOF
{
  "version": "${version}",
  "url": "${url}",
  "hash": "${hash}"
}
EOF
echo "${version}"
