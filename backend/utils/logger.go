package utils

import (
	"log"
	"os"
)

var (
	// InfoLogger - Info Logger
	InfoLogger *log.Logger
	// WarningLogger - Warn Logger
	WarningLogger *log.Logger
	// ErrorLogger - Error Logger
	ErrorLogger *log.Logger
)

// InitLogger - Initialize Logger
func InitLogger() {

	// Create Log File
	logFile, err := os.OpenFile("./logs/logs.txt", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0666)
	if err != nil {
		log.Fatal(err)
	}

	// Set Loggers
	InfoLogger = log.New(logFile, "INFO: ", log.Ldate|log.Ltime|log.Lshortfile)
	WarningLogger = log.New(logFile, "WARNING: ", log.Ldate|log.Ltime|log.Lshortfile)
	ErrorLogger = log.New(logFile, "ERROR: ", log.Ldate|log.Ltime|log.Lshortfile)

}
