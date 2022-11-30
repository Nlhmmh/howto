package controllers

import (
	"backend/controllers/admin"

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
				userGroup.GET("", admin.UserCtrl.GetAll)
				userGroup.GET("/:userID", admin.UserCtrl.Get)
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
			userGroup.POST("/edit/profile", userCtrls.EditProfile)
			userGroup.POST("/edit/password", userCtrls.EditPassword)
		}

		// Content Routes
		// contentGroup := apiGroup.Group("/content")
		{
			// contentGroup.GET("/fetchAllContents", FetchAllContents)
			// contentGroup.POST("/createContent", CreateContent)
		}
	}

}
