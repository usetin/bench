# Tin benchmarks

The benchmark suites of [Tin](https://github.com/usetin/tin): Tin against Go, on native Linux (macOS numbers are
development numbers and are never quoted as results — [PERFORMANCE.md](https://github.com/usetin/docs/blob/main/PERFORMANCE.md)).
The compiler and the library live in usetin/tin; this repository holds the suites and the harness that runs them.

| suite | what it measures |
|---|---|
| `v2/` | the CPU suite: one Tin program and its Go twin per benchmark, seven alternating runs, medians |
| `http/` | HTTP/1.1, HTTPS and HTTP/2 servers (anvil against Go's `net/http` and `crypto/tls`), the `wire` client, wrk and h2load |
| `files/` | `quarry.ReadFile` of 10k files: io_uring against helper threads |
| `v04/` | the v0.4 service benchmark: `GET /users/{id}` through Redis over MySQL, Tin against Go + chi under wrk2 |
| `dispatch/`, `router/`, `collatz.tin`, `fib.tin`, `matmul.tin`, `sieve.tin` | micro benchmarks (shape dispatch, routing, classic kernels) |
| `benchlib/` | the harness: interleaved timing, medians, wrk/h2load parsers, JSON text |
| `tools/ci/` | the runners (`tin.sh`), the compile check (`check.sh`) and the harness self-test (`test_benchmarks.tin`) |

## Running

```sh
git clone git@github.com:usetin/tin.git ../tin   # or anywhere: TIN=/path/to/tin
make check                    # every benchmark and its Go twin compiles
make cpu                      # the CPU suite (v2) against Go, seven alternating runs
BENCH_DIR=v2 RUNS=7 sh tools/ci/tin.sh run.tin fib   # selected benchmarks
```

`run.tin` compares Tin and Go output first and times only what matches; `BENCH_DIR` selects the directory (default
`v2`, the CPU suite) and `RUNS` (at least 7) the alternating runs.

`compare.tin` measures one tin revision against another with each side's own compiler and library: check both out,
build each with `make -C <tree> bootstrap`, then

```sh
TIN_ROOT=$PWD/tin sh tools/ci/tin.sh compare.tin --base-root <base tree> --head-root <head tree>
```

`.github/workflows/bench-linux.yml` (run by hand or weekly) does this on `ubuntu-24.04` and `ubuntu-24.04-arm`: the
inputs `tin_ref` and `tin_base` choose the tin revisions, and the suite is the one from the selected bench revision.
`bench.yml` runs the v0.4 service benchmark, `profile-linux.yml` profiles a TLS handshake with `perf`. On GitHub's
shared runners only the ratios are meaningful, and timing never gates a merge.
