#!/usr/bin/env bash

TS3_LIB_DIR="$SNAP/opt/teamspeak3-client"
TS3_USER_LIB_DIR="$SNAP_USER_DATA/lib"

export KDEDIRS=
export KDEDIR=
export QTDIR="$TS3_USER_LIB_DIR"
export QT_PLUGIN_PATH="$TS3_USER_LIB_DIR"
export LD_LIBRARY_PATH="$TS3_USER_LIB_DIR:$LD_LIBRARY_PATH"

# enable to increate verbosity when debuging
#export QT_DEBUG_PLUGINS=1

# Snap's AppArmor/seccomp already confines the process; the Chromium sandbox
# inside QtWebEngine conflicts with snap confinement and causes permission errors.
export QTWEBENGINE_DISABLE_SANDBOX=1

# Chromium defaults to /dev/shm for shared memory, which snap's AppArmor profile
# blocks. Redirect to /tmp (snap-private), which is always writable.
export QTWEBENGINE_CHROMIUM_FLAGS="--disable-dev-shm-usage"

# Prevent Qt from falling back to the read-only application directory when
# looking for WebEngine locales.
#export QTWEBENGINE_LOCALES_PATH="$TS3_USER_LIB_DIR/translations"

# The TeamSpeak 3 client has the annoying behaviour of trying to write inside
# it's application directory. I could not figure out if there is a setting to
# disable/change that. I tried to use symlinks to the read-only files/directories
# in $TS3_LIB_DIR, but ts3 resolves the real path. After trying for hours I
# gave up and just copied the files to a writable directory.
# If you have a better solution, LET ME KNOW!!!! I so not like this solution.
if [ ! -d "$TS3_USER_LIB_DIR" ]; then
    cp --recursive --preserve "$TS3_LIB_DIR" "$TS3_USER_LIB_DIR"
fi

cd "$SNAP_USER_COMMON"
"$TS3_USER_LIB_DIR"/ts3client_linux_amd64 -platform xcb "$@"
