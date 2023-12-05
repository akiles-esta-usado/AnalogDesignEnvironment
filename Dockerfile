FROM ubuntu:20.04

CMD mkdir -p /workdir

COPY ./base.sh /workdir/base.sh

COPY ./system-dependencies.sh /workdir/system-dependencies.sh
RUN /workdir/system-dependencies.sh

# Install PDKs

COPY ./volare-install.sh /workdir/volare-install.sh
RUN /workdir/volare-install.sh

COPY ./volare-patch-gf180.sh /workdir/volare-patch-gf180.sh
RUN /workdir/volare-patch-gf180.sh

COPY ./volare-patch-sky130.sh /workdir/volare-patch-sky130.sh
RUN /workdir/volare-patch-sky130.sh

# Install Xschem

COPY ./ngspice-install.sh /workdir/ngspice-install.sh
RUN /workdir/ngspice-install.sh

COPY ./xschem-install.sh /workdir/xschem-install.sh
RUN /workdir/xschem-install.sh

# Install Magic

COPY ./netgen-install.sh /workdir/netgen-install.sh
RUN /workdir/netgen-install.sh

COPY ./magic-install.sh /workdir/magic-install.sh
RUN /workdir/magic-install.sh

# Install Klayout

COPY ./klayout-install.sh /workdir/klayout-install.sh
RUN /workdir/klayout-install.sh

# Do final modifications

COPY ./final-patch.sh /workdir/final-patch.sh
RUN /workdir/final-patch.sh