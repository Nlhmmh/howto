package server

import (
	"backend/config"
	"backend/logger"
	"backend/utils"
	"context"
	"fmt"
	"net/http"
	"os"
	"time"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
	"github.com/volatiletech/sqlboiler/v4/boil"
)

const (
	serverTimeOut time.Duration = 5 * time.Second
)

type server struct {
	srv *http.Server
}

func Init() *server {

	// Get Config
	config := config.GetConfig()

	// Logging
	if err := logger.Init(config.DeleteLogs); err != nil {
		panic(err)
	}

	// Delete Media
	if config.DeleteMedia {
		if err := os.RemoveAll(utils.MediaFolder); err != nil {
			logger.Err.Panic(err)
		}
	}

	// Create Media Folder
	if err := utils.CreateFolderIfNotExists(utils.MediaFolder); err != nil {
		logger.Err.Panic(err)
	}

	// Open MySQL DB
	db, err := initDB(config.DBInfo)
	if err != nil {
		logger.Err.Panic(err)
	}
	boil.SetDB(db)
	boil.DebugMode = true
	boil.DebugWriter = logger.Writer

	// Set Server
	// gin.SetMode(gin.ReleaseMode)
	router := gin.New()
	router.Use(
		gin.Recovery(),
		gin.LoggerWithConfig(gin.LoggerConfig{Output: logger.Writer}),
	)
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
	initRoutes(router)

	return &server{
		srv: &http.Server{
			Addr:    fmt.Sprintf(":%d", config.PortNo),
			Handler: router,
		},
	}

}

func (s *server) Run() error {

	logger.Info.Printf("Server listening on %s", s.srv.Addr)

	if err := s.srv.ListenAndServeTLS(
		utils.CertsFile,
		utils.CertsKeyFile,
	); err != nil && err != http.ErrServerClosed {
		return err
	}

	return nil

}

func (s *server) Shutdown() {

	logger.Info.Printf("Server shutting down...")

	ctx, cancel := context.WithTimeout(context.Background(), serverTimeOut)
	defer cancel()

	if err := s.srv.Shutdown(ctx); err != nil {
		logger.Info.Fatal(err)
	}

	logger.Info.Printf("Server terminated")

}
