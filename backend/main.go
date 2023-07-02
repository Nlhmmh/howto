package main

import (
	"backend/server"
	"os"
	"os/signal"
	"syscall"

	_ "github.com/go-sql-driver/mysql"
)

func main() {

	svc := server.Init()
	go func() {
		if err := svc.Run(); err != nil {
			panic(err)
		}
	}()

	// Graceful shutdown
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, os.Interrupt, syscall.SIGTERM)
	<-quit
	svc.Shutdown()

}
