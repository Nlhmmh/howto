package server

import (
	"backend/config"
	"backend/utils"
	"os"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
	"github.com/volatiletech/sqlboiler/v4/boil"
)

func RunServer() {

	// Get Config
	config := config.GetConfig()

	// Logging
	if err := initLogger(config.DeleteLogs); err != nil {
		panic(err)
	}

	// Delete Media
	if config.DeleteMedia {
		if err := os.RemoveAll(utils.MediaFolder); err != nil {
			Logger.Err.Panic(err)
		}
	}

	// Create Media Folder
	if err := utils.CreateFolderIfNotExists(utils.MediaFolder); err != nil {
		Logger.Err.Panic(err)
	}

	// Open MySQL DB
	db, err := OpenDB(config.DBInfo)
	if err != nil {
		Logger.Err.Panic(err)
	}
	boil.SetDB(db)
	boil.DebugMode = true

	// Set Server
	// gin.SetMode(gin.ReleaseMode)
	router := gin.Default()
	router.Use(gin.LoggerWithConfig(gin.LoggerConfig{
		Output: Logger.LogFile,
	}))
	router.SetTrustedProxies(nil)
	routerConfig := cors.DefaultConfig()
	routerConfig.AllowOrigins = config.AllowedOrigins
	// config.AllowHeaders = []string{
	// 	"Access-Control-Allow-Headers",
	// 	"Content-Type",
	// 	"Content-Length",
	// 	"Accept-Encoding",
	// 	"X-CSRF-Token",
	// 	"Authorization",
	// }
	router.Use(cors.New(routerConfig))

	// API Routes
	createRoutes(router)

	// Run Server
	if err := router.Run(":" + config.PortNo); err != nil {
		Logger.Err.Panic(err)
	}

}
