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

	// User Routes
	userGroup := router.Group("/user")
	userGroup.Use(controllers.AuthorizeJWT())
	{
		userGroup.GET("/fetchAllUsers", controllers.FetchAllUsers)

		// userGroup.POST("/fetchUser", controllers.FetchUser)
		userGroup.POST("/register", controllers.RegisterUser)
		// userGroup.POST("/loginUser", controllers.LoginUser)
		// userGroup.POST("/editUser", controllers.EditUser)
		// userGroup.POST("/checkUserDisplayName", controllers.CheckUserDisplayName)
		// userGroup.POST("/checkEmail", controllers.CheckEmail)
		// userGroup.POST("/editPassword", controllers.EditPassword)

	}

	// Content Routes
	contentGroup := router.Group("/content")
	contentGroup.Use(controllers.AuthorizeJWT())
	{
		// contentGroup.GET("/fetchAllContents", controllers.FetchAllContents)
		// contentGroup.POST("/createContent", controllers.CreateContent)

	}

	// Run Server
	router.Run(":8081")

}
