FROM alpine:latest

ARG INSTALL_URL="https://gunthy.org/downloads/gunthy_linux.zip"
ARG DEBIAN_FRONTEND=noninteractive

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF org.label-schema.vcs-url="https://github.com/magicdude4eva/docker-gunbot"
LABEL description="Gunbot Docker Image Using minimal GlibC image with colorised output"

## Setup Enviroment
ENV TZ=Europe/Vienna \
  TERM=xterm-256color \
  FORCE_COLOR=true \
  NPM_CONFIG_COLOR=always \
  MOCHA_COLORS=true \
  INSTALL_URL=${INSTALL_URL}

## Setup pre-requisites
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get -y update && \
 apt-get -y install --no-install-recommends apt-utils

## Install additional libraries and upgrade
RUN apt-get -y upgrade && \
 apt-get -y install  --no-install-recommends unzip curl fontconfig fonts-dejavu-extra ca-certificates && \
 apt-get clean -y && \
 apt-get autoclean -y && \
 apt-get autoremove -y

RUN update-ca-certificates --fresh

RUN fc-cache -fv

## Install Gunbot
WORKDIR /tmp
RUN curl -Lo /tmp/lin.zip ${INSTALL_URL} \
 && unzip -q /tmp/lin.zip -d /tmp/gunthy_linux \
 && mv gunthy_* /gunbot \
 && rm -rf lin.zip __MACOSX .DS_Store \
 && rm -f /gunbot/config.js /gunbot/tgconfig.json /gunbot/autoconfig.json /gunbot/.DS_Store \
 && chmod +x /gunbot/gunthy-linux \
 && ls -l /gunbot 

WORKDIR /gunbot

EXPOSE 5000
CMD /gunbot/gunthy-linux
