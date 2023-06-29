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
			ers.UnAuthorizedResp(c, errors.New("bearer token is wrong"+bearerToken))
			return
		}
		token := tokenArray[1]

		// Validate Token
		claims, err := auth.ValidateToken(token)
		if err != nil {
			ers.UnAuthorizedResp(c, err)
			return
		}
		claimsValue := *claims
		c.Set("userID", claimsValue.UserID)

		if auth.CheckAdminWhiteList(c.FullPath()) {
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
