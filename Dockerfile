FROM ubuntu:14.04.3

MAINTAINER Chris Daish <chrisdaish@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

COPY AptSources /etc/apt/sources.list.d/

#ENV FIREFOXVERSION 46.0+build5-0ubuntu0.14.04.3

RUN useradd -m firefox; \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections; \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886; \
    apt-get update;
RUN apt-get install -y --no-install-recommends  firefox \
                                                dbus-x11 \
                                                adobe-flashplugin \
                                                libxext-dev \
                                                libxrender-dev \
                                                libxtst-dev \
                                                oracle-java8-installer \
                                                oracle-java8-set-default;

# Prepare for ICP-Brasil certificates (tested with A3 certificates)
COPY safesignidentityclient_3.0.77-Ubuntu_amd64.deb /tmp/
RUN apt-get install -y --no-install-recommends  libjbig0 \
                                                libtiff4-dev \
                                                fontconfig-config \
                                                libfontconfig1 \
                                                libwxbase2.8-0 \
                                                libwxgtk2.8-0 \
                                                libpcsclite1 \
                                                libccid \
                                                opensc \
                                                openssl \
                                                libopensc-openssl \
                                                pcscd \
                                                pcsc-tools;
RUN service pcscd start
RUN dpkg -i /tmp/safesignidentityclient_3.0.77-Ubuntu_amd64.deb
RUN rm -rf /var/lib/apt/lists/*

COPY start-firefox.sh /tmp/

ENTRYPOINT ["/tmp/start-firefox.sh"]

# /usr/lib/libaetpkss.so.3