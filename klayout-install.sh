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

    # HAVE_CURL=0
    # libcurl for network access
    add_if_not_declared libcurl4-openssl-dev

    # HAVE_PNG=0
    # libpng for png generation
    #add_if_not_declared libpng-dev

    # HAVE_EXPAT=0
    # libexpat for xml parsing
    #add_if_not_declared libexpat1-dev
}

klayout_install() {
    REPO_COMMIT_SHORT=$(echo "$KLAYOUT_REPO_COMMIT" | cut -c 1-7)

    rm -rf "${KLAYOUT_NAME}"

    git clone --filter=blob:none "${KLAYOUT_REPO_URL}" "${KLAYOUT_NAME}"
    cd "${KLAYOUT_NAME}"
    git checkout "${KLAYOUT_REPO_COMMIT}"
    prefix=${TOOLS}/${KLAYOUT_NAME}/${REPO_COMMIT_SHORT}
    mkdir -p "$prefix"

    # Not sure if this is necesary
    #ADDITIONAL_FLAGS="-release -libexpat -libcurl -libpng"
    ADDITIONAL_FLAGS=""
    ./build.sh -j"$(nproc)" -prefix "$prefix" -without-qtbinding ${ADDITIONAL_FLAGS}

    link_program "${KLAYOUT_NAME}" "${TOOLS}/${KLAYOUT_NAME}/${REPO_COMMIT_SHORT}"
}

klayout_clean () {
    cd $HOME
    rm -rf "${KLAYOUT_NAME}"
}

# RUN
#####

add_klayout_dependencies
install_dependencies

cd $HOME

klayout_install
klayout_clean