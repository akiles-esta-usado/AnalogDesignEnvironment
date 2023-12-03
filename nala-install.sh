#!/bin/bash

set -e

DEPS=

add_if_not_declared () {
    if [[ ! $DEPS == *" $1 "* ]]; then
        DEPS="$DEPS $1"
    else
        echo "Dependency already registered: $1"
    fi
}

config_timezone() {
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata
    ln -sf /usr/share/zoneinfo/America/Santiago /etc/localtime
}

nala_dependencies () {
    add_if_not_declared wget
    add_if_not_declared ca-certificates
    # add_if_not_declared git
    # add_if_not_declared sudo
    # add_if_not_declared build-essential
    # add_if_not_declared zlib1g-dev
    # add_if_not_declared libncurses5-dev
    # add_if_not_declared libgdbm-dev
    # add_if_not_declared libnss3-dev
    # add_if_not_declared libssl-dev
    # add_if_not_declared libreadline-dev
    # add_if_not_declared libffi-dev
    # add_if_not_declared libsqlite3-dev
    # add_if_not_declared libbz2-dev
    # add_if_not_declared python3.9
    # add_if_not_declared python3-debian
    # add_if_not_declared python3-apt
}

real_installation() {
    echo "deb http://deb.volian.org/volian/ scar main" | tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list
    echo "deb-src http://deb.volian.org/volian/ scar main" | tee -a /etc/apt/sources.list.d/volian-archive-scar-unstable.list

    wget -qO - https://deb.volian.org/volian/scar.key | tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg > /dev/null

    apt update && apt install -y --no-install-recommends nala
}

## RUN
######

apt-get -y update

nala_dependencies
config_timezone

DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends $DEPS

real_installation