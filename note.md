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

## MySQL dump

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
.\mysqladmin.exe -u root -p shutdown
```

## Commands

```
docker-compose exec app sh
docker-compose logs -f app
docker-compose exec db sh
docker-compose logs -f db
docker-compose build
docker-compose down --rmi all --volumes
```

```
flutter doctor
flutter --version
flutter upgrade
flutter channel
flutter devices
flutter create

flutter build apk --target-platform=android-arm64 --analyze-size
flutter build bundle
flutter build iso
flutter build web

flutter clean
flutter pub get
flutter pub upgrade --major-versions

flutter run
flutter run --release
flutter run --debug

flutter screenshot
```

```
curl -k -X GET 'https://localhost:8081/api/content/list'
```

```
openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout key.pem -out cert.pem
openssl rsa -in key.pem -out key.pem
```