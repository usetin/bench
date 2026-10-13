#!/bin/sh
# Runs a benchmark program with the tin compiler: `tools/ci/tin.sh PATH [ARGS...]` compiles the Tin program
# with the compiler of the tin checkout TIN_ROOT names (default ../tin), built from the checked-in seed when
# missing, and runs it from the repository root. A bare NAME is tools/ci/NAME.tin.
set -e
cd "$(dirname "$0")/../.." || exit 1
tin_root=${TIN_ROOT:-../tin}
tin_root=$(cd "$tin_root" && pwd)
[ -x "$tin_root/bin/tinc" ] || make -s -C "$tin_root" bin/tinc
case $1 in
	*/*) source=$1 ;;
	*.tin) source=$1 ;;
	*) source=tools/ci/$1.tin ;;
esac
shift
mkdir -p bin/ci
exe=bin/ci/$(basename "$source" .tin)
TIN_ROOT=$tin_root "$tin_root/bin/tinc" -o "$exe" "$source"
exec "$exe" "$@"
