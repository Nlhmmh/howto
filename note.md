## go.mod

replace nay/models => ./models

## SQL Boiler

cd backend
sqlboiler.exe --wipe --add-global-variants --add-enum-types --no-tests --no-back-referencing --add-soft-deletes --no-auto-timestamps --no-driver-templates --struct-tag-casing=camel -p boiler mysql

## MYsql dump

cd 'C:\Program Files\MySQL\MySQL Server 8.0\bin'
cd 'C:\Users\nlh\go\src\howto\backend\sqls\main.sql' > .\mysql.exe -u root -p root

.\mysqldump.exe -u root -proot howto > 'C:\Users\nlh\go\src\howto\backend\sqls\database.sql'
.\mysqldump.exe -u root -proot howto system_users > 'C:\Users\nlh\go\src\howto\backend\sqls\system_users.sql'

cd 'C:\Program Files\MySQL\MySQL Server 8.0\bin'
.\mysqldump.exe -u root -proot howto users > 'C:\Users\nlh\go\src\howto\backend\sqls\users.sql'

cd 'C:\Users\nlh\go\src\howto\backend'
