# Params
BACKUP_FILENAME = backup.zip

# System params
MAKEFLAGS += --silent
THIS_DIR := $(dir $(abspath $(firstword $(MAKEFILE_LIST))))

# Set PHONY
.PHONY: start start-debug stop install install-backup uninstall set-permission-global set-permission-execute backup

# Start Stop functions
start:
	docker compose up -d
	echo "Thingsboard is now online and will run indefinitely, use this to stop the program: make stop"

start-debug:
	docker compose up -d && docker compose logs -f mytb

debug:
	docker compose logs -f mytb

stop:
	docker compose down
	echo "Thingsboard is now offline"

# Install Uninstall Function
install:
	@if [ -d "$(THIS_DIR)/mytb-data/" ] || [ -d "$(THIS_DIR)/mytb-logs/" ] || [ -d "$(THIS_DIR)/kafka-data/" ]; then \
		echo "Installation file exists, unable to install. Please uninstall first using: make uninstall"; \
	else \
		mkdir kafka-data/ mytb-data/ mytb-logs/ ; \
		$(MAKE) set-permission-execute ; \
	fi

	echo "Checking for thingsboard latest version..."
	docker pull bitnami/kafka:3.8.1
	docker pull thingsboard/tb-postgres

install-from-backup:
	@if [ -f "$(THIS_DIR)/$(BACKUP_FILENAME)" ]; then \
		unzip $(BACKUP_FILENAME) ; \
		$(MAKE) set-permission-execute ; \
		echo "Thingsboard program has been installed from $(BACKUP_FILENAME) successfully, start it using: make start"; \
	else \
		echo "Backup file does not exist, required file: $(BACKUP_FILENAME)"; \
	fi

	echo "Checking for thingsboard latest version..."
	docker pull bitnami/kafka:3.8.1
	docker pull thingsboard/tb-postgres

uninstall:
	echo "Stopping Thingsboard before uninstall"
	$(MAKE) stop
	sudo rm -rf kafka-data/ mytb-data/ mytb-logs/
	echo "Thingsboard has been uninstalled successfully"

# Permission setup function
set-permission-global:
	sudo chmod -R 777 kafka-data/ mytb-data/ mytb-logs/

set-permission-execute:
	sudo chown -R 799:799 mytb-data/ mytb-logs/
	sudo chown -R 1001:1001 kafka-data/
	sudo chmod -R 755 kafka-data/ mytb-data/ mytb-logs/
	@if [ -d "$(THIS_DIR)/mytb-data/db/" ]; then \
		sudo chmod -R 700 mytb-data/db/; \
	fi

	@if [ $(shell ls $(THIS_DIR)/mytb-logs/ 2>/dev/null | wc -l) -ne 0 ]; then \
		sudo chmod -R 644 mytb-logs/* ; \
	fi

# Backup function
backup:
	$(MAKE) stop
	$(MAKE) set-permission-global
	zip -r $(BACKUP_FILENAME) kafka-data/ mytb-data/ mytb-logs/
	$(MAKE) set-permission-execute
	echo "Thingsboard program has been stopped, please restart it using: make start"