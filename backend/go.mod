module backend

go 1.18

// replace backend => ./

// replace backend/models => ./models

// replace backend/controllers => ./controllers

// replace backend/utils => ./utils

require (
	github.com/dgrijalva/jwt-go v3.2.0+incompatible
	github.com/friendsofgo/errors v0.9.2
	github.com/gin-contrib/cors v1.3.1
	github.com/gin-gonic/gin v1.8.1
	github.com/go-sql-driver/mysql v1.6.0
	github.com/google/uuid v1.3.0
	github.com/volatiletech/null/v8 v8.1.2
	github.com/volatiletech/sqlboiler/v4 v4.13.0
	github.com/volatiletech/strmangle v0.0.4
	golang.org/x/crypto v0.3.0
	gopkg.in/yaml.v3 v3.0.1
)

require (
	github.com/gin-contrib/sse v0.1.0 // indirect
	github.com/go-playground/locales v0.14.0 // indirect
	github.com/go-playground/universal-translator v0.18.0 // indirect
	github.com/go-playground/validator/v10 v10.11.1 // indirect
	github.com/goccy/go-json v0.9.11 // indirect
	github.com/gofrs/uuid v3.2.0+incompatible // indirect
	github.com/google/go-cmp v0.5.9 // indirect
	github.com/json-iterator/go v1.1.12 // indirect
	github.com/leodido/go-urn v1.2.1 // indirect
	github.com/mattn/go-isatty v0.0.16 // indirect
	github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd // indirect
	github.com/modern-go/reflect2 v1.0.2 // indirect
	github.com/pelletier/go-toml/v2 v2.0.6 // indirect
	github.com/spf13/cast v1.5.0 // indirect
	github.com/ugorji/go/codec v1.2.7 // indirect
	github.com/volatiletech/inflect v0.0.1 // indirect
	github.com/volatiletech/randomize v0.0.1 // indirect
	golang.org/x/net v0.2.0 // indirect
	golang.org/x/sys v0.2.0 // indirect
	golang.org/x/text v0.4.0 // indirect
	golang.org/x/xerrors v0.0.0-20220907171357-04be3eba64a2 // indirect
	google.golang.org/protobuf v1.28.1 // indirect
	gopkg.in/yaml.v2 v2.4.0 // indirect
)
