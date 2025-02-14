#!/bin/bash -e

cd /rcfuzz_bench/magma && \
    ls *.tar.gz|xargs -i tar xf '{}' &&\
    rm -r *.tar.gz &&\
    ls -alh


magma_targets=(
    libsndfile
    libtiff-read_rgba
    libtiff-tiffcp
    lua
    php-exif
    php-json
    php-parser
    php-unserialize
    poppler-pdf
    poppler-pdfimage
    poppler-pdftoppm
)

for magma_target in "${magma_targets[@]}";

do
    mkdir -p /d/p/libfuzzer/magma/$magma_target
done

{
     cd /rcfuzz_bench/magma/libsndfile && \
        cp sndfile_libfuzzer /d/p/libfuzzer/magma/libsndfile/libsndfile 
} &

{
     cd /rcfuzz_bench/magma/libtiff-read_rgba && \
        cp libtiff-read_rgba_libfuzzer /d/p/libfuzzer/magma/libtiff-read_rgba/libtiff-read_rgba 
} &

{
     cd /rcfuzz_bench/magma/libtiff-tiffcp && \
        cp libtiff-tiffcp_libfuzzer /d/p/libfuzzer/magma/libtiff-tiffcp/libtiff-tiffcp 
} &

{
     cd /rcfuzz_bench/magma/lua && \
        cp liblua_libfuzzer.a /d/p/libfuzzer/magma/lua/liblua.a && \
        cp lua_libfuzzer /d/p/libfuzzer/magma/lua/lua 
} &

{
     cd /rcfuzz_bench/magma/php-exif && \
        cp exif_libfuzzer /d/p/libfuzzer/magma/php-exif/php-exif 
} &

{
     cd /rcfuzz_bench/magma/php-json && \
        cp json_libfuzzer /d/p/libfuzzer/magma/php-json/php-json 
} &

{
     cd /rcfuzz_bench/magma/php-parser && \
        cp parser_libfuzzer /d/p/libfuzzer/magma/php-parser/php-parser 
} &

{
     cd /rcfuzz_bench/magma/php-unserialize && \
        cp unserialize_libfuzzer /d/p/libfuzzer/magma/php-unserialize/php-unserialize 
} &

{
     cd /rcfuzz_bench/magma/poppler-pdf && \
        cp poppler-pdf_libfuzzer /d/p/libfuzzer/magma/poppler-pdf/poppler-pdf 
} &

{
     cd /rcfuzz_bench/magma/poppler-pdfimage && \
        cp poppler-pdfimage_libfuzzer /d/p/libfuzzer/magma/poppler-pdfimage/poppler-pdfimage 
} &

{
     cd /rcfuzz_bench/magma/poppler-pdftoppm && \
        cp poppler-pdftoppm_libfuzzer /d/p/libfuzzer/magma/poppler-pdftoppm/poppler-pdftoppm 
} &



wait
