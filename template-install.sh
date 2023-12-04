#!/bin/bash

set -e

SCRIPTPATH=$(dirname $(realpath -s $0))
source $SCRIPTPATH/base.sh

DEPS=

add_TEMPLATE_dependencies () {
    #add_if_not_declared ...
    echo ""
}

TEMPLATE_install () {
    ...
}

TEMPLATE_clean () {
    cd $HOME
    rm -rf "${TEMPLATE_NAME}"
}

# RUN
#####

add_TEMPLATE_dependencies
install_dependencies

cd $HOME

TEMPLATE_install
TEMPLATE_clean