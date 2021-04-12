#!/bin/bash

USERNAME=user
HOST_UID=${HOST_UID:?set HOST_UID}
HOST_UID=${HOST_GID:?set HOST_GID}

WINEPREFIX=/wine

useradd -u "${HOST_UID}" -o -m "${USERNAME}"
groupmod -g "${HOST_GID}" "${USERNAME}"

if [ -n "${WINEPREFIX+x}" ]; then
  chown -R "${USERNAME}:${USERNAME}" "${WINEPREFIX}"
fi

gosu user "$@"
