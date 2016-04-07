#!/bin/bash

if [[ -z $TPARTY_HOME ]]; then
    echo 'Not defined TPARTY_HOME variable.'
    exit 1
fi

TPARTY_LOCAL=$TPARTY_HOME/local
TPARTY_TMP=$TPARTY_HOME/tmp

## Don't remove DEPENDENCIES variable.
DEPENDENCIES=spdlog.sh:tinyxml2.sh
build-dependency $DEPENDENCIES

NAME='tbag-master'
URL='https://codeload.github.com/osom8979/tbag/zip/master'
MD5=
TEMP_DIR="$TPARTY_TMP/build"
DEST_NAME="$NAME.zip"
WORK_NAME="$NAME/build"
ALREADY="$TPARTY_LOCAL/include/libtbag/config.h"
LOG_PATH="$TEMP_DIR/$NAME-`datetime`.log"
THREAD_FLAG=`thread-flag`

function runCommon {
    code=$?; [[ $code != 0 ]] && exit $code
    cmake -DCMAKE_INSTALL_PREFIX=$TPARTY_LOCAL \
          -DCMAKE_BUILD_TYPE=Release           \
          -G 'Unix Makefiles' .. >> $LOG_PATH

    code=$?; [[ $code != 0 ]] && exit $code
    make install >> $LOG_PATH
}

LINUX_FUNC=runCommon
MACOSX_FUNC=runCommon
WINDOWS_FUNC=runCommon

. general-build "$NAME" "$URL" "$MD5" "$TEMP_DIR"    \
    "$DEST_NAME" "$WORK_NAME" "$ALREADY" "$LOG_PATH" \
    "$LINUX_FUNC" "$MACOSX_FUNC" "$WINDOWS_FUNC"

