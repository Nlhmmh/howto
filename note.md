## go.mod
replace nay/models => ./models

## SQL Boiler
cd backend
sqlboiler.exe --wipe --add-global-variants --add-enum-types --no-tests --no-back-referencing --add-soft-deletes --no-auto-timestamps --no-driver-templates --struct-tag-casing=camel mysql


