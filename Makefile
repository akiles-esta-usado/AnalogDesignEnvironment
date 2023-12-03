all:
	#docker build --progress=plain --no-cache .
	docker build --progress=plain .


TIMESTAMP_DAY:=$$(date +%Y-%m-%d)
TIMESTAMP_TIME:=$$(date +%H-%M-%S)
GREP=grep --color=auto
RM=rm -rf


LOGDIR=logs/$(TIMESTAMP_DAY)

MAGIC_LOG=$(LOGDIR)/$(TIMESTAMP_TIME)-magic.log
XSCHEM_LOG=$(LOGDIR)/$(TIMESTAMP_TIME)-xschem.log
NETGEN_LOG=$(LOGDIR)/$(TIMESTAMP_TIME)-netgen.log
NGSPICE_LOG=$(LOGDIR)/$(TIMESTAMP_TIME)-ngspice.log
KLAYOUT_LOG=$(LOGDIR)/$(TIMESTAMP_TIME)-klayout.log
VOLARE_LOG=$(LOGDIR)/$(TIMESTAMP_TIME)-volare.log
DOCKER_LOG=$(LOGDIR)/$(TIMESTAMP_TIME)-docker.log


DOCKER_GRAPHICS=-e DISPLAY -e WAYLAND_DISPLAY -e XDG_RUNTIME_DIR -v /tmp/.X11-unix:/tmp/.X11-unix:ro --net=host -v /home/$(USER)/.Xauthority:/root/.Xauthority:ro
DOCKER_RUN=docker run -it --rm -v $(PWD):/workdir --security-opt seccomp=unconfined $(DOCKER_GRAPHICS)


.PHONY: logdir
logdir:
	mkdir -p $(LOGDIR)

mount:
	$(DOCKER_RUN) ubuntu:20.04 bash

mount-install:
	$(DOCKER_RUN) ubuntu:20.04 bash -c "/workdir/system-dependencies.sh; exec bash"


volare-install: logdir
	$(DOCKER_RUN) ubuntu:20.04 bash -c "/workdir/system-dependencies.sh; /workdir/volare-install.sh; /workdir/volare-patch-gf180.sh; /workdir/volare-patch-sky130.sh; exec bash" | tee $(VOLARE_LOG)


netgen-install: logdir
	$(DOCKER_RUN) ubuntu:20.04 bash -c "/workdir/system-dependencies.sh; /workdir/netgen-install.sh; exec bash" | tee $(NETGEN_LOG)


ngspice-install: logdir
	$(DOCKER_RUN) ubuntu:20.04 bash -c "/workdir/system-dependencies.sh; /workdir/ngspice-install.sh; exec bash" | tee $(NGSPICE_LOG)


xschem-install: logdir
	$(DOCKER_RUN) ubuntu:20.04 bash -c "/workdir/system-dependencies.sh; /workdir/xschem-install.sh; exec bash" | tee $(XSCHEM_LOG)


klayout-install: logdir
	$(DOCKER_RUN) ubuntu:20.04 bash -c "/workdir/system-dependencies.sh; /workdir/klayout-install.sh; exec bash" | tee $(KLAYOUT_LOG)


magic-install: logdir
	$(DOCKER_RUN) ubuntu:20.04 bash -c "/workdir/system-dependencies.sh; /workdir/magic-install.sh; exec bash" | tee $(MAGIC_LOG)


xeyes:
	$(DOCKER_RUN) stefanscherer/xeyes


docker:
	docker build . --tag akilesalreadytaken/test-design-environment | tee $(DOCKER_LOG)