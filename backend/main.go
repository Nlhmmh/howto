package main

import (
	"backend/server"

	_ "github.com/go-sql-driver/mysql"
)

func main() {

	server.RunServer()

}
