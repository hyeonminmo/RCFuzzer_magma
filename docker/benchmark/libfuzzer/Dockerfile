ARG BENCHMARK_PREFIX
ARG FUZZER_PREFIX
FROM $BENCHMARK_PREFIX/fuzzer-test-suite-libfuzzer as bench_fts
FROM $FUZZER_PREFIX/libfuzzer


RUN mkdir /d

COPY source/ /rcfuzz_bench

COPY libfuzzer/build_all.sh /

RUN /build_all.sh > /dev/null

COPY --from=bench_fts /d/p/ /d/p/

COPY seeds/ /seeds

RUN find /rcfuzz_bench -type d -name ".git" | xargs rm -rf
