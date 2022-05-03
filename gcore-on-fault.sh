#!/bin/bash

[ $EUID = 0 ] || {
    echo "error: Please run as root."
    exit 1
}

[ -x /usr/bin/gcore ] || {
    echo "error: Please install gcore ("yum install -y /usr/bin/gcore")."
    exit 1
}

# Wait until log message about the segfault appears in the journal
# FIXME(msekleta): sending SIGPIPE manually to journalctl is not necessary with newer systemd versions that have https://github.com/systemd/systemd/pull/10511
log="$(journalctl --quiet --no-pager --dmesg --follow --lines=0 --grep "general protection fault" | { head -1 && kill -s PIPE "$(pgrep journalctl)"; } )"

# Sleep for 5 seconds to give system some time to store the coredump of crashed process 
sleep 5

# Extract the PID number of crashed process from the log line
log=${log#*[}
pid=${log%%]*}

# If systemd itself crashed then just give up
[ "$pid" = 1 ] && {
    echo "info: systemd (PID 1) crashed, giving up."
    exit 1
}

corefile="$(find /var/crash -type f -name "core.*${pid}*")"
tmpdir="$(mktemp -d -p /var/tmp)"

cp "$corefile" "$tmpdir"
(cd "$tmpdir" || exit ; gcore 1)

tar -czf /var/tmp/systemd-fault-coredump.tar.gz -C "$tmpdir" .