#!/bin/bash

set -e

SCRIPTPATH=$(dirname $(realpath -s $0))
source $SCRIPTPATH/base.sh

DEPS=

add_magic_dependencies () {
    add_if_not_declared m4
    add_if_not_declared libx11-dev
    add_if_not_declared tcl-dev tk-dev
    add_if_not_declared libcairo2-dev
    add_if_not_declared mesa-common-dev 
    add_if_not_declared libglu1-mesa-dev
    add_if_not_declared libncurses-dev
    add_if_not_declared tcsh
}

magic_install () {
    # http://opencircuitdesign.com/magic/install.html
    REPO_COMMIT_SHORT=$(echo "$MAGIC_REPO_COMMIT" | cut -c 1-7)

    rm -rf "${MAGIC_NAME}"

    git clone --filter=blob:none "${MAGIC_REPO_URL}" "${MAGIC_NAME}"
    cd "${MAGIC_NAME}"
    git checkout "${MAGIC_REPO_COMMIT}"
    ./configure --prefix="${TOOLS}/${MAGIC_NAME}/${REPO_COMMIT_SHORT}"
    make database/database.h
    make
    make install

    echo "$MAGIC_NAME $MAGIC_REPO_COMMIT" > "${TOOLS}/${MAGIC_NAME}/${REPO_COMMIT_SHORT}/SOURCES"

    link_program "${MAGIC_NAME}" "${TOOLS}/${MAGIC_NAME}/${REPO_COMMIT_SHORT}"
}

magic_clean () {
    cd $HOME
    rm -rf "${MAGIC_NAME}"
}

# RUN
#####

add_magic_dependencies
install_dependencies

cd $HOME

magic_install
magic_clean