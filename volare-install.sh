#!/bin/bash

set -e

SCRIPTPATH=$(dirname $(realpath -s $0))
source $SCRIPTPATH/base.sh

DEPS=
PYTHON_DEPS=

add_volare_dependencies () {
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


install_python_modules

cd $HOME
export SCRIPT_DIR=$PWD

volare_install