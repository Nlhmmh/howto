help:
	@echo "make [command]"
	@grep -E '^[a-zA-Z_-]+:.*?# .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?# "}; {printf "  \033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: air
air: # Run api server
	cd ./backend && air

.PHONY: db
db: # Initialize MySQL database inside Docker
	docker-compose -f ./infra/docker-compose.yaml down --remove-orphans --volumes
	docker-compose -f ./infra/docker-compose.yaml up -d

.PHONY: connect-db
connect-db: # mysql command line client inside Docker 
	docker-compose -f ./infra/docker-compose.yaml exec db sh -c "mysql -u root -p howto"

.PHONY: boil
boil: # Generate sqlboiler code (mac)
	cd ./backend && sqlboiler --wipe --add-global-variants --add-enum-types --no-tests --no-back-referencing --add-soft-deletes  --struct-tag-casing=camel -p boiler mysql

.PHONY: boil-windows
boil-windows: # Generate sqlboiler code (windows)
	cd ./backend && sqlboiler.exe --wipe --add-global-variants --add-enum-types --no-tests --no-back-referencing --add-soft-deletes --no-auto-timestamps --no-driver-templates --struct-tag-casing=camel -p boiler mysql