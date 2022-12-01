## go.mod

replace nay/models => ./models

## Init Golang Package
```
go get github.com/google/uuid
go install github.com/volatiletech/sqlboiler/v4@latest
go install github.com/volatiletech/sqlboiler/v4/drivers/sqlboiler-mysql@latest
go get github.com/volatiletech/sqlboiler/v4
go get github.com/volatiletech/null/v8
```

## SQL Boiler

```
cd backend
sqlboiler.exe --wipe --add-global-variants --add-enum-types --no-tests --no-back-referencing --add-soft-deletes --no-auto-timestamps --no-driver-templates --struct-tag-casing=camel -p boiler mysql

sqlboiler --wipe --add-global-variants --add-enum-types --no-tests --no-back-referencing --add-soft-deletes  --struct-tag-casing=camel -p boiler mysql
```

## MYsql dump

```
cd 'C:\Program Files\MySQL\MySQL Server 8.0\bin'
cd 'C:\Users\nlh\go\src\howto\backend\sqls\main.sql' > .\mysql.exe -u root -p root

.\mysqldump.exe -u root -proot howto > 'C:\Users\nlh\go\src\howto\backend\sqls\database.sql'
.\mysqldump.exe -u root -proot howto system_users > 'C:\Users\nlh\go\src\howto\backend\sqls\system_users.sql'

cd 'C:\Program Files\MySQL\MySQL Server 8.0\bin'
.\mysqldump.exe -u root -proot howto users > 'C:\Users\nlh\go\src\howto\backend\sqls\users.sql'

cd 'C:\Users\nlh\go\src\howto\backend'
```
