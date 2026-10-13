#!/bin/sh
# Checks that every benchmark compiles (nothing runs): tools/ci/check.sh. TIN_ROOT is a tin checkout
# (default ../tin); its compiler is built from the checked-in seed when missing.
set -eu
cd "$(dirname "$0")/../.." || exit 1
tin_root=${TIN_ROOT:-../tin}
tin_root=$(cd "$tin_root" && pwd)
[ -x "$tin_root/bin/tinc" ] || make -s -C "$tin_root" bin/tinc
tinc=$tin_root/bin/tinc
# the suites' entry points
for f in run.tin compare.tin files/run.tin files/files.tin v04/run.tin v04/users.tin v04/seed.tin dispatch/dispatch.tin dispatch/dyn.tin router/router.tin http/https.tin http/routes.tin http/wire_load.tin http/run_https.tin http/run_wire.tin http/run_wrk.tin http/run_h2load.tin http/profile_https.tin; do
	TIN_ROOT=$tin_root "$tinc" -check "$f"
	echo "ok $f"
done
# every CPU benchmark, and its Go twin
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
for f in v2/*.tin; do
	TIN_ROOT=$tin_root "$tinc" -check "$f"
	echo "ok $f"
done
for f in v2/*.go; do
	go -C v2 build -o "$tmp/twin" "$(basename "$f")"
	echo "ok $f"
done
