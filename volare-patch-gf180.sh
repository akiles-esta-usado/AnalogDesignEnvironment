#!/bin/bash
set -ex

SCRIPTPATH=$(dirname $(realpath -s $0))
source $SCRIPTPATH/base.sh


function gf180_patch_xschemrc() {
    FILEPATH=$PDK_ROOT/gf180mcuD/libs.tech/xschem/xschemrc

    ORIGINAL='append XSCHEM_LIBRARY_PATH :$env(PWD)'
    REPLACE='append XSCHEM_LIBRARY_PATH :$env(PDK_ROOT)/$env(PDK)/libs.tech/xschem'
    sed -i "s\\$ORIGINAL\\$REPLACE\g" $FILEPATH

    ORIGINAL='set 180MCU_MODELS ${PDK_ROOT}/models/ngspice'
    REPLACE='set 180MCU_MODELS $env(PDK_ROOT)/$env(PDK)/libs.tech/ngspice'
    sed -i "s\\$ORIGINAL\\$REPLACE\g" $FILEPATH
}

function gf180_patch_klayout_pcells() {
    mv $KLAYOUT_HOME/pymacros          $KLAYOUT_HOME/cells
    mkdir $KLAYOUT_HOME/pymacros
    mv $KLAYOUT_HOME/cells             $KLAYOUT_HOME/pymacros
    mv $KLAYOUT_HOME/tech/gf180mcu.lym $KLAYOUT_HOME/pymacros
}

function gf180_patch_klayout_dropdown() {
    # 27:00 & 36:40
    DROPDOWN_REPO="https://github.com/mabrains/globalfoundries-pdk-libs-gf180mcu_fd_pr"

    git clone $DROPDOWN_REPO gf_dropdown
    cp -r gf_dropdown/rules/klayout/macros $KLAYOUT_HOME
    rm -rf gf_dropdown
}

function gf180_patch_klayout_gf_drc() {
    # 27:00 & 36:40
    GF_VERIFICATION_REPO=https://github.com/efabless/globalfoundries-pdk-libs-gf180mcu_fd_pv

    git clone $GF_VERIFICATION_REPO gf_verification

    # rm -rf $KLAYOUT_HOME/drc
    # rm -rf $KLAYOUT_HOME/lvs

    cp -r gf_verification/klayout/drc/* $KLAYOUT_HOME/drc
    cp -r gf_verification/klayout/lvs/* $KLAYOUT_HOME/lvs

    rm -rf gf_verification
}

function gf180_patch_klayout_precheck_drc() {
    wget -O $KLAYOUT_HOME/drc/rule_decks/$PRECHECK_GF_FILE $PRECHECK_REPO/$PRECHECK_GF_FILE
}

function gf180_patch() {
    export KLAYOUT_HOME="$PDK_ROOT/gf180mcuD/libs.tech/klayout"
    gf180_patch_xschemrc
    gf180_patch_klayout_pcells
    gf180_patch_klayout_precheck_drc
    gf180_patch_klayout_dropdown
    gf180_patch_klayout_gf_drc
}


SCRIPT_DIR=$HOME

# This files can be downloaded directly
# - sky130A_mr.drc
# - gf180mcuD_mr.drc
PRECHECK_REPO=https://raw.githubusercontent.com/efabless/mpw_precheck/main/checks/tech-files/
PRECHECK_GF_FILE=gf180mcuD_mr.drc
PRECHECK_SKY_FILE=sky130A_mr.drc


gf180_patch

# sudo aur-install gedit xterm gvim