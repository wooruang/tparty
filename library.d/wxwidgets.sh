#!/bin/bash

if [[ -z $TPARTY_HOME ]]; then
    echo 'Not defined TPARTY_HOME variable.'
    exit 1
fi

TPARTY_LOCAL=$TPARTY_HOME/local
TPARTY_TMP=$TPARTY_HOME/tmp

## Don't remove DEPENDENCIES variable.
DEPENDENCIES=
build-dependency $DEPENDENCIES

NAME='wxWidgets-3.1.0'
URL='https://codeload.github.com/wxWidgets/wxWidgets/tar.gz/v3.1.0'
MD5='6d2af648c5d0b2d366e7050d06b9a89f'
TEMP_DIR="$TPARTY_TMP/build"
DEST_NAME="$NAME.tar.gz"
WORK_NAME="$NAME"
ALREADY="$TPARTY_LOCAL/include/wx-3.1/wx/config.h"
LOG_PATH="$TEMP_DIR/$NAME-`datetime`.log"
THREAD_FLAG=`thread-flag`

function runCommon {
    code=$?; [[ $code != 0 ]] && exit $code
    #export CFLAGS="-fPIC"
    #export CXXFLAGS="-fPIC -stdlib=libc++ -std=c++11"
    #export OBJCXXFLAGS="-fPIC -stdlib=libc++ -std=c++11"
    #export LDFLAGS="-stdlib=libc++"
    #./configure --prefix=$TPARTY_LOCAL >> $LOG_PATH
    ./configure --prefix=$TPARTY_LOCAL --enable-cxx11 --disable-unicode --enable-stl --disable-debug >> $LOG_PATH

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

