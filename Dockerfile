# base image
FROM ghcr.io/linuxserver/baseimage-ubuntu:jammy
LABEL maintainer="muhgo muhgo@muhgo.me"

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y curl iputils-ping libc6 wireguard python3-pip && \
    curl https://repo.nordvpn.com/deb/nordvpn/debian/pool/main/nordvpn-release_1.0.0_all.deb --output /tmp/nordrepo.deb && \
    apt-get install -y /tmp/nordrepo.deb && \
    apt-get update -y && \
    apt-get install -y nordvpn && \
    apt-get remove -y nordvpn-release && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf \
                /tmp/* \
                /var/cache/apt/archives/* \
                /var/lib/apt/lists/* \
# latest python for Flask 
FROM python:slim
RUN pip install Flask
ARG NORDVPN_PORT
EXPOSE ${NORDVPN_PORT}

COPY /rootfs /
ENV S6_CMD_WAIT_FOR_SERVICES=1

# execute start.sh instead of chained commands
CMD ["/start.sh"] 