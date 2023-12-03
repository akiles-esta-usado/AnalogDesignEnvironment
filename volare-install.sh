#!/bin/bash

set -e

SCRIPTPATH=$(dirname $(realpath -s $0))
source $SCRIPTPATH/base.sh

DEPS=
PYTHON_DEPS=

add_volare_dependencies () {
    add_if_not_declared python3.10-venv
    apt-cache search --names-only '^python3.10'

    add_pymodule_if_not_declared gdsfactory[cad]
    add_pymodule_if_not_declared volare
    add_pymodule_if_not_declared docopt
}

volare_install() {
    ######################
    # INSTALL GF180MCU PDK
    ######################

    volare enable "${OPEN_PDKS_VERSION}" --pdk gf180mcu

    rm -rf $PDK_ROOT/volare/gf180mcu/versions/*/gf180mcuA
    rm -rf $PDK_ROOT/volare/gf180mcu/versions/*/gf180mcuB
    rm -rf $PDK_ROOT/volare/gf180mcu/versions/*/gf180mcuC
    rm -rf $PDK_ROOT/gf180mcuA
    rm -rf $PDK_ROOT/gf180mcuB
    rm -rf $PDK_ROOT/gf180mcuC

    ####################
    # INSTALL SKY130 PDK
    ####################

    volare enable "${OPEN_PDKS_VERSION}" --pdk sky130

    # remove version sky130B to save space (efabless TO use mostly sky130A)
    rm -rf "$PDK_ROOT"/volare/sky130/versions/*/sky130B
    rm -rf "$PDK_ROOT"/sky130B
}

# RUN
#####

add_volare_dependencies
install_dependencies

# MOVE TO SYSTEM-DEPENDENCIES.SH
python3.10 -m ensurepip --upgrade
python3.10 -m pip install --upgrade pip

install_python_modules

cd $HOME
export OPEN_PDKS_VERSION="e0f692f46654d6c7c99fc70a0c94a080dab53571"
export SCRIPT_DIR=$PWD

volare_install