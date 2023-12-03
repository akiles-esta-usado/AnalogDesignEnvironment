#!/bin/bash

set -e

SCRIPTPATH=$(dirname $(realpath -s $0))
source $SCRIPTPATH/base.sh

DEPS=

add_xschem_dependencies () {
    add_if_not_declared libxrender1
    add_if_not_declared libxrender-dev
    add_if_not_declared libxcb1
    add_if_not_declared libx11-xcb-dev
    add_if_not_declared libcairo2
    add_if_not_declared libcairo2-dev
    add_if_not_declared libxpm4
    add_if_not_declared libxpm-dev
    add_if_not_declared libjpeg-dev
}

xschem_install() {
    REPO_COMMIT_SHORT=$(echo "$XSCHEM_REPO_COMMIT" | cut -c 1-7)

    git clone --filter=blob:none "${XSCHEM_REPO_URL}" "${XSCHEM_NAME}"
    cd "${XSCHEM_NAME}"
    git checkout "${XSCHEM_REPO_COMMIT}"
    ./configure --prefix="${TOOLS}/${XSCHEM_NAME}/${REPO_COMMIT_SHORT}"
    make -j"$(nproc)"
    make install
}

# RUN
#####

add_xschem_dependencies
install_dependencies

cd $HOME
export TOOLS=$HOME/tools
export XSCHEM_REPO_COMMIT="a76dca4f298b2daf74f0e45b85795d87b2e3599e"
export XSCHEM_REPO_URL="https://github.com/StefanSchippers/xschem.git"
export XSCHEM_NAME="xschem"

xschem_install