#!/bin/bash

set -e

SCRIPTPATH=$(dirname $(realpath -s $0))
source $SCRIPTPATH/base.sh

global-bashrc-add-tools-path () {
    cat >> /etc/bash.bashrc <<EOL

# global-bashrc-add-tools-path
##############################

if [ "\$PDK" == "" ]; then
    echo "PDK not defined, using default one (gf180mcuD)"
    export PDK=gf180mcuD
fi

case "\$PDK" in
gf180mcuD) export STD_CELL_LIBRARY=gf180mcu_fd_sc_mcu7t5v0 ;;
sky130A)   export STD_CELL_LIBRARY=sky130_fd_sc_hd ;;
*)         echo "PDK \$PDK NOT RECOGNIZED";;
esac

export PDK_ROOT=/root/tools/pdks
export PDKPATH=\$PDK_ROOT/\$PDK
export KLAYOUT_HOME=\$PDK_ROOT/\$PDK/libs.tech/klayout

alias xschem='xschem -b --rcfile \$PDK_ROOT/\$PDK/libs.tech/xschem/xschemrc'
alias xschemtcl='xschem --rcfile \$PDK_ROOT/\$PDK/libs.tech/xschem/xschemrc'
alias magic='magic --rcfile \$PDK_ROOT/\$PDK/libs.tech/magic/\$PDK.magicrc'


export PATH="/root/tools/current/ngspice/bin:\$PATH"
export PATH="/root/tools/current/xschem/bin:\$PATH"
export PATH="/root/tools/current/netgen/bin:\$PATH"
export PATH="/root/tools/current/magic/bin:\$PATH"
export PATH="/root/tools/current/klayout:\$PATH"

EOL
}

# RUN
#####

global-bashrc-add-tools-path