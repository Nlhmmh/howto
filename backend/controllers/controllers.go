package controllers

import (
	"github.com/gin-gonic/gin"
)

func CreateRoutes(router *gin.Engine) {

	// API Routes
	apiGroup := router.Group("/api")
	apiGroup.Use(AuthorizeJWT())
	{
		// Admin Routes
		adminGroup := apiGroup.Group("/admin")
		{
			// User Routes
			userGroup := adminGroup.Group("/user")
			{
				userGroup.GET("", adminUserCtrls.GetAll)
				userGroup.GET("/:userID", adminUserCtrls.Get)
			}
		}

		// User Routes
		userGroup := apiGroup.Group("/user")
		{
			userGroup.POST("/check/email", userCtrls.CheckEmail)
			userGroup.POST("/send/otp", userCtrls.SendOTP)
			userGroup.POST("/check/otp", userCtrls.CheckOTP)
			userGroup.POST("/check/displayname", userCtrls.CheckDisplayName)
			userGroup.POST("/register", userCtrls.Register)
			userGroup.POST("/login", userCtrls.Login)

			userGroup.PUT("/edit/profile", userCtrls.EditProfile)
			userGroup.PUT("/edit/password", userCtrls.EditPassword)
		}

		// Content Routes
		contentGroup := apiGroup.Group("/content")
		{
			contentGroup.GET("", contentCtrls.GetAll)
			contentGroup.POST("/create", contentCtrls.CreateContent)
		}
	}

}
