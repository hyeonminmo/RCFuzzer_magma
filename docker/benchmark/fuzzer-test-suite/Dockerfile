ARG FUZZER_PREFIX
FROM $FUZZER_PREFIX/afl

RUN mkdir /d

COPY source/ /rcfuzz_bench

RUN cd /rcfuzz_bench/fuzzer-test-suite

COPY fuzzer-test-suite/build_all.sh /

RUN /build_all.sh
