ARG FUZZER_PREFIX
FROM $FUZZER_PREFIX/aflplusplus

RUN mkdir /d

COPY source/ /rcfuzz_bench

COPY fuzzer-test-suite-aflplusplus/build_all.sh /

RUN cd /rcfuzz_bench/fuzzer-test-suite-aflplusplus

RUN /build_all.sh
