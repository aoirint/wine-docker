ARG BASE_IMAGE=ubuntu:bionic
FROM ${BASE_IMAGE} AS ubuntu-base

ARG DEBIAN_FRONTEND=noninteractive

ARG FAUDIO_X86=https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/i386/libfaudio0_19.07-0~bionic_i386.deb
ARG FAUDIO_X64=https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/amd64/libfaudio0_19.07-0~bionic_amd64.deb

# Install FAudio
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y wget && \
    wget "${FAUDIO_X86}" -O /tmp/faudio_x86.deb && \
    wget "${FAUDIO_X64}" -O /tmp/faudio_x64.deb && \
    apt-get --fix-broken install -y /tmp/faudio_x86.deb /tmp/faudio_x64.deb && \
    rm /tmp/faudio_x86.deb /tmp/faudio_x64.deb

# Install Wine HQ
RUN apt-get install -y software-properties-common && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key -O - | apt-key add && \
    add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' && \
    apt-get install -y \
        winehq-stable

# Install Winetricks
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -P /usr/local/bin/ && \
    chmod +x /usr/local/bin/winetricks

RUN apt-get install -y \
        gosu \
        libvulkan1 && \
    useradd -m user

ENTRYPOINT [ "gosu", "user" ]
CMD [ "wine", "notepad" ]



# Install Python
FROM ubuntu-base AS python
ARG DEBIAN_FRONTEND=noninteractive
ARG PYTHON_VERSION=3.8.9

RUN apt-get install -y \
        xvfb \
        cabextract

RUN WINARCH=win64 gosu user winetricks \
        corefonts \
        win10 && \
    wget https://www.python.org/ftp/python/${PYTHON_VERSION}/python-${PYTHON_VERSION}-amd64.exe -O /tmp/install-python.exe && \
    gosu user xvfb-run \
    sh -c 'wineboot && wine /tmp/install-python.exe /quiet PrependPath=1; wineserver -w' && \
    rm /tmp/install-python.exe

CMD [ "wine", "python" ]

