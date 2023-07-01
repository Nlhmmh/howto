package middleware

import (
	"backend/auth"
	"backend/ers"
	"errors"
	"strings"

	"github.com/gin-gonic/gin"
)

// Auth - Auth JWT MiddleWare
func Auth() gin.HandlerFunc {
	return func(c *gin.Context) {

		// Check White List
		if auth.CheckJWTWhiteList(c.FullPath()) || auth.CheckContainWhiteList(c.FullPath()) {
			c.Next()
			return
		}

		// Get token
		bearerToken := c.GetHeader("Authorization")
		tokenArray := strings.Split(bearerToken, " ")
		if len(tokenArray) < 2 {
			ers.UnAuthorized.New(errors.New("bearer token is wrong" + bearerToken)).Abort(c)
			return
		}
		token := tokenArray[1]

		// Validate Token
		claims, err := auth.ValidateToken(token)
		if err != nil {
			ers.UnAuthorized.New(err).Abort(c)
			return
		}
		claimsValue := *claims
		c.Set("userID", claimsValue.UserID)

		// Check Admin List
		if auth.CheckAdminList(c.FullPath()) && claims.Role != "admin" {
			ers.UnAuthorized.New(errors.New("not admin user")).Abort(c)
			return
		}

		c.Next()

	}
}
