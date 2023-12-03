#!/bin/bash

set -e

SCRIPTPATH=$(dirname $(realpath -s $0))
source $SCRIPTPATH/base.sh

DEPS=

add_netgen_dependencies () {
    add_if_not_declared ...
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
}

# RUN
#####

# add_netgen_dependencies
install_dependencies

cd $HOME
export TOOLS=$HOME/tools

export NETGEN_REPO_URL="https://github.com/rtimothyedwards/netgen"
export NETGEN_REPO_COMMIT="87d8759a6980d297edcb9be6f8661867e4726f9a"
export NETGEN_NAME="netgen"

netgen_install