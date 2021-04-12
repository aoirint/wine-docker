#!/bin/bash

#USERNAME=user
#HOST_UID=${HOST_UID:?set HOST_UID}
#HOST_UID=${HOST_GID:?set HOST_GID}

#WINEPREFIX=/wine

#usermod -u "${HOST_UID}" -o "${USERNAME}"
#groupmod -g "${HOST_GID}" "${USERNAME}"

#if [ -n "${WINEPREFIX+x}" ]; then
#  chown -R "${USERNAME}:${USERNAME}" "${WINEPREFIX}"
#fi

#gosu user Xvfb :57 -screen 0 1024x768x16 &
#pid=$!

#DISPLAY=:57.0 WINEPREFIX=/wine gosu user wine cmd /c \
#    /tmp/python-3.8.9-amd64.exe \
#    /quiet \
#    PrependPath=1

#kill $pid


gosu user "$@"
