package server

import (
	"database/sql"
	"time"
)

// initDB - open MySQL database.
func initDB(dbSource string) (*sql.DB, error) {

	db, err := sql.Open("mysql", dbSource)
	if err != nil {
		return nil, err
	}

	if err := db.Ping(); err != nil {
		return nil, err
	}

	db.SetConnMaxLifetime(time.Minute * 1)
	db.SetMaxOpenConns(10)
	db.SetMaxIdleConns(10)

	return db, nil

}
