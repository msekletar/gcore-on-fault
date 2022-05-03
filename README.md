# gcore-on-fault

This repository contains the debugging script and systemd service that watches
logs for any occurance of general protection fault and gathers the coredump of
systemd (PID 1) and coredump of faulting process. Both core files are put into
the compressed tarball that will be stored at
`/var/tmp/systemd-fault-coredump.tar.gz`.

Note that script expects that core files are stored in `/var/crash` and file
names match this glob `core.*%p*`.

# How To
```
# Make sure gcore is installed 
yum install -y /usr/bin/gcore

# Clone the repository
git clone https://github.com/msekletar/gcore-on-fault.git && cd gcore-on-fault

# Install the script and start the service
make install

# Check that service is running
systemctl status gcore-on-fault.service

# To stop the service and uninstall the script run
make uninstall

# To trigger the artificial crash and save the archive with corefiles run the following,
ulimit -c unlimited
make fault
./fault
```