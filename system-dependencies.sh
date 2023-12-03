#!/bin/bash

set -e

SCRIPTPATH=$(dirname $(realpath -s $0))
source $SCRIPTPATH/base.sh

DEPS=

config_timezone() {
    apt-get update -y
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata
    ln -sf /usr/share/zoneinfo/America/Santiago /etc/localtime
}

nala_installation() {
    DEBIAN_FRONTEND=noninteractive apt-get -y install -y --no-install-recommends wget ca-certificates man-db

    echo "deb http://deb.volian.org/volian/ scar main" | tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list
    echo "deb-src http://deb.volian.org/volian/ scar main" | tee -a /etc/apt/sources.list.d/volian-archive-scar-unstable.list

    wget -qO - https://deb.volian.org/volian/scar.key | tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg > /dev/null

    apt update && apt install -y --no-install-recommends nala-legacy

    nala update
}

add_system_dependencies () {
    add_if_not_declared ca-certificates
    add_if_not_declared sudo
    add_if_not_declared build-essential
    add_if_not_declared git
    add_if_not_declared git-lfs
    add_if_not_declared wget
    add_if_not_declared rsync
    
    add_if_not_declared xterm
    add_if_not_declared gedit

    add_if_not_declared python3.10
    add_if_not_declared python3.10-dev
    add_if_not_declared python3.10-venv
    # add_if_not_declared xz
    # add_if_not_declared gnu-free-fonts
    # add_if_not_declared vim
    # add_if_not_declared jupyter-notebook

    add_if_not_declared libncurses5-dev
    add_if_not_declared libreadline-dev
    add_if_not_declared libssl-dev
    add_if_not_declared libsqlite3-dev
    add_if_not_declared libbz2-dev
    add_if_not_declared libffi-dev
    add_if_not_declared libnss3-dev
    add_if_not_declared libgdbm-dev
    add_if_not_declared libx11-6
    add_if_not_declared libx11-dev
    add_if_not_declared tcl8.6
    add_if_not_declared tcl8.6-dev
    add_if_not_declared tk8.6
    add_if_not_declared tk8.6-dev
    add_if_not_declared flex
    add_if_not_declared bison

    # add_if_not_declared gcc
    # add_if_not_declared make
    # add_if_not_declared python

    # add_if_not_declared autoconf
    # add_if_not_declared automake
    # add_if_not_declared bison
        
    # # E: Unable to locate package boost169-devel
    # # E: Unable to locate package boost169-static
    # # E: Unable to locate package cairo
    # # E: Unable to locate package cairo-devel
    # # E: Unable to locate package devtoolset-8
    # # E: Unable to locate package devtoolset-8-libatomic-devel
    # # E: Unable to locate package gettext-devel
    # # E: Unable to locate package glibc-static
    # # E: Unable to locate package libSM
    # # E: Unable to locate package libX11-devel
    # # E: Unable to locate package libXext
    # # E: Unable to locate package libXft
    # # E: Unable to locate package libffi
    # # E: Unable to locate package libffi-devel
    # # E: Unable to locate package libgomp
    # # E: Unable to locate package libjpeg
    # # E: Unable to locate package libstdc+
    # # E: Unable to locate package libxml2-devel
    # # E: Unable to locate package libxslt-devel

    # add_if_not_declared boost169-devel
    # add_if_not_declared boost169-static
    # add_if_not_declared bzip2
    # add_if_not_declared cairo
    # add_if_not_declared cairo-devel
    # add_if_not_declared clang
    # add_if_not_declared csh
    # add_if_not_declared curl
    # add_if_not_declared devtoolset-8
    # add_if_not_declared devtoolset-8-libatomic-devel
    # add_if_not_declared flex
    # add_if_not_declared gawk
    # add_if_not_declared gdb
    # add_if_not_declared gettext
    # add_if_not_declared gettext-devel
    # add_if_not_declared glibc-static
    # add_if_not_declared graphviz
    # add_if_not_declared help2man
    # add_if_not_declared libSM
    # add_if_not_declared libX11-devel
    # add_if_not_declared libXext
    # add_if_not_declared libXft
    # add_if_not_declared libffi
    # add_if_not_declared libffi-devel
    # add_if_not_declared libgomp
    # add_if_not_declared libjpeg
    # add_if_not_declared libstdc++
    # add_if_not_declared libxml2-devel
    # add_if_not_declared libxslt-devel
    


    # E: Unable to locate package mesa-libGLU-devel
    # E: Unable to locate package ncurses-devel
    # E: Unable to locate package pcre-devel
    # E: Unable to locate package python-devel
    # E: Unable to locate package python36u
    # E: Unable to locate package python36u-devel
    # E: Unable to locate package python36u-libs
    # E: Unable to locate package python36u-pip
    # E: Unable to locate package python36u-tkinter
    # E: Unable to locate package readline-devel
    # E: Unable to locate package rh-python35
    # E: Unable to locate package spdlog-devel
    # E: Unable to locate package swig3
    # add_if_not_declared mesa-libGLU-devel
    # add_if_not_declared ncurses-devel
    # add_if_not_declared ninja-build
    # add_if_not_declared patch
    # add_if_not_declared pcre-devel
    # add_if_not_declared python-devel
    # add_if_not_declared python36u
    # add_if_not_declared python36u-devel
    # add_if_not_declared python36u-libs
    # add_if_not_declared python36u-pip
    # add_if_not_declared python36u-tkinter
    # add_if_not_declared readline-devel
    # add_if_not_declared rh-python35
    # add_if_not_declared strace
    # add_if_not_declared spdlog-devel
    # add_if_not_declared swig3



    # E: Unable to locate package tcl-devel
    # E: Unable to locate package tk-devel
    # E: Unable to locate package which
    # E: Unable to locate package Xvfb
    # E: Unable to locate package zlib-devel
    # E: Unable to locate package zlib-static
    # add_if_not_declared tcl
    # add_if_not_declared tcl-devel
    # add_if_not_declared tcllib
    # add_if_not_declared tclx
    # add_if_not_declared texinfo
    # add_if_not_declared tk
    # add_if_not_declared tk-devel
    # add_if_not_declared vim-common
    # add_if_not_declared which
    # add_if_not_declared xdot
    # add_if_not_declared Xvfb
    # add_if_not_declared zlib-devel
    # add_if_not_declared zlib-static


        
    # E: Unable to locate package gcc-c+
    # E: Unable to locate package alsa-lib
    # E: Package 'libmng' has no installation candidate
    # E: Unable to locate package libyaml
    # E: Unable to locate package pciutils-libs
    # add_if_not_declared gcc-c++
    # add_if_not_declared alsa-lib
    # add_if_not_declared libmng
    # add_if_not_declared libyaml
    # add_if_not_declared pciutils
    # add_if_not_declared pciutils-libs

}

add_python_link () {
    # This can break the system
    update-alternatives --install /usr/bin/python  python  /usr/bin/python3.10 20
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 20
}

config_timezone

DEBIAN_FRONTEND=noninteractive apt update && apt install -y --no-install-recommends software-properties-common
add-apt-repository -y ppa:deadsnakes/ppa

# nala_installation
add_system_dependencies

install_dependencies

add_python_link