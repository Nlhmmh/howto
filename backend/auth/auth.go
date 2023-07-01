package auth

import (
	"backend/config"
	"errors"
	"strings"
	"time"

	"github.com/dgrijalva/jwt-go"
)

const (
	jwtSecureKey = "secureSecretText"
)

var (
	whiteList = []string{
		"/api/user/register",
		"/api/user/login",
		"/api/user/check/displayname",
		"/api/user/check/email",
		"/api/user/send/otp",
		"/api/user/check/otp",

		"/api/content/list",
		"/api/content/get/:contentID",
		"/api/content/categories",
	}

	adminList = []string{
		"/api/admin/user",
		"/api/admin/user/:userID",
	}

	containWhiteList = []string{
		"/api/file/media",
	}
)

type claims struct {
	UserID string
	Role   string
	jwt.StandardClaims
}

// CheckJWTWhiteList - Check if Path exists in JWT WhiteList
func CheckJWTWhiteList(path string) bool {
	for _, p := range whiteList {
		if path == p {
			return true
		}
	}
	return false
}

// CheckContainWhiteList - Check if Path exists in Contain WhiteList
func CheckContainWhiteList(path string) bool {
	for _, p := range containWhiteList {
		if strings.Contains(path, p) {
			return true
		}
	}
	return false
}

// CheckAdminList - Check if Path exists in Admin List
func CheckAdminList(path string) bool {
	for _, p := range adminList {
		if path == p {
			return true
		}
	}
	return false
}

// GenerateToken - Generate Tokens
func GenerateToken(userID string, role string) (string, error) {

	// Get Config
	config := config.GetConfig()

	// Create Token
	claims := claims{
		userID,
		role,
		jwt.StandardClaims{
			ExpiresAt: time.Now().Add(time.Hour * time.Duration(config.JWTExpiredHours)).Unix(),
			IssuedAt:  time.Now().Unix(),
		},
	}
	createdToken := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	// Encode Token
	token, err := createdToken.SignedString([]byte(jwtSecureKey))
	if err != nil {
		return "", err
	}

	return token, nil

}

// ValidateToken - Validate Token
func ValidateToken(encodedToken string) (*claims, error) {

	// Parse JWT
	token, err := jwt.ParseWithClaims(
		encodedToken,
		&claims{},
		func(token *jwt.Token) (interface{}, error) {
			return []byte(jwtSecureKey), nil
		},
	)
	if err != nil {
		return nil, err
	}

	// IF token is invalid
	if !token.Valid {
		return nil, errors.New("token is invalid")
	}

	return token.Claims.(*claims), nil

}
