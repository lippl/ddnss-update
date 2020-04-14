PREFIX=$(DESTDIR)/usr
INSTALL=/usr/bin/install
SYSTEMCTL=/bin/systemctl
SYSTEMD_DIR ?= /usr/lib/systemd/system
LOG_FOLDER=/var/log/ddnss
WORKING_DIR=/var/lib/ddnss

install:
	[ -d $(PREFIX)/bin ] || mkdir -p $(PREFIX)/bin
	[ -d $(DESTDIR)/etc/ddnss ] || mkdir -p $(DESTDIR)/etc/ddnss
	[ -d $(DESTDIR)/$(LOG_FOLDER) ] || mkdir -p $(DESTDIR)/$(LOG_FOLDER)
	$(INSTALL) -m 755 bin/ddnss-update $(PREFIX)/bin/ddnss-update
	[ -f $(DESTDIR)/etc/ddnss/ddnss-update.rc ] || \
		$(INSTALL) -m 644 ./etc/ddnss-update.rc $(DESTDIR)/etc/ddnss/ddnss-update.rc
	[ -d $(DESTDIR)$(SYSTEMD_DIR) ] || mkdir -p $(DESTDIR)$(SYSTEMD_DIR)
	$(INSTALL) -m 644 dist/ddnss-update.service $(DESTDIR)$(SYSTEMD_DIR)/ddnss-update.service
	$(INSTALL) -m 644 dist/ddnss-update.timer $(DESTDIR)$(SYSTEMD_DIR)/ddnss-update.timer
	$(SYSTEMCTL) daemon-reload
	$(SYSTEMCTL) enable --now ddnss-update.timer

uninstall:
	rm -ri $(DESTDIR)/etc/ddnss
	rm -rf $(DESTDIR)/$(LOG_FOLDER)
	rm -rf $(DESTDIR)/$(WORKING_DIR)
	rm -rf $(PREFIX)/bin/ddnss-update
	$(SYSTEMCTL)/lib/systemd/systemd disable ddnss-update.timer
	rm -rf $(DESTDIR)$(SYSTEMD_DIR)/ddnss-update.service
	rm -rf $(DESTDIR)$(SYSTEMD_DIR)/ddnss-update.timer
