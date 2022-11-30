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

	// API Routes
	controllers.CreateRoutes(router)

	// Run Server
	router.Run(":8081")

}
