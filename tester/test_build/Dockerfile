FROM ubuntu:14.04
RUN set -e; \
    export DEBIAN_FRONTEND=noninteractive; \
    apt-get -q update; \
    apt-get -q install -y --no-install-recommends \
        python \
        python-dev \
        python-pip \
        build-essential \
        git; \
    rm -rf /var/lib/apt/lists/*
CMD true