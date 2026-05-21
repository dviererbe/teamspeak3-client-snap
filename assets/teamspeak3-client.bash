#!/usr/bin/env bash

TS3_LIB_DIR="$SNAP/opt/teamspeak3-client"

export KDEDIRS=
export KDEDIR=
export QTDIR="$TS3_LIB_DIR"
export QT_PLUGIN_PATH="$TS3_LIB_DIR"
export LD_LIBRARY_PATH="$TS3_LIB_DIR:$LD_LIBRARY_PATH"

# enable to increate verbosity when debuging
#export QT_DEBUG_PLUGINS=1

# Snap's AppArmor/seccomp already confines the process; the Chromium sandbox
# inside QtWebEngine conflicts with snap confinement and causes permission errors.
export QTWEBENGINE_DISABLE_SANDBOX=1

# Chromium defaults to /dev/shm for shared memory, which snap's AppArmor profile
# blocks. Redirect to /tmp (snap-private), which is always writable.
export QTWEBENGINE_CHROMIUM_FLAGS="--disable-dev-shm-usage"

export TS3_CONFIG_DIR="$SNAP_USER_COMMON"

"$TS3_LIB_DIR"/ts3client_linux_amd64 -platform xcb "$@"
