FROM ubuntu:20.04

CMD mkdir -p /workdir

COPY ./base.sh /workdir/base.sh

COPY ./system-dependencies.sh /workdir/system-dependencies.sh
RUN /workdir/system-dependencies.sh

# Install Volare

COPY ./volare-install.sh /workdir/volare-install.sh
RUN /workdir/volare-install.sh

COPY ./volare-patch-gf180.sh /workdir/volare-patch-gf180.sh
RUN /workdir/volare-patch-gf180.sh

COPY ./volare-patch-sky130.sh /workdir/volare-patch-sky130.sh
RUN /workdir/volare-patch-sky130.sh

# Install Programs

COPY ./ngspice-install.sh /workdir/ngspice-install.sh
RUN /workdir/ngspice-install.sh

COPY ./xschem-install.sh /workdir/xschem-install.sh
RUN /workdir/xschem-install.sh

COPY ./netgen-install.sh /workdir/netgen-install.sh
RUN /workdir/netgen-install.sh

COPY ./magic-install.sh /workdir/magic-install.sh
RUN /workdir/magic-install.sh

COPY ./klayout-install.sh /workdir/klayout-install.sh
RUN /workdir/klayout-install.sh

# COPY lua-installation.sh /workdir/ lua-installation.sh
# /workdirUN ./lua-installation.sh

# COPY lmod-installation.sh /workdir/ lmod-installation.sh
# /workdirUN ./lmod-installation.sh

# COPY easybuild-installation.sh /workdir/ easybuild-installation.sh
# /workdirUN ./easybuild-installation.sh

