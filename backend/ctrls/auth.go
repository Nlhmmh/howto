package ctrls

import (
	"backend/boiler"
	"backend/ers"
	"backend/server"
	"errors"
	"strings"
	"time"

	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
)

const (
	JWTSecureKey = "secureSecretText"
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

	adminWhiteList = []string{
		"/api/admin/user",
		"/api/admin/user/:userID",
	}

	containWhiteList = []string{
		"/api/file/media",
	}
)

type LoginResp struct {
	User  *boiler.User `json:"user"`
	Token string       `json:"token"`
}

type CustomClaims struct {
	UserID string
	Role   string
	jwt.StandardClaims
}

// AuthorizeJWT - Auth JWT MiddleWare
func AuthorizeJWT() gin.HandlerFunc {
	return func(c *gin.Context) {

		// Check White List
		if checkJWTWhiteList(c.FullPath()) || checkContainWhiteList(c.FullPath()) {
			c.Next()
			return
		}

		// Get token
		bearerToken := c.GetHeader("Authorization")
		tokenArray := strings.Split(bearerToken, " ")
		if len(tokenArray) < 2 {
			ers.UnAuthorizedResp(c, errors.New("bearer token is wrong"+bearerToken))
			return
		}
		token := tokenArray[1]

		// Validate Token
		claims, err := ValidateToken(token)
		if err != nil {
			ers.UnAuthorizedResp(c, err)
			return
		}
		claimsValue := *claims
		c.Set("userID", claimsValue.UserID)

		if checkAdminWhiteList(c.FullPath()) {
			if claims.Role == "admin" {
				c.Next()
			} else {
				ers.UnAuthorizedResp(c, errors.New("not admin user"))
				return
			}
		}

		c.Next()

	}
}

// checkJWTWhiteList - Check if Path exists in JWT WhiteList
func checkJWTWhiteList(path string) bool {
	for _, p := range whiteList {
		if path == p {
			return true
		}
	}
	return false
}

// checkContainWhiteList - Check if Path exists in Contain WhiteList
func checkContainWhiteList(path string) bool {
	for _, p := range containWhiteList {
		if strings.Contains(path, p) {
			return true
		}
	}
	return false
}

// checkAdminWhiteList - Check if Path exists in Admin WhiteList
func checkAdminWhiteList(path string) bool {
	for _, p := range adminWhiteList {
		if path == p {
			return true
		}
	}
	return false
}

// GenerateToken - Generate Tokens
func GenerateToken(userID string, role string) (string, error) {

	// Get Config
	config := server.GetConfig()

	// Create Token
	claims := CustomClaims{
		userID,
		role,
		jwt.StandardClaims{
			ExpiresAt: time.Now().Add(time.Hour * time.Duration(config.JWTExpiredHours)).Unix(),
			IssuedAt:  time.Now().Unix(),
		},
	}
	createdToken := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)

	// Encode Token
	token, err := createdToken.SignedString([]byte(JWTSecureKey))
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
			return []byte(JWTSecureKey), nil
		},
	)
	if err != nil {
		return nil, err
	}

	// IF token is invalid
	if !token.Valid {
		return nil, errors.New("token is invalid")
	}

	return token.Claims.(*CustomClaims), nil

}
