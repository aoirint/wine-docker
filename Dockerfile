ARG BASE_IMAGE=ubuntu:bionic
FROM ${BASE_IMAGE}

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


RUN apt-get install -y gosu

RUN apt-get install -y libvulkan1


# https://askubuntu.com/questions/678277/how-to-install-python3-in-wine
RUN apt-get install -y xvfb
RUN apt-get install -y cabextract

RUN useradd -m user && \
    mkdir -p /wine && \
    chown -R "user:user" /wine

RUN WINEPREFIX=/wine WINARCH=win64 gosu user winetricks \
        corefonts \
        win10

RUN wget https://www.python.org/ftp/python/3.8.9/python-3.8.9-amd64.exe -P /tmp/

#RUN apt-get install -y xdotool
#DISPLAY=:50.0 xdotool search --name 'Python' windowfocus --sync %1 && \

RUN gosu user Xvfb :50 -screen 0 1024x768x16 & \
    bash -c 'while [ ! -f /tmp/.X50-lock ]; do sleep 1; done' && \
    DISPLAY=:50.0 WINEPREFIX=/wine gosu user wine cmd /c \
        /tmp/python-3.8.9-amd64.exe \
        /quiet \
        PrependPath=1


#RUN mkdir -p /tmp/.X11-unix && \
#   chmod 1777 /tmp/.X11-unix && \
#RUN WINEPREFIX=/wine gosu user xvfb-run wine /tmp/python-3.8.9-amd64.exe /quiet PrependPath=1
#    gosu user bash -c \
#    'Xvfb :50 -screen 0 1024x768x16 & \
#    DISPLAY=:50.0 WINEPREFIX=/wine wine cmd /c \
#        /tmp/python-3.8.9-amd64.exe \
#        /quiet \
#        PrependPath=1'

ADD ./docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "wine64", "notepad" ]
