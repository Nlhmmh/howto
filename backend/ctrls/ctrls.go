package ctrls

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

			userGroup.GET("/profile", userCtrls.GetProfile)
			userGroup.PUT("/edit/profile", userCtrls.EditProfile)
			userGroup.PUT("/edit/password", userCtrls.EditPassword)
			userGroup.POST("/set/fav", userCtrls.SetFav)
			userGroup.GET("/fav", userCtrls.GetAllFav)
		}

		// Content Routes
		contentGroup := apiGroup.Group("/content")
		{
			contentGroup.GET("/all", contentCtrls.GetAll)
			contentGroup.GET("/one/:contentID", contentCtrls.GetOne)
			contentGroup.POST("/create", contentCtrls.CreateContentWhole)
			contentGroup.GET("/categories", contentCtrls.GetAllCategories)
		}

		// File Routes
		router.MaxMultipartMemory = 8 << 20
		fileGroup := apiGroup.Group("/file")
		{
			fileGroup.Static("/media/", "./media")
			fileGroup.POST("/upload", fileCtrls.Upload)
		}
	}

}
