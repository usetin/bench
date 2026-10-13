# Tin benchmarks: build and run them with a tin checkout (TIN, default ../tin).
#
#   make check    every benchmark and Go twin compiles
#   make cpu      the CPU suite (v2/) against Go, seven alternating runs
#   make harness  the benchmark harness self-test
#
# TIN points at a checkout of usetin/tin (the compiler, runtime, std and packages); it is built from
# its checked-in seed when needed.
TIN ?= ../tin

.PHONY: check cpu harness

check:
	TIN_ROOT=$(abspath $(TIN)) sh tools/ci/check.sh

cpu:
	TIN_ROOT=$(abspath $(TIN)) sh tools/ci/tin.sh run.tin

harness:
	TIN_ROOT=$(abspath $(TIN)) sh tools/ci/tin.sh test_benchmarks
