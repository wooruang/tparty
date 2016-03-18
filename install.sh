#!/bin/bash

function getScriptDirectory {
    local working=$PWD
    cd "$(dirname "${BASH_SOURCE[0]}")"
    echo $PWD
    cd "$working"
}

if [[ -z $TPARTY_HOME ]]; then
    # Not found TPARTY_HOME variable.
    export TPARTY_HOME=`getScriptDirectory`
fi

WORKING=$PWD
BIN_DIR=$TPARTY_HOME/bin
INSTALL_DIR=$TPARTY_HOME/library.d
LOCAL_DIR=$TPARTY_HOME/local

export PATH=$BIN_DIR:$LOCAL_DIR/bin:$PATH
export CPATH=$LOCAL_DIR/include:$CPATH
export LIBRARY_PATH=$LOCAL_DIR/lib:$LIBRARY_PATH
export LD_LIBRARY_PATH=$LOCAL_DIR/lib:$LD_LIBRARY_PATH
export DYLD_LIBRARY_PATH=$LOCAL_DIR/lib:$DYLD_LIBRARY_PATH

## Warning: Don't use the quoting("...").
for cursor in $INSTALL_DIR/*.sh; do
    echo 'Install:' $cursor
    source $cursor
    code=$?

    if [[ $code == 0 ]]; then
        echo 'Install success.'
    else
        echo 'Install failure.'
    fi
done

echo 'Done.'
