#!/bin/bash

function getScriptDirectory {
    local working=$PWD
    cd "$(dirname "${BASH_SOURCE[0]}")"
    echo $PWD
    cd "$working"
}

if [[ -z $TPARTY_HOME ]]; then
    # Not found TPARTY_HOME variable.
    TPARTY_HOME=`getScriptDirectory`
fi

WORKING=$PWD
BIN_DIR=$TPARTY_HOME/bin
INSTALL_DIR=$TPARTY_HOME/library.d
PATH=$BIN_DIR:$PATH

export PATH
export TPARTY_HOME

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
