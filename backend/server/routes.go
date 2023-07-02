package server

import (
	"backend/ctrls"
	"backend/server/middleware"

	"github.com/gin-gonic/gin"
)

func initRoutes(router *gin.Engine) {

	// API Routes
	apiGroup := router.Group("/api")
	apiGroup.Use(middleware.Auth())
	{
		// Admin Routes
		adminGroup := apiGroup.Group("/admin")
		{
			// User Routes
			userGroup := adminGroup.Group("/user")
			{
				userGroup.GET("", ctrls.AdminUser.GetAll)
				userGroup.GET("/:userID", ctrls.AdminUser.Get)
			}
		}

		// User Routes
		userGroup := apiGroup.Group("/user")
		{
			userGroup.POST("/check/email", ctrls.User.CheckEmail)
			userGroup.POST("/send/otp", ctrls.User.SentOTP)
			userGroup.POST("/check/otp", ctrls.User.CheckOTP)
			userGroup.POST("/check/displayname", ctrls.User.CheckDisplayName)
			userGroup.POST("/register", ctrls.User.Register)
			userGroup.POST("/login", ctrls.User.Login)

			userGroup.GET("/profile", ctrls.User.ProfileGet)
			userGroup.PUT("/profile/edit", ctrls.User.ProfileEdit)
			userGroup.PUT("/password/edit", ctrls.User.PasswordEdit)
			userGroup.POST("/fav/create", ctrls.User.FavCreate)
			userGroup.GET("/fav/list", ctrls.User.FavList)
		}

		// Content Routes
		contentGroup := apiGroup.Group("/content")
		{
			contentGroup.GET("/list", ctrls.Content.List)
			contentGroup.GET("/get/:contentID", ctrls.Content.Get)
			contentGroup.POST("/create", ctrls.Content.Create)
			contentGroup.DELETE("/delete", ctrls.Content.Delete)
			contentGroup.GET("/categories", ctrls.Content.Categories)
		}

		// File Routes
		router.MaxMultipartMemory = 8 << 20 // 8 * 1MB(2 power 20) = 8MB
		fileGroup := apiGroup.Group("/file")
		{
			fileGroup.Static("/media/", "./media")
			fileGroup.POST("/upload", ctrls.File.Upload)
		}
	}

}
