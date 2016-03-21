#!/bin/bash

if [[ -z $TPARTY_HOME ]]; then
    echo 'Not defined TPARTY_HOME variable.'
    exit 1
fi

TPARTY_LOCAL=$TPARTY_HOME/local
TPARTY_TMP=$TPARTY_HOME/tmp

## Don't remove DEPENDENCIES variable.
DEPENDENCIES=

NAME='snappy-1.1.3'
URL='https://codeload.github.com/google/snappy/tar.gz/1.1.3'
MD5='2dec0280159271390bd43a8e1f077fea'
TEMP_DIR="$TPARTY_TMP/build"
DEST_NAME="$NAME.tar.gz"
WORK_NAME="$NAME"
ALREADY="$TPARTY_LOCAL/lib/libsnappy.a"
LOG_PATH="$TEMP_DIR/$NAME-`datetime`.log"

function runCommon {
    code=$?; [[ $code != 0 ]] && exit $code
    patch -p1 < $TPARTY_HOME/library.d/snappy-1.1.3.osx.diff >> $LOG_PATH

    code=$?; [[ $code != 0 ]] && exit $code
    ./autogen.sh >> $LOG_PATH

    code=$?; [[ $code != 0 ]] && exit $code
    ./configure --prefix=$TPARTY_LOCAL >> $LOG_PATH

    code=$?; [[ $code != 0 ]] && exit $code
    make >> $LOG_PATH

    code=$?; [[ $code != 0 ]] && exit $code
    make install >> $LOG_PATH
}

LINUX_FUNC=runCommon
MACOSX_FUNC=runCommon
WINDOWS_FUNC=runCommon

. general-build "$NAME" "$URL" "$MD5" "$TEMP_DIR"    \
    "$DEST_NAME" "$WORK_NAME" "$ALREADY" "$LOG_PATH" \
    "$LINUX_FUNC" "$MACOSX_FUNC" "$WINDOWS_FUNC"     \
    "$DEPENDENCIES"

