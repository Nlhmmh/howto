package controllers

import (
	"backend/boiler"
	"errors"
	"net/http"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
)

const (
	// SecureKey - Secure Key for JWT
	SecureKey = "secureSecretText"
)

var (
	// JwtWhiteList - JWT WhiteList
	JwtWhiteList = []string{
		"/api/user/register",
		"/api/user/login",
		"/api/user/checkDisplayName",
		"/api/user/checkEmail",

		"/api/user",
		"/api/user/:userID",

		"/api/content",
	}

	// AdminWhiteList - Admin WhiteList
	AdminWhiteList = []string{}
)

// LoginResponse - Login Response
type LoginResponse struct {
	User  *boiler.User `json:"user"`
	Token string       `json:"token"`
}

// CustomClaims - Custom Claims
type CustomClaims struct {
	DisplayName string
	Role        string
	jwt.StandardClaims
}

// AuthorizeJWT - Auth JWT MiddleWare
func AuthorizeJWT() gin.HandlerFunc {
	return func(c *gin.Context) {

		// Get token
		token := c.GetHeader("token")

		// Check White List
		if CheckJWTWhiteList(c.FullPath()) {

			// Validate Token
			claims, err := ValidateToken(token)
			if err != nil {
				c.AbortWithError(http.StatusUnauthorized, err)
			}

			if CheckAdminWhiteList(c.FullPath()) {
				if claims.Role == "admin" {
					c.Next()
				} else {
					c.AbortWithError(http.StatusUnauthorized, errors.New("not admin user"))
				}
			}

			c.Next()

		} else {
			c.Next()
		}

	}
}

// CheckJWTWhiteList - Check if Path exists in JWT WhiteList
func CheckJWTWhiteList(path string) bool {
	for _, p := range JwtWhiteList {
		if path == p {
			return false
		}
	}
	return true
}

// CheckAdminWhiteList - Check if Path exists in Admin WhiteList
func CheckAdminWhiteList(path string) bool {
	for _, p := range AdminWhiteList {
		if path == p {
			return true
		}
	}
	return false
}

// GenerateToken - Generate Tokens
func GenerateToken(displayName string, role string) (string, error) {

	// Create Token
	claims := CustomClaims{
		displayName,
		role,
		jwt.StandardClaims{
			ExpiresAt: time.Now().Add(time.Hour * 48).Unix(),
			IssuedAt:  time.Now().Unix(),
		},
	}
	createdToken := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	// Encode Token
	token, err := createdToken.SignedString([]byte(SecureKey))
	if err != nil {
		return "", err
	}

	return token, nil

}

// ValidateToken - Validate Token
func ValidateToken(encodedToken string) (*CustomClaims, error) {

	// Parse JWT
	token, err := jwt.ParseWithClaims(
		encodedToken,
		&CustomClaims{},
		func(token *jwt.Token) (interface{}, error) {
			return []byte(SecureKey), nil
		})
	if err != nil {
		return nil, err
	}

	// IF token is invalid
	if !token.Valid {
		return nil, errors.New("token is invalid")
	}

	claims := token.Claims.(*CustomClaims)
	return claims, nil

}
