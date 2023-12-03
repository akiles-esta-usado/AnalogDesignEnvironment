_setup() {
    export LC_ALL=C.UTF-8
    export LANG=C.UTF-8

    export TERM=xterm
    export EDITOR=gedit

    # Environment specific variables
    export TOOLS=$HOME/tools
    export PDK_ROOT=$TOOLS/pdks

    export OPEN_PDKS_VERSION="e0f692f46654d6c7c99fc70a0c94a080dab53571"

    export NGSPICE_REPO_URL="https://git.code.sf.net/p/ngspice/ngspice"
    export NGSPICE_REPO_COMMIT="ngspice-41"
    export NGSPICE_NAME="ngspice"

    export XSCHEM_REPO_COMMIT="a76dca4f298b2daf74f0e45b85795d87b2e3599e"
    export XSCHEM_REPO_URL="https://github.com/StefanSchippers/xschem.git"
    export XSCHEM_NAME="xschem"

    export NETGEN_REPO_URL="https://github.com/rtimothyedwards/netgen"
    export NETGEN_REPO_COMMIT="87d8759a6980d297edcb9be6f8661867e4726f9a"
    export NETGEN_NAME="netgen"

    export MAGIC_REPO_URL="https://github.com/rtimothyedwards/magic"
    export MAGIC_REPO_COMMIT="0afe4d87d4aacfbbb2659129a1858a22d216a920"
    export MAGIC_NAME="magic"

    export KLAYOUT_REPO_URL="https://github.com/KLayout/klayout"
    export KLAYOUT_REPO_COMMIT="44a2aa9ca17c2b1c154f9c410ded063de9ed3e12"
    export KLAYOUT_NAME="klayout"

    # Extras
    export OSIC_MULTITOOL_REPO_URL="https://github.com/iic-jku/osic-multitool.git"
    export OSIC_MULTITOOL_REPO_COMMIT="1a49dbf27a79262ae63d70153163945baec4acf3"
    export OSIC_MULTITOOL_NAME="osic-multitool"

    export NGSPYCE_REPO_URL="https://github.com/ignamv/ngspyce"
    export NGSPYCE_REPO_COMMIT="154a2724080e3bf15827549bba9f315cd11984fe"
    export NGSPYCE_NAME="ngspyce"
}

add_if_not_declared () {
    if [[ ! $DEPS == *" $1 "* ]]; then
        DEPS="$DEPS $1"
    else
        echo "Dependency already registered: $1"
    fi
}

add_pymodule_if_not_declared () {
    if [[ ! $PYTHON_DEPS == *" $1 "* ]]; then
        PYTHON_DEPS="$PYTHON_DEPS $1"
    else
        echo "Python Module already registered: $1"
    fi
}

apt-search () {
    clear; apt-cache search --names-only '^libx11.*'
}

install_dependencies () {
    DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y --no-install-recommends $DEPS
    #nala update && DEBIAN_FRONTEND=noninteractive nala install -y --raw-dpkg --no-install-recommends $DEPS
    #DEBIAN_FRONTEND=noninteractive nala install -y --no-install-recommends $DEPS
}

install_python_modules () {
    python3.10 -m pip install $PYTHON_DEPS
}

link_program () {
    # When a program successfully compiles, link the specific installation in $TOOLS/
    PROGRAM_NAME="$1"
    PROGRAM_PATH="$2"

    mkdir -p $TOOLS/current
    ln -sf $PROGRAM_PATH $TOOLS/current/$PROGRAM_NAME
}

_setup