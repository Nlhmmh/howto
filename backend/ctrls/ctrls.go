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
			userGroup.POST("/check/email", userCtrls.checkEmail)
			userGroup.POST("/send/otp", userCtrls.sentOTP)
			userGroup.POST("/check/otp", userCtrls.checkOTP)
			userGroup.POST("/check/displayname", userCtrls.checkDisplayName)
			userGroup.POST("/register", userCtrls.register)
			userGroup.POST("/login", userCtrls.login)

			userGroup.GET("/profile", userCtrls.profileGet)
			userGroup.PUT("/profile/edit", userCtrls.profileEdit)
			userGroup.PUT("/password/edit", userCtrls.passwordEdit)
			userGroup.POST("/fav/create", userCtrls.favCreate)
			userGroup.GET("/fav/list", userCtrls.favList)
		}

		// Content Routes
		contentGroup := apiGroup.Group("/content")
		{
			contentGroup.GET("/list", contentCtrls.list)
			contentGroup.GET("/get/:contentID", contentCtrls.get)
			contentGroup.POST("/create", contentCtrls.create)
			contentGroup.DELETE("/delete", contentCtrls.delete)
			contentGroup.GET("/categories", contentCtrls.categories)
		}

		// File Routes
		router.MaxMultipartMemory = 8 << 20
		fileGroup := apiGroup.Group("/file")
		{
			fileGroup.Static("/media/", "./media")
			fileGroup.POST("/upload", fileCtrls.upload)
		}
	}

}
