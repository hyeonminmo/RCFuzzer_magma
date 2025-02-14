ARG FUZZER_PREFIX
FROM $FUZZER_PREFIX/base

RUN mkdir /d

COPY source/ /rcfuzz_bench

COPY gcc/build_all.sh /

RUN /build_all.sh > /dev/null
