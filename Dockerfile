FROM ubuntu:14.04

RUN export DEBIAN_FRONTEND=noninteractive && \
    [ -e /usr/lib/apt/methods/https ] || { apt-get update -q && apt-get -q install -y apt-transport-https; } && \
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9  2>&1 && \
    echo "deb https://get.docker.io/ubuntu docker main" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get -q install -y lxc-docker python python-dev python-pip && \
    rm -rf /var/lib/apt/lists/*

ADD tester/requirements.txt /tester/requirements.txt
RUN pip install -r /tester/requirements.txt
ADD tester /tester

VOLUME /var/lib/docker

# We can't use ENTRYPOINT as for some reason it gets given spurious arguments
# See https://github.com/dotcloud/docker/issues/5147
CMD set -ex; \
    echo 'DOCKER_OPTS="-D"' >> /etc/default/docker; \
    service docker start; \
    for i in `seq 1 20`; do \
        if docker version >/dev/null 2>&1; then \
            break; \
        fi; \
        sleep 0.1; \
    done; \
    tail -f /var/log/docker.log & \
    for file in /cache/* ; do docker load -i $file ; done ; \
    python /tester/test.py ; \
    ( while python /tester/test.py ; do : ; done ) & \
    ( while python /tester/test.py ; do : ; done ) & \
    ( while python /tester/test.py ; do : ; done ) & \
    wait
