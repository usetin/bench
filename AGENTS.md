# Agent instructions (Tin benchmarks)

This repository holds Tin's benchmark suites and their harness. The language, compiler and library are in
[usetin/tin](https://github.com/usetin/tin); the documentation and the benchmark policy are in
[usetin/docs](https://github.com/usetin/docs) (`PERFORMANCE.md`).

## Setup and checks

```sh
git clone git@github.com:usetin/tin.git ../tin   # or anywhere: TIN=/path/to/tin
make check        # every benchmark and Go twin compiles
make harness      # the harness self-test (test_benchmarks)
make cpu          # the CPU suite against Go (minutes; Linux numbers only)
```

- `TIN_ROOT` (or `TIN` for the Makefile) points at the tin checkout, default `../tin`.
- **Never quote macOS numbers as results.** Benchmarks are judged on native Linux (`bench-linux.yml`); on shared
  runners only the ratios are meaningful. A "no regression" or "faster" claim needs interleaved Tin/Go (or
  base/head) medians from one machine in one run, with the machine, CPU, kernel and Go version stated.
- Timing never gates a merge: thresholds flag review.

## Rules

- A benchmark is a Tin program and a Go twin with the same name (`v2/fib.tin` and `v2/fib.go`); both must print the
  same lines, and the harness compares the output before timing it. A new benchmark adds both files.
- `tools/ci/tin.sh` compiles and runs a program from the repository root; `compare.tin` measures tin revisions and
  needs each tree built with `make bootstrap`. `tools/ci/check.sh` is the compile smoke.
- Keep the suites portable to Linux; anything measuring the OS (io_uring, cgroups) says so in its header.
- Style follows the Tin language: edition 1, tabs, one declaration per line; `../tin/tin fmt` formats.
