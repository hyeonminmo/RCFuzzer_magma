#!/bin/bash -e

cd /rcfuzz_bench/unibench && \
    mkdir mp3gain-1.5.2 && cd mp3gain-1.5.2 && mv ../mp3gain-1.5.2.zip ./ && unzip -q mp3gain-1.5.2.zip && rm mp3gain-1.5.2.zip && cd .. &&\
    ls *.zip|xargs -i unzip -q '{}' &&\
    ls *.tar.gz|xargs -i tar xf '{}' &&\
    rm -r *.tar.gz *.zip &&\
    mv SQLite-8a8ffc86 SQLite-3.8.9 && mv binutils_5279478 binutils-5279478 && mv libtiff-Release-v3-9-7 libtiff-3.9.7 &&\
    ls -alh

mkdir -p /d/p/justafl /d/p/aflasan

unibench_targets=(
    exiv2
    gdk-pixbuf-pixdata
    imginfo
    jhead
    tiffsplit
    lame
    mp3gain
    wav2swf
    ffmpeg
    flvmeta
    mp42aac
    cflow
    infotocap
    jq
    mujs
    pdftotext
    sqlite3
    nm
    tcpdump
    # binutils
    objdump
    readelf
    cxxfilt
    ar
    size
    strings
)


for target in "${unibench_targets[@]}";
do
    mkdir -p /d/p/justafl/unibench/$target
    mkdir -p /d/p/aflasan/unibench/$target
done

{
 cd /rcfuzz_bench/unibench/exiv2-0.26 && cmake -DEXIV2_ENABLE_SHARED=OFF . && \
     make clean && \
     make -j && cp bin/exiv2 /d/p/justafl/unibench/exiv2/exiv2 &&\
     make clean && AFL_USE_ASAN=1 make -j && cp bin/exiv2 /d/p/aflasan/unibench/exiv2/exiv2 &&\
     make clean
} &

{
cd /rcfuzz_bench/unibench/gdk-pixbuf-2.31.1 &&\
    ./autogen.sh --enable-static=yes --enable-shared=no --with-included-loaders=yes && \
    make clean && \
    make -j &&\
    cp gdk-pixbuf/gdk-pixbuf-pixdata /d/p/justafl/unibench/gdk-pixbuf-pixdata &&\
    make clean && AFL_USE_ASAN=1 make -j &&\
    cp gdk-pixbuf/gdk-pixbuf-pixdata /d/p/aflasan/unibench/gdk-pixbuf-pixdata &&\
    make clean
} &

{
cd /rcfuzz_bench/unibench/jasper-2.0.12 && cmake -DJAS_ENABLE_SHARED=OFF -DALLOW_IN_SOURCE_BUILD=ON . &&\
    make clean && \
    make -j &&\
    cp src/appl/imginfo /d/p/justafl/unibench/imginfo &&\
    make clean && AFL_USE_ASAN=1 make -j &&\
    cp src/appl/imginfo /d/p/aflasan/unibench/imginfo &&\
    make clean
} &

{
    cd /rcfuzz_bench/unibench/jhead-3.00 &&\
        make clean && \
        make -j &&\
        cp jhead /d/p/justafl/unibench/jhead &&\
        make clean && AFL_USE_ASAN=1 make -j &&\
        cp jhead /d/p/aflasan/unibench/jhead &&\
        make clean
} &

{
    cd /rcfuzz_bench/unibench/libtiff-3.9.7 && ./autogen.sh && ./configure --disable-shared &&\
        make clean && \
        make -j &&\
        cp tools/tiffsplit /d/p/justafl/unibench/tiffsplit &&\
        make clean && AFL_USE_ASAN=1 make -j &&\
        cp tools/tiffsplit /d/p/aflasan/unibench/tiffsplit &&\
        make clean
} &

{
    cd /rcfuzz_bench/unibench/lame-3.99.5 && ./configure --disable-shared &&\
        make clean && \
        make -j &&\
        cp frontend/lame /d/p/justafl/unibench/lame &&\
        make clean && AFL_USE_ASAN=1 make -j &&\
        cp frontend/lame /d/p/aflasan/unibench/lame &&\
        make clean
} &

{
    cd /rcfuzz_bench/unibench/mp3gain-1.5.2 && sed -i 's/CC=/CC?=/' Makefile &&\
        make clean && \
        make -j &&\
        cp mp3gain /d/p/justafl/unibench/mp3gain &&\
        make clean && AFL_USE_ASAN=1 make -j &&\
        cp mp3gain /d/p/aflasan/unibench/mp3gain &&\
        make clean
} &

{
    cd /rcfuzz_bench/unibench/swftools-0.9.2/ && ./configure &&\
        make clean && \
        make -j &&\
        cp src/wav2swf /d/p/justafl/unibench/wav2swf &&\
        make clean && AFL_USE_ASAN=1 make -j &&\
        cp src/wav2swf /d/p/aflasan/unibench/wav2swf &&\
        make clean
} &

# Comment out ffmpeg for building under travis-ci
# The memory usage seems to exceed 3GB and may make the whole build job timeout (50 minutes)
{
    cd /rcfuzz_bench/unibench/ffmpeg-4.0.1 && ./configure --disable-shared --cc="$CC" --cxx="$CXX" &&\
        make clean && \
        make -j &&\
        cp ffmpeg_g /d/p/justafl/unibench/ffmpeg/ffmpeg &&\
        make clean && AFL_USE_ASAN=1 make -j &&\
        cp ffmpeg_g /d/p/aflasan/unibench/ffmpeg/ffmpeg &&\
        make clean
} &

{
    cd /rcfuzz_bench/unibench/flvmeta-1.2.1 && cmake . &&\
        make clean && \
        make -j &&\
        cp src/flvmeta /d/p/justafl/unibench/flvmeta &&\
        make clean && AFL_USE_ASAN=1 make -j &&\
        cp src/flvmeta /d/p/aflasan/unibench/flvmeta &&\
        make clean
} &

{
    cd /rcfuzz_bench/unibench/Bento4-1.5.1-628 && cmake . &&\
        make clean && \
        make -j &&\
        cp mp42aac /d/p/justafl/unibench/mp42aac &&\
        make clean && AFL_USE_ASAN=1 make -j &&\
        cp mp42aac /d/p/aflasan/unibench/mp42aac &&\
        make clean
} &

{
    cd /rcfuzz_bench/unibench/cflow-1.6 && ./configure &&\
        make clean && \
        make -j &&\
        cp src/cflow /d/p/justafl/unibench/cflow &&\
        make clean && AFL_USE_ASAN=1 make -j &&\
        cp src/cflow /d/p/aflasan/unibench/cflow &&\
        make clean
} &

{
    cd /rcfuzz_bench/unibench/ncurses-6.1 && ./configure --disable-shared &&\
        make clean && \
        make -j &&\
        cp progs/tic /d/p/justafl/unibench/infotocap/infotocap &&\
        make clean && AFL_USE_ASAN=1 ASAN_OPTIONS="detect_leaks=0" make -j &&\
        cp progs/tic /d/p/aflasan/unibench/infotocap/infotocap &&\
        make clean
} &

{
    cd /rcfuzz_bench/unibench/jq-1.5 && ./configure --disable-shared &&\
        make clean && \
        make -j &&\
        cp jq /d/p/justafl/unibench/jq &&\
        make clean && AFL_USE_ASAN=1 make -j &&\
        cp jq /d/p/aflasan/unibench/jq &&\
        make clean
} &

{
    cd /rcfuzz_bench/unibench/mujs-1.0.2 &&\
        make clean && \
        build=debug make -j &&\
        cp build/debug/mujs /d/p/justafl/unibench/mujs &&\
        make clean && AFL_USE_ASAN=1 build=debug make -j &&\
        cp build/debug/mujs /d/p/aflasan/unibench/mujs &&\
        make clean
} &

{
    cd /rcfuzz_bench/unibench/xpdf-4.00 && cmake . &&\
        make clean && \
        make -j &&\
        cp xpdf/pdftotext /d/p/justafl/unibench/pdftotext &&\
        make clean && AFL_USE_ASAN=1 make -j &&\
        cp xpdf/pdftotext /d/p/aflasan/unibench/pdftotext &&\
        make clean
} &

#--disable-amalgamation can be used for coverage build
{
    cd /rcfuzz_bench/unibench/SQLite-3.8.9 && ./configure --disable-shared &&\
        make clean && \
        make -j &&\
        cp sqlite3 /d/p/justafl/unibench/sqlite3 &&\
        make clean && AFL_USE_ASAN=1 ASAN_OPTIONS="detect_leaks=0" make -j &&\
        cp sqlite3 /d/p/aflasan/unibench/sqlite3 &&\
        make clean
} &

{
    cd /rcfuzz_bench/unibench/binutils-5279478 &&\
        ./configure --disable-shared &&\
        for i in bfd libiberty opcodes libctf; do cd $i; ./configure --disable-shared && make clean && make -j; cd ..; done  &&\
        cd binutils  &&\
        ./configure --disable-shared &&\
        make nm-new &&\
        cp nm-new /d/p/justafl/unibench/nm/nm &&\
        cd /rcfuzz_bench/unibench/binutils-5279478 &&\
        for i in bfd libiberty opcodes libctf; do cd $i; make clean && AFL_USE_ASAN=1 make -j; cd ..; done  &&\
        cd binutils  && make clean &&\
        AFL_USE_ASAN=1 make nm-new &&\
        cp nm-new /d/p/aflasan/unibench/nm/nm &&\
        cd .. && make distclean
} &

{
    cd /rcfuzz_bench/unibench/binutils-2.28 && ./configure --disable-shared && \
        make clean && \
        make -j && \
        cp binutils/objdump /d/p/justafl/unibench/objdump &&\
        cp binutils/readelf /d/p/justafl/unibench/readelf &&\
        cp binutils/cxxfilt /d/p/justafl/unibench/cxxfilt &&\
        cp binutils/ar /d/p/justafl/unibench/ar &&\
        cp binutils/size /d/p/justafl/unibench/size &&\
        cp binutils/strings /d/p/justafl/unibench/strings &&\
        make clean && AFL_USE_ASAN=1 ASAN_OPTIONS="detect_leaks=0" make -j &&\
        cp binutils/objdump /d/p/aflasan/unibench/objdump &&\
        cp binutils/readelf /d/p/aflasan/unibench/readelf &&\
        cp binutils/cxxfilt /d/p/aflasan/unibench/cxxfilt &&\
        cp binutils/ar /d/p/aflasan/unibench/ar &&\
        cp binutils/size /d/p/aflasan/unibench/size &&\
        cp binutils/strings /d/p/aflasan/unibench/strings &&\
        make clean
} &

{
    cd /rcfuzz_bench/unibench/libpcap-1.8.1 && ./configure --disable-shared &&\
        make clean && \
        make -j &&\
        cd /rcfuzz_bench/unibench/tcpdump-4.8.1 && ./configure &&\
        make clean && \
        make -j &&\
        cp tcpdump /d/p/justafl/unibench/tcpdump &&\
        cd /rcfuzz_bench/unibench/libpcap-1.8.1 &&\
        make clean && AFL_USE_ASAN=1 make -j &&\
        cd /rcfuzz_bench/unibench/tcpdump-4.8.1 &&\
        make clean && AFL_USE_ASAN=1 make -j &&\
        cp tcpdump /d/p/aflasan/unibench/tcpdump &&\
        make clean && cd /rcfuzz_bench/unibench/libpcap-1.8.1 && make clean
} &

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
    mkdir -p /d/p/justafl/magma/$magma_target
    mkdir -p /d/p/aflasan/magma/$magma_target
done

{
     cd /rcfuzz_bench/magma/libsndfile && \
        cp sndfile_afl /d/p/justafl/magma/libsndfile/libsndfile && \
        cp sndfile_asan /d/p/aflasan/magma/libsndfile/libsndfile
} &

{
     cd /rcfuzz_bench/magma/libtiff-read_rgba && \
        cp libtiff-read_rgba_afl /d/p/justafl/magma/libtiff-read_rgba/libtiff-read_rgba && \
        cp libtiff-read_rgba_asan /d/p/aflasan/magma/libtiff-read_rgba/libtiff-read_rgba
} &

{
     cd /rcfuzz_bench/magma/libtiff-tiffcp && \
        cp libtiff-tiffcp_afl /d/p/justafl/magma/libtiff-tiffcp/libtiff-tiffcp && \
        cp libtiff-tiffcp_asan /d/p/aflasan/magma/libtiff-tiffcp/libtiff-tiffcp
} &

{
     cd /rcfuzz_bench/magma/lua && \
        cp liblua_afl.a /d/p/justafl/magma/lua/liblua.a && \
        cp lua_afl /d/p/justafl/magma/lua/lua && \
        cp liblua_asan.a /d/p/aflasan/magma/lua/liblua.a && \
        cp lua_asan /d/p/aflasan/magma/lua/lua
} &

{
     cd /rcfuzz_bench/magma/php-exif && \
        cp exif_afl /d/p/justafl/magma/php-exif/php-exif && \
        cp exif_asan /d/p/aflasan/magma/php-exif/php-exif
} &

{
     cd /rcfuzz_bench/magma/php-json && \
        cp json_afl /d/p/justafl/magma/php-json/php-json && \
        cp json_asan /d/p/aflasan/magma/php-json/php-json
} &

{
     cd /rcfuzz_bench/magma/php-parser && \
        cp parser_afl /d/p/justafl/magma/php-parser/php-parser && \
        cp parser_asan /d/p/aflasan/magma/php-parser/php-parser
} &

{
     cd /rcfuzz_bench/magma/php-unserialize && \
        cp unserialize_afl /d/p/justafl/magma/php-unserialize/php-unserialize && \
        cp unserialize_asan /d/p/aflasan/magma/php-unserialize/php-unserialize
} &

{
     cd /rcfuzz_bench/magma/poppler-pdf && \
        cp poppler-pdf_afl /d/p/justafl/magma/poppler-pdf/poppler-pdf && \
        cp poppler-pdf_asan /d/p/aflasan/magma/poppler-pdf/poppler-pdf
} &

{
     cd /rcfuzz_bench/magma/poppler-pdfimage && \
        cp poppler-pdfimage_afl /d/p/justafl/magma/poppler-pdfimage/poppler-pdfimage && \
        cp poppler-pdfimage_asan /d/p/aflasan/magma/poppler-pdfimage/poppler-pdfimage
} &

{
     cd /rcfuzz_bench/magma/poppler-pdftoppm && \
        cp poppler-pdftoppm_afl /d/p/justafl/magma/poppler-pdftoppm/poppler-pdftoppm && \
        cp poppler-pdftoppm_asan /d/p/aflasan/magma/poppler-pdftoppm/poppler-pdftoppm
} &


wait
