package controllers

import (
	"backend/boiler"
	"backend/utils"
	"fmt"
	"net/http"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
)

const (
	// SecureKey - Secure Key for JWT
	SecureKey = "secureSecretText"
)

// LoginResponse - Login Response
type LoginResponse struct {
	User  *boiler.User `json:"user"`
	Token string       `json:"token"`
}

// CustomClaims - Custom Claims
type CustomClaims struct {
	DisplayName string
	IsAdmin     bool
	jwt.StandardClaims
}

// AuthorizeJWT - Auth JWT MiddleWare
func AuthorizeJWT() gin.HandlerFunc {
	return func(c *gin.Context) {

		// Get token
		token := c.PostForm("token")

		// Check White List
		if CheckJWTWhiteList(c.FullPath()) {
			// Validate Token
			claims := ValidateToken(token)
			if claims != nil {
				if CheckAdminWhiteList(c.FullPath()) {
					if claims.IsAdmin {
						c.Next()
					} else {
						fmt.Println("Unauthorized - Not Admin User")
						c.AbortWithStatus(http.StatusUnauthorized)
					}
				}
				c.Next()
			} else {
				fmt.Println("Unauthorized - No JWT")
				c.AbortWithStatus(http.StatusUnauthorized)
			}
		} else {
			c.Next()
		}

	}
}

// CheckJWTWhiteList - Check if Path exists in JWT WhiteList
func CheckJWTWhiteList(path string) bool {
	for _, p := range utils.JwtWhiteList {
		if path == p {
			return false
		}
	}
	return true
}

// CheckAdminWhiteList - Check if Path exists in Admin WhiteList
func CheckAdminWhiteList(path string) bool {
	for _, p := range utils.AdminWhiteList {
		if path == p {
			return true
		}
	}
	return false
}

// GenerateToken - Generate Tokens
func GenerateToken(displayName string, isAdmin bool) string {

	// Create Token
	claims := CustomClaims{
		displayName,
		isAdmin,
		jwt.StandardClaims{
			ExpiresAt: time.Now().Add(time.Hour * 48).Unix(),
			IssuedAt:  time.Now().Unix(),
		},
	}
	createdToken := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	// Encode Token
	token, err := createdToken.SignedString([]byte(SecureKey))
	if err != nil {
		panic(err)
	}

	return token
}

// ValidateToken - Validate Token
func ValidateToken(encodedToken string) *CustomClaims {

	// Parse JWT
	token, err := jwt.ParseWithClaims(
		encodedToken,
		&CustomClaims{},
		func(token *jwt.Token) (interface{}, error) {
			return []byte(SecureKey), nil
		})
	if err != nil {
		fmt.Println(err.Error())
		return nil
	}

	// IF token is valid
	if token.Valid {
		claims := token.Claims.(*CustomClaims)
		return claims
	}

	fmt.Println("Token is Invalid.")
	return nil

}
