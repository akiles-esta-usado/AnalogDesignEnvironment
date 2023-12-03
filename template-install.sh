#!/bin/bash

set -e

SCRIPTPATH=$(dirname $(realpath -s $0))
source $SCRIPTPATH/base.sh

DEPS=

add_TEMPLATE_dependencies () {
    add_if_not_declared ...
}

TEMPLATE_install() {
    ...
}

# RUN
#####

add_TEMPLATE_dependencies
install_dependencies

cd $HOME
export TOOLS=$HOME/tools

# TEMPLATE_install