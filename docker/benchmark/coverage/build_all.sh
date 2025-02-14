#!/bin/bash -e

cd /rcfuzz_bench/unibench && \
    mkdir mp3gain-1.5.2 && cd mp3gain-1.5.2 && mv ../mp3gain-1.5.2.zip ./ && unzip -q mp3gain-1.5.2.zip && rm mp3gain-1.5.2.zip && cd .. &&\
    ls *.zip|xargs -i unzip -q '{}' &&\
    ls *.tar.gz|xargs -i tar xf '{}' &&\
    rm -r *.tar.gz *.zip &&\
    mv SQLite-8a8ffc86 SQLite-3.8.9 && mv binutils_5279478 binutils-5279478 && mv libtiff-Release-v3-9-7 libtiff-3.9.7 &&\
    ls -alh

mkdir -p /d/p/cov
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
    objdump
    tcpdump
)


for target in "${unibench_targets[@]}";
do
    mkdir -p /d/p/cov/unibench/$target
done

{
 cd /rcfuzz_bench/unibench/exiv2-0.26 && cmake -DEXIV2_ENABLE_SHARED=OFF . && \
     make clean && \
     make -j && cp bin/exiv2 /d/p/cov/unibench/exiv2 && make clean
} &

{
cd /rcfuzz_bench/unibench/gdk-pixbuf-2.31.1 &&\
    ./autogen.sh --enable-static=yes --enable-shared=no --with-included-loaders=yes && \
    make clean && \
    make -j &&\
    cp gdk-pixbuf/gdk-pixbuf-pixdata /d/p/cov/unibench/gdk-pixbuf-pixdata && make clean
} &

{
cd /rcfuzz_bench/unibench/jasper-2.0.12 && cmake -DJAS_ENABLE_SHARED=OFF -DALLOW_IN_SOURCE_BUILD=ON . &&\
    make clean && \
    make -j &&\
    cp src/appl/imginfo /d/p/cov/unibench/imginfo && make clean
} &

{
    cd /rcfuzz_bench/unibench/jhead-3.00 &&\
        make clean && \
        make -j &&\
        cp jhead /d/p/cov/unibench/jhead && make clean
} &

{
    cd /rcfuzz_bench/unibench/libtiff-3.9.7 && ./autogen.sh && ./configure --disable-shared &&\
        make clean && \
        make -j &&\
        cp tools/tiffsplit /d/p/cov/unibench/tiffsplit && make clean
} &

{
    cd /rcfuzz_bench/unibench/lame-3.99.5 && ./configure --disable-shared &&\
        make clean && \
        make -j &&\
        cp frontend/lame /d/p/cov/unibench/lame && make clean
} &

{
    cd /rcfuzz_bench/unibench/mp3gain-1.5.2 && sed -i 's/CC=/CC?=/' Makefile &&\
        make clean && \
        make -j &&\
        cp mp3gain /d/p/cov/unibench/mp3gain && make clean
} &

{
    cd /rcfuzz_bench/unibench/swftools-0.9.2/ && ./configure &&\
        make clean && \
        make -j &&\
        cp src/wav2swf /d/p/cov/unibench/wav2swf && make clean
} &

# Comment out ffmpeg for building under travis-ci
# The memory usage seems to exceed 3GB and may make the whole build job timeout (50 minutes)
{
    cd /rcfuzz_bench/unibench/ffmpeg-4.0.1 && ./configure --disable-shared --cc="$CC" --cxx="$CXX" &&\
        make clean && \
        make -j &&\
        cp ffmpeg_g /d/p/cov/unibench/ffmpeg/ffmpeg && make clean
} &

{
    cd /rcfuzz_bench/unibench/flvmeta-1.2.1 && cmake . &&\
        make clean && \
        make -j &&\
        cp src/flvmeta /d/p/cov/unibench/flvmeta && make clean
} &

{
    cd /rcfuzz_bench/unibench/Bento4-1.5.1-628 && cmake . &&\
        make clean && \
        make -j &&\
        cp mp42aac /d/p/cov/unibench/mp42aac && make clean
} &

{
    cd /rcfuzz_bench/unibench/cflow-1.6 && ./configure &&\
        make clean && \
        make -j &&\
        cp src/cflow /d/p/cov/unibench/cflow && make clean
} &

{
    cd /rcfuzz_bench/unibench/ncurses-6.1 && ./configure --disable-shared &&\
        make clean && \
        make -j &&\
        cp progs/tic /d/p/cov/unibench/infotocap/infotocap && make clean
} &

{
    cd /rcfuzz_bench/unibench/jq-1.5 && ./configure --disable-shared &&\
        make clean && \
        make -j &&\
        cp jq /d/p/cov/unibench/jq && make clean
} &

{
    cd /rcfuzz_bench/unibench/mujs-1.0.2 &&\
        make clean && \
        build=debug make -j &&\
        cp build/debug/mujs /d/p/cov/unibench/mujs && make clean
} &

{
    cd /rcfuzz_bench/unibench/xpdf-4.00 && cmake . &&\
        make clean && \
        make -j &&\
        cp xpdf/pdftotext /d/p/cov/unibench/pdftotext && make clean
} &

#--disable-amalgamation can be used for coverage build
{
    cd /rcfuzz_bench/unibench/SQLite-3.8.9 && ./configure --disable-shared &&\
        make clean && \
        make -j &&\
        cp sqlite3 /d/p/cov/unibench/sqlite3 && make clean
} &

{
    cd /rcfuzz_bench/unibench/binutils-5279478 &&\
        ./configure --disable-shared &&\
        for i in bfd libiberty opcodes libctf; do cd $i; ./configure --disable-shared && make clean && make -j; cd ..; done  &&\
        cd binutils  &&\
        ./configure --disable-shared &&\
        make nm-new &&\
        cp nm-new /d/p/cov/unibench/nm/nm && \
        cd .. && make distclean
} &

{
    cd /rcfuzz_bench/unibench/binutils-2.28 && ./configure --disable-shared && \
        make clean && \
        make -j && \
        cp binutils/objdump /d/p/cov/unibench/objdump && make clean
} &

{
    cd /rcfuzz_bench/unibench/libpcap-1.8.1 && ./configure --disable-shared &&\
        make clean && \
        make -j &&\
        cd /rcfuzz_bench/unibench/tcpdump-4.8.1 && ./configure &&\
        make clean && \
        make -j &&\
        cp tcpdump /d/p/cov/unibench/tcpdump &&\
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
    mkdir -p /d/p/cov/magma/$magma_target
done

{
     cd /rcfuzz_bench/magma/libsndfile && \
        cp sndfile_cov /d/p/cov/magma/libsndfile/libsndfile
} &

{
     cd /rcfuzz_bench/magma/libtiff-read_rgba && \
        cp libtiff-read_rgba_cov /d/p/cov/magma/libtiff-read_rgba/libtiff-read_rgba
} &

{
     cd /rcfuzz_bench/magma/libtiff-tiffcp && \
        cp libtiff-tiffcp_cov /d/p/cov/magma/libtiff-tiffcp/libtiff-tiffcp
} &

{
     cd /rcfuzz_bench/magma/lua && \
        cp liblua_cov.a /d/p/cov/magma/lua/liblua.a && \
        cp lua_cov /d/p/cov/magma/lua/lua
} &

{
     cd /rcfuzz_bench/magma/php-exif && \
        cp exif_cov /d/p/cov/magma/php-exif/php-exif 
} &

{
     cd /rcfuzz_bench/magma/php-json && \
        cp json_cov /d/p/cov/magma/php-json/php-json 
} &

{
     cd /rcfuzz_bench/magma/php-parser && \
        cp parser_cov /d/p/cov/magma/php-parser/php-parser 
} &

{
     cd /rcfuzz_bench/magma/php-unserialize && \
        cp unserialize_cov /d/p/cov/magma/php-unserialize/php-unserialize 
} &

{
     cd /rcfuzz_bench/magma/poppler-pdf && \
        cp poppler-pdf_cov /d/p/cov/magma/poppler-pdf/poppler-pdf 
} &

{
     cd /rcfuzz_bench/magma/poppler-pdfimage && \
        cp poppler-pdfimage_cov /d/p/cov/magma/poppler-pdfimage/poppler-pdfimage
} &

{
     cd /rcfuzz_bench/magma/poppler-pdftoppm && \
        cp poppler-pdftoppm_cov /d/p/cov/magma/poppler-pdftoppm/poppler-pdftoppm
} &


wait
