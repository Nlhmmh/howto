package utils

import (
	"database/sql"
	"time"
)

var (
	db  *sql.DB
	err error
)

// OpenDB - open MySQL database.
func OpenDB() *sql.DB {

	db, err = sql.Open("mysql", "root:root@tcp(localhost:3306)/mhksshop?parseTime=true&charset=utf8")
	if err != nil {
		panic(err)
	}

	err = db.Ping()
	if err != nil {
		panic(err)
	}

	db.SetConnMaxLifetime(time.Minute * 1)
	db.SetMaxOpenConns(10)
	db.SetMaxIdleConns(10)

	return db

}

// GetDB - Get DB
func GetDB() *sql.DB {
	return db
}
