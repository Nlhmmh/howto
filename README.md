# Project Name

HowTo

## Description

HowTo is a platform where users can browse howTos. <br/> They can also share their knowledge and make money.

## Language

```
Frontend - Flutter
Backend - Golang
```

## MySQL Docker

```
sh db.sh
Type ...root ....
```

## Create SqlBoiler

```
sh sqlboiler.sh
```

## Run Backend

```
sh air.sh
```

```
docker-compose exec app sh
docker-compose logs -f app
docker-compose exec db sh
docker-compose logs -f db
docker-compose build
docker-compose down --rmi all --volumes
```

## Run Frontent

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

# App Page List

1. Top
2. Content Detail
3. Register
4. Login
5. Profile
6. Edit Profile
7. Edit Password
8. My Page
9. Create Content
10. My Contents
11. Favourite
12. Search
13. My Balance

# Admin Page List

1. Dashboard
2. Sales
3. User List
4. Content List
5. Balance List

# TODO

1. API Error Dialog
2. JWT Error Dialog
3. No Internet Connection Dialog