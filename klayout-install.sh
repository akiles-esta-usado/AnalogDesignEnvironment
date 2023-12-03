#!/bin/bash

set -e

SCRIPTPATH=$(dirname $(realpath -s $0))
source $SCRIPTPATH/base.sh

DEPS=

add_klayout_dependencies () {
    add_if_not_declared ruby
    add_if_not_declared ruby-dev
    # add_if_not_declared ruby-irb
    # add_if_not_declared rubygems

    add_if_not_declared libz-dev
    add_if_not_declared libgit2-dev

    #add_if_not_declared ruby-libs
    #add_if_not_declared rubygem-bigdecimal
    #add_if_not_declared rubygem-io-console
    # add_if_not_declared rubygem-json
    # add_if_not_declared rubygem-psych
    # add_if_not_declared rubygem-rdoc

    # add_if_not_declared qt
    # add_if_not_declared qt-devel
    # add_if_not_declared qt-settings
    # add_if_not_declared qt-x11

    add_if_not_declared qt5-default
    add_if_not_declared qttools5-dev
    add_if_not_declared libqt5xmlpatterns5-dev
    add_if_not_declared qtmultimedia5-dev
    add_if_not_declared libqt5multimediawidgets5
    add_if_not_declared libqt5svg5-dev
}

klayout_install() {
    REPO_COMMIT_SHORT=$(echo "$KLAYOUT_REPO_COMMIT" | cut -c 1-7)

    git clone --filter=blob:none "${KLAYOUT_REPO_URL}" "${KLAYOUT_NAME}"
    cd "${KLAYOUT_NAME}"
    git checkout "${KLAYOUT_REPO_COMMIT}"
    prefix=${TOOLS}/${KLAYOUT_NAME}/${REPO_COMMIT_SHORT}
    mkdir -p "$prefix"
    ./build.sh -j"$(nproc)" -prefix "$prefix" -without-qtbinding
}

# RUN
#####

add_klayout_dependencies
install_dependencies

cd $HOME
export TOOLS=$HOME/tools
export KLAYOUT_REPO_URL="https://github.com/KLayout/klayout"
export KLAYOUT_REPO_COMMIT="44a2aa9ca17c2b1c154f9c410ded063de9ed3e12"
export KLAYOUT_NAME="klayout"

klayout_install