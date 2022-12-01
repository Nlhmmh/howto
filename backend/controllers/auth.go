package controllers

import (
	"backend/boiler"
	"errors"
	"strings"
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
		"/api/user/check/displayname",
		"/api/user/check/email",
		"/api/user/send/otp",
		"/api/user/check/otp",

		"/api/content",
	}

	// AdminWhiteList - Admin WhiteList
	AdminWhiteList = []string{
		"/api/admin/user",
		"/api/admin/user/:userID",
	}
)

// LoginResponse - Login Response
type LoginResponse struct {
	User  *boiler.User `json:"user"`
	Token string       `json:"token"`
}

// CustomClaims - Custom Claims
type CustomClaims struct {
	UserID string
	Role   string
	jwt.StandardClaims
}

// AuthorizeJWT - Auth JWT MiddleWare
func AuthorizeJWT() gin.HandlerFunc {
	return func(c *gin.Context) {

		// Check White List
		if CheckJWTWhiteList(c.FullPath()) {

			// Get token
			bearerToken := c.GetHeader("Authorization")
			tokenArray := strings.Split(bearerToken, " ")
			if len(tokenArray) < 2 {
				UnAuthorizedResp(c, errors.New("bearer token is wrong"+bearerToken))
				return
			}
			token := tokenArray[1]

			// Validate Token
			claims, err := ValidateToken(token)
			if err != nil {
				UnAuthorizedResp(c, err)
				return
			}
			claimsValue := *claims
			c.Set("userID", claimsValue.UserID)

			if CheckAdminWhiteList(c.FullPath()) {
				if claims.Role == "admin" {
					c.Next()
				} else {
					UnAuthorizedResp(c, errors.New("not admin user"))
					return
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
func GenerateToken(userID string, role string) (string, error) {

	// Create Token
	claims := CustomClaims{
		userID,
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
