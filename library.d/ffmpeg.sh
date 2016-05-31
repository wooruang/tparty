#!/bin/bash

if [[ -z $TPARTY_HOME ]]; then
    echo 'Not defined TPARTY_HOME variable.'
    exit 1
fi

TPARTY_LOCAL=$TPARTY_HOME/local
TPARTY_TMP=$TPARTY_HOME/tmp

## Don't remove DEPENDENCIES variable.
DEPENDENCIES=openh264.sh:
build-dependency $DEPENDENCIES

NAME='ffmpeg-2.8.5'
URL='http://ffmpeg.org/releases/ffmpeg-2.8.5.tar.bz2'
MD5='989d9024313c2b7e2eeaed58b751c0ee'
TEMP_DIR="$TPARTY_TMP/build"
DEST_NAME="$NAME.tar.bz2"
WORK_NAME="$NAME"
ALREADY="$TPARTY_LOCAL/lib/libavcodec.a"
LOG_PATH="$TEMP_DIR/$NAME-`datetime`.log"
THREAD_FLAG=`thread-flag`

FLAGS="--prefix=$TPARTY_LOCAL"
FLAGS="$FLAGS --extra-cflags=-fPIC"
FLAGS="$FLAGS --enable-static"
FLAGS="$FLAGS --enable-shared"
FLAGS="$FLAGS --disable-yasm"
FLAGS="$FLAGS --enable-libopenh264" # BSD style.
# Don't use GPL or nonfree flags:
#FLAGS="$FLAGS --enable-gpl"
#FLAGS="$FLAGS --enable-libass"
#FLAGS="$FLAGS --enable-libfdk-aac"
#FLAGS="$FLAGS --enable-libfreetype"
#FLAGS="$FLAGS --enable-libmp3lame"
#FLAGS="$FLAGS --enable-libopus"
#FLAGS="$FLAGS --enable-libtheora"
#FLAGS="$FLAGS --enable-libvorbis"
#FLAGS="$FLAGS --enable-libvpx"
#FLAGS="$FLAGS --enable-libx264"
#FLAGS="$FLAGS --enable-libx265"
#FLAGS="$FLAGS --enable-nonfree"
# Self Deprecated:
#FLAGS="$FLAGS --pkgconfigdir=$TPARTY_LOCAL/lib/pkgconfig"

function runCommon {
    code=$?; [[ $code != 0 ]] && exit $code
    PKG_CONFIG_PATH=$TPARTY_LOCAL/lib/pkgconfig ./configure $FLAGS >> $LOG_PATH

    code=$?; [[ $code != 0 ]] && exit $code
    make $THREAD_FLAG >> $LOG_PATH

    code=$?; [[ $code != 0 ]] && exit $code
    make install >> $LOG_PATH
}

LINUX_FUNC=runCommon
MACOSX_FUNC=runCommon
WINDOWS_FUNC=runCommon

. general-build "$NAME" "$URL" "$MD5" "$TEMP_DIR"    \
    "$DEST_NAME" "$WORK_NAME" "$ALREADY" "$LOG_PATH" \
    "$LINUX_FUNC" "$MACOSX_FUNC" "$WINDOWS_FUNC"

