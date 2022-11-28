package main

import (
	"backend/controllers"
	"backend/server"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
	"github.com/volatiletech/sqlboiler/v4/boil"
)

func main() {

	// Logging
	if err := server.InitLogger(); err != nil {
		panic(err)
	}

	// Open MySQL DB
	db, err := server.OpenDB()
	if err != nil {
		panic(err)
	}
	boil.SetDB(db)
	boil.DebugMode = true

	// Set Server
	// gin.SetMode(gin.ReleaseMode)
	router := gin.Default()
	router.Use(gin.LoggerWithConfig(gin.LoggerConfig{
		Output: server.LogFile,
	}))
	router.SetTrustedProxies(nil)
	config := cors.DefaultConfig()
	config.AllowOrigins = []string{"http://localhost:8080"}
	// config.AllowHeaders = []string{
	// 	"Access-Control-Allow-Headers",
	// 	"Content-Type",
	// 	"Content-Length",
	// 	"Accept-Encoding",
	// 	"X-CSRF-Token",
	// 	"Authorization",
	// }
	router.Use(cors.New(config))

	// Admin Routes
	// adminGroup := router.Group("/admin")
	// adminGroup.Use(controllers.AuthorizeJWT())
	// {
	// adminGroup.POST("/adminGetAllOrders", controllers.AdminGetAllOrders)
	// }

	// API Routes
	apiGroup := router.Group("/api")
	apiGroup.Use(controllers.AuthorizeJWT())
	{
		// Admin Routes
		adminGroup := apiGroup.Group("/admin")
		{
			adminGroup.GET("", controllers.FetchAllUsers)
			adminGroup.POST("/fetchUser", controllers.FetchUser)
		}

		// User Routes
		userGroup := apiGroup.Group("/user")
		{
			userGroup.GET("", controllers.UserCtrl.GetAll)
			userGroup.GET("/:userID", controllers.UserCtrl.Get)

			userGroup.POST("/register", controllers.UserCtrl.Register)
			userGroup.POST("/login", controllers.UserCtrl.Login)
			userGroup.POST("/edit", controllers.UserCtrl.Edit)
			userGroup.POST("/checkDisplayName", controllers.UserCtrl.CheckDisplayName)
			userGroup.POST("/checkEmail", controllers.UserCtrl.CheckEmail)
			userGroup.POST("/editPassword", controllers.UserCtrl.EditPassword)
		}

		// Content Routes
		// contentGroup := apiGroup.Group("/content")
		{
			// contentGroup.GET("/fetchAllContents", controllers.FetchAllContents)
			// contentGroup.POST("/createContent", controllers.CreateContent)
		}
	}

	// Run Server
	router.Run(":8081")

}
