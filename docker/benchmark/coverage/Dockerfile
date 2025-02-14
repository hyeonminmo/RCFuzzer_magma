ARG FUZZER_PREFIX
ARG BENCHMARK_PREFIX
FROM $BENCHMARK_PREFIX/fuzzer-test-suite as bench_fts
FROM $BENCHMARK_PREFIX/afl as bench_afl
FROM $FUZZER_PREFIX/base

RUN mkdir /d

COPY source/ /rcfuzz_bench

ENV CC="gcc -fprofile-arcs -ftest-coverage" CXX="g++ -fprofile-arcs -ftest-coverage"

COPY coverage/build_all.sh /

RUN /build_all.sh > /dev/null

COPY --from=bench_fts /d/p/ /d/p/
COPY  --from=bench_fts /rcfuzz_bench/fuzzer-test-suite-build/ /rcfuzz_bench/fuzzer-test-suite-build
COPY --from=bench_afl /d/p/ /d/p/

COPY seeds/ /seeds

RUN find /rcfuzz_bench -type d -name ".git" | xargs rm -rf
