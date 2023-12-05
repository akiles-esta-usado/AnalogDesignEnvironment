#!/bin/bash

set -e

SCRIPTPATH=$(dirname $(realpath -s $0))
source $SCRIPTPATH/base.sh

DEPS=

add_ngspice_dependencies () {
    add_if_not_declared autoconf
    add_if_not_declared automake
    add_if_not_declared libtool
    add_if_not_declared libxaw7-dev
}

ngspice_install() {
    REPO_COMMIT_SHORT=$(echo "$NGSPICE_REPO_COMMIT" | cut -c 1-7)

    rm -rf "${NGSPICE_NAME}"

    git clone --filter=blob:none "${NGSPICE_REPO_URL}" "${NGSPICE_NAME}"
    cd "${NGSPICE_NAME}"
    git checkout "${NGSPICE_REPO_COMMIT}"
    ./autogen.sh
    #FIXME 2nd run of autogen needed
    set -e
    ./autogen.sh

    # Define common compile options
    NGSPICE_COMPILE_OPTS=("--disable-debug" "--enable-openmp" "--with-x" "--with-readline=yes" "--enable-pss" "--enable-xspice" "--with-fftw3=yes" "--enable-osdi")

    # Compile ngspice executable
    ./configure "${NGSPICE_COMPILE_OPTS[@]}" --prefix="${TOOLS}/${NGSPICE_NAME}/${REPO_COMMIT_SHORT}"
    make -j"$(nproc)"
    make install

    # Cleanup between builds to prevent strange missing symbols in libngspice.
    make distclean

    # Now compile lib
    ./configure "${NGSPICE_COMPILE_OPTS[@]}" --with-ngshared --prefix="${TOOLS}/${NGSPICE_NAME}/${REPO_COMMIT_SHORT}"
    make -j"$(nproc)"
    make install

    # Enable OSDI for IHP PDK
    if [ -f "$PDK_ROOT"/ihp-sg13g2/libs.tech/ngspice/openvaf/psp103_nqs.osdi ]; then
        FNAME="${TOOLS}/${NGSPICE_NAME}/${REPO_COMMIT_SHORT}"/share/ngspice/scripts/spinit
        cp "$FNAME" "$FNAME".bak
        sed -i "s/unset osdi_enabled/* unset osdi_enabled/g" "$FNAME"

        sed -i "s#osdi /foss/tools/ngspice/ngspice/lib/ngspice/asmhemt.osdi#* osdi /foss/tools/ngspice/ngspice/lib/ngspice/asmhemt.osdi#g" "$FNAME"
        sed -i "s#osdi /foss/tools/ngspice/ngspice/lib/ngspice/bjt504t.osdi#* osdi /foss/tools/ngspice/ngspice/lib/ngspice/bjt504t.osdi#g" "$FNAME"
        sed -i "s#osdi /foss/tools/ngspice/ngspice/lib/ngspice/BSIMBULK107.osdi#* osdi /foss/tools/ngspice/ngspice/lib/ngspice/BSIMBULK107.osdi#g" "$FNAME"
        sed -i "s#osdi /foss/tools/ngspice/ngspice/lib/ngspice/BSIMCMG.osdi#* osdi /foss/tools/ngspice/ngspice/lib/ngspice/BSIMCMG.osdi#g" "$FNAME"
        sed -i "s#osdi /foss/tools/ngspice/ngspice/lib/ngspice/HICUMl0-2.0.osdi#* osdi /foss/tools/ngspice/ngspice/lib/ngspice/HICUMl0-2.0.osdi#g" "$FNAME"
        sed -i "s#osdi /foss/tools/ngspice/ngspice/lib/ngspice/r2_cmc.osdi#* osdi /foss/tools/ngspice/ngspice/lib/ngspice/r2_cmc.osdi#g" "$FNAME"
        sed -i "s#osdi /foss/tools/ngspice/ngspice/lib/ngspice/vbic_4T_et_cf.osdi#* osdi /foss/tools/ngspice/ngspice/lib/ngspice/vbic_4T_et_cf.osdi#g" "$FNAME"

        # Copy OSDI PSP model for IHP
        cp "$PDK_ROOT"/ihp-sg13g2/libs.tech/ngspice/openvaf/psp103_nqs.osdi "${TOOLS}"/"${NGSPICE_NAME}"/"${REPO_COMMIT_SHORT}"/lib/ngspice/psp103.osdi
    fi

    link_program "${NGSPICE_NAME}" "${TOOLS}/${NGSPICE_NAME}/${REPO_COMMIT_SHORT}"
}

ngspice_clean () {
    cd $HOME
    rm -rf "${NGSPICE_NAME}"
}

# RUN
#####

add_ngspice_dependencies
install_dependencies

cd $HOME

ngspice_install
ngspice_clean