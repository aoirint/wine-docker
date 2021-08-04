ARG BASE_IMAGE=ubuntu:bionic
FROM ${BASE_IMAGE} AS ubuntu-base

ARG DEBIAN_FRONTEND=noninteractive
ARG WINE_BRANCH=stable
ARG WINEARCH=win64

ARG FAUDIO_X86=https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/i386/libfaudio0_19.07-0~bionic_i386.deb
ARG FAUDIO_X64=https://download.opensuse.org/repositories/Emulators:/Wine:/Debian/xUbuntu_18.04/amd64/libfaudio0_19.07-0~bionic_amd64.deb

ARG GECKO_ARCH=x86_64
ARG MONO_ARCH=x86

# Install FAudio
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -y wget && \
    wget "${FAUDIO_X86}" -O /tmp/faudio_x86.deb && \
    wget "${FAUDIO_X64}" -O /tmp/faudio_x64.deb && \
    apt-get --fix-broken install -y /tmp/faudio_x86.deb /tmp/faudio_x64.deb && \
    rm /tmp/faudio_x86.deb /tmp/faudio_x64.deb

# Install Wine HQ
RUN apt-get update && apt-get install -y software-properties-common && \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key -O - | apt-key add && \
    add-apt-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main' && \
    apt-get install -y \
        winehq-${WINE_BRANCH}

# Install Winetricks
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks -P /usr/local/bin/ && \
    chmod +x /usr/local/bin/winetricks

RUN useradd -m user

RUN apt-get update && apt-get install -y \
        gosu

# Additional dependencies
RUN apt-get update && apt-get install -y \
        libvulkan1 \
        binutils \
        cabextract \
        unzip \
        lsof \
        xvfb \
        winbind \
        pulseaudio

# Fonts
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections && \
    apt-get update && apt-get install -y \
        language-pack-ja \
        fontconfig  \
        fonts-noto-cjk \
        ttf-mscorefonts-installer && \
    fc-cache -fv

RUN update-locale LANG=ja_JP.UTF-8

RUN gosu user winetricks allfonts
RUN gosu user winetricks fakejapanese
RUN gosu user winetricks win10
RUN gosu user winetricks msxml6
RUN gosu user winetricks mfc40

# RUN gosu user xvfb-run sh -c 'wineboot && winetricks -q dotnet472; wineserver -w' && \
#   sleep 10
# RUN gosu user xvfb-run sh -c 'wineboot && winetricks -q vcrun2019; wineserver -w' && \
#   sleep 10

# Install Wine Gecko
RUN wget https://dl.winehq.org/wine/wine-gecko/2.47.2/wine-gecko-2.47.2-${GECKO_ARCH}.msi -O /tmp/wine-gecko.msi && \
    gosu user wine msiexec /i /tmp/wine-gecko.msi && \
    rm /tmp/wine-gecko.msi

# Install Wine Mono
RUN wget https://dl.winehq.org/wine/wine-mono/6.3.0/wine-mono-6.3.0-${MONO_ARCH}.msi -O /tmp/wine-mono.msi && \
    gosu user wine msiexec /i /tmp/wine-mono.msi && \
    rm /tmp/wine-mono.msi

RUN gosu user winetricks ole32
RUN gosu user winetricks oleaut32

ENTRYPOINT [ "gosu", "user" ]
CMD [ "wine", "notepad" ]



# Install Python
FROM ubuntu-base AS python
ARG DEBIAN_FRONTEND=noninteractive
ARG WINEARCH=win64
ARG PYTHON_VERSION=3.8.9
ARG PYTHON_ARCH=-amd64


RUN wget https://www.python.org/ftp/python/${PYTHON_VERSION}/python-${PYTHON_VERSION}${PYTHON_ARCH}.exe -O /tmp/install-python.exe && \
    gosu user xvfb-run \
        sh -c 'wineboot && wine /tmp/install-python.exe /quiet PrependPath=1; wineserver -w' && \
    rm /tmp/install-python.exe

CMD [ "wine", "python" ]
