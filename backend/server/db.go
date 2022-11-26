package server

import (
	"database/sql"
	"time"
)

var (
	db  *sql.DB
	err error
)

// OpenDB - open MySQL database.
func OpenDB() (*sql.DB, error) {

	db, err = sql.Open("mysql", "root:root@tcp(localhost:3306)/howto?parseTime=true&charset=utf8")
	if err != nil {
		return nil, err
	}

	if err = db.Ping(); err != nil {
		return nil, err
	}

	db.SetConnMaxLifetime(time.Minute * 1)
	db.SetMaxOpenConns(10)
	db.SetMaxIdleConns(10)

	return db, nil

}