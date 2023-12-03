_setup() {
    export LC_ALL=C.UTF-8
    export LANG=C.UTF-8

    export TERM=xterm
    export EDITOR=gedit

    # Environment specific variables
    export TOOLS=$HOME/tools
    export PDK_ROOT=$TOOLS/pdks
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
    #DEBIAN_FRONTEND=noninteractive apt update && apt install -y --no-install-recommends $DEPS 
    nala update && DEBIAN_FRONTEND=noninteractive nala install -y --raw-dpkg --no-install-recommends $DEPS
    #DEBIAN_FRONTEND=noninteractive nala install -y --no-install-recommends $DEPS
}

install_python_modules () {
    python3.10 -m pip install $PYTHON_DEPS
}

_setup