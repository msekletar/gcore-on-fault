install:
	cp -f gcore-on-fault.sh /usr/local/libexec/
	cp -f gcore-on-fault.service /etc/systemd/system/
	systemctl --now enable gcore-on-fault.service

uninstall:
	systemctl --now disable gcore-on-fault.service
	rm -f /usr/local/libexec/gcore-on-fault.sh  /etc/systemd/system/gcore-on-fault.service

.PHONY: install uninstall

