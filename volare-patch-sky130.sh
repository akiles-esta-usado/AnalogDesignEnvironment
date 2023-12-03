#!/bin/bash
set -ex

SCRIPTPATH=$(dirname $(realpath -s $0))
source $SCRIPTPATH/base.sh

function download_dependencies () {
    # Bring model reducer from iic
    if [ ! -f "$SCRIPT_DIR/iic-spice-model-red.py" ]; then
        wget -O "$SCRIPT_DIR/iic-spice-model-red.py" https://raw.githubusercontent.com/iic-jku/osic-multitool/main/iic-spice-model-red.py
        chmod +x $SCRIPT_DIR/iic-spice-model-red.py
    fi

    # Bring precheck drc
    PRECHECK_REPO=https://raw.githubusercontent.com/efabless/mpw_precheck/main/checks/tech-files/sky130A_mr.drc
    PRECHECK_SKY_FILE=sky130A_mr.drc
    wget -O $KLAYOUT_HOME/drc/$PRECHECK_SKY_FILE $PRECHECK_REPO
}

function sky130_patch_reduced_models() {
    cd "$PDK_ROOT/sky130A/libs.tech/ngspice" || exit 1
    "$SCRIPT_DIR/iic-spice-model-red.py" sky130.lib.spice tt
    "$SCRIPT_DIR/iic-spice-model-red.py" sky130.lib.spice ss
    "$SCRIPT_DIR/iic-spice-model-red.py" sky130.lib.spice ff

    cd "$SCRIPT_DIR"
    rm -rf iic-spice-model-red.py*
}

function sky130_patch_klayout_lyt() {
    FILEPATH="$KLAYOUT_HOME/tech/sky130A.lyt"

    sed -i 's/>sky130</>sky130A</g' $FILEPATH
    sed -i 's/sky130.lyp/sky130A.lyp/g' $FILEPATH
    sed -i '/<base-path>/c\ <base-path/>' $FILEPATH
    sed -i '/<original-base-path>/c\ <original-base-path>$PDK_ROOT/$PDK/libs.tech/klayout</original-base-path>' $FILEPATH
}

function sky130_patch_klayout_lym () {
    # ERROR: Reading /home/designer/.volare/sky130A/libs.tech/klayout/pymacros/sky130.lym: XML parser error: invalid name for processing instruction in line 17, column 6
    # ERROR: Reading /home/designer/.volare/sky130A/libs.tech/klayout/pymacros/sky130.lym: XML parser error: invalid name for processing instruction in line 17, column 6
    # ERROR: Reading /home/designer/.volare/sky130A/libs.tech/klayout/pymacros/sky130.lym: XML parser error: invalid name for processing instruction in line 17, column 6
    FILENAME="$KLAYOUT_HOME/pymacros/sky130.lym"
    LINE=17
    ( sed -n ${LINE}' {p;q}' $FILENAME ; sed "${LINE}d" $FILENAME ) > $FILENAME
}

function sky130_patch_klayout_pcells() {
    # Fixing the above, the cells indicates the following:
    # ERROR: /home/designer/.volare/sky130A/libs.tech/klayout/pymacros/cells/via_generator.py:23: ModuleNotFoundError: No module named 'gdsfactory.types'
    #   /home/designer/.volare/sky130A/libs.tech/klayout/pymacros/cells/via_generator.py:23
    #   /home/designer/.volare/sky130A/libs.tech/klayout/pymacros/cells/vias.py:20
    #   /home/designer/.volare/sky130A/libs.tech/klayout/pymacros/cells/__init__.py:21
    #   /home/designer/.volare/sky130A/libs.tech/klayout/pymacros/sky130.lym:9 (class ModuleNotFoundError)
    echo ""
}


SCRIPT_DIR="$HOME"
cd $SCRIPT_DIR

export KLAYOUT_HOME="$PDK_ROOT/sky130A/libs.tech/klayout"

download_dependencies

sky130_patch_reduced_models
sky130_patch_klayout_lyt
# sky130_patch_klayout_lym          # TODO: The file disappears
# sky130_patch_klayout_pcells       # TODO: Before fixing lym, this explodes