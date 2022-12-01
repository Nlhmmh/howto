cd backend
sqlboiler --wipe --add-global-variants --add-enum-types --no-tests --no-back-referencing --add-soft-deletes  --struct-tag-casing=camel -p boiler mysql
cd ..