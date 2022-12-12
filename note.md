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
./mysql.exe -u root -p howto
cat 'C:\Users\nlh\go\src\howto\infra\docker\db\sql\main.sql' > ./mysql.exe -u root -proot howto

.\mysqldump.exe -u root -proot howto > 'C:\Users\nlh\go\src\howto\backend\sqls\database.sql'
.\mysqldump.exe -u root -proot howto system_users > 'C:\Users\nlh\go\src\howto\backend\sqls\system_users.sql'

cd 'C:\Program Files\MySQL\MySQL Server 8.0\bin'
.\mysqldump.exe -u root -proot howto users > 'C:\Users\nlh\go\src\howto\backend\sqls\users.sql'

cd 'C:\Users\nlh\go\src\howto\backend'

cd 'C:\Program Files\MySQL\MySQL Server 8.0\bin'
.\mysqladmin.exe -u root shutdown
```
