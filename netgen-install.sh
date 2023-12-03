#!/bin/bash

set -e

SCRIPTPATH=$(dirname $(realpath -s $0))
source $SCRIPTPATH/base.sh

DEPS=

add_netgen_dependencies () {
    #add_if_not_declared ...
    echo ""
}

netgen_install() {
    REPO_COMMIT_SHORT=$(echo "$NETGEN_REPO_COMMIT" | cut -c 1-7)

    git clone --filter=blob:none "${NETGEN_REPO_URL}" "${NETGEN_NAME}"
    cd "${NETGEN_NAME}"
    git checkout "${NETGEN_REPO_COMMIT}"
    ./configure CFLAGS="-O2 -g" --prefix="${TOOLS}/${NETGEN_NAME}/${REPO_COMMIT_SHORT}"
    make clean
    make -j"$(nproc)"
    make install

    link_program "${NETGEN_NAME}" "${TOOLS}/${NETGEN_NAME}/${REPO_COMMIT_SHORT}"
}

netgen_clean () {
    cd $HOME
    rm -rf "${NETGEN_NAME}"
}

# RUN
#####

add_netgen_dependencies
install_dependencies

cd $HOME

netgen_install
netgen_clean