package server

import (
	"backend/utils"
	"log"
	"os"
	"time"
)

var (
	Logger Log
)

type Log struct {
	Info    *log.Logger
	Warn    *log.Logger
	Err     *log.Logger
	LogFile *os.File
}

// initLogger - Initialize Logger
func initLogger(deleteLogs bool) error {

	// Delete Logs
	if deleteLogs {
		if err := os.RemoveAll(utils.LogFolder); err != nil {
			return err
		}
	}

	// Create Log Folder
	if err := utils.CreateFolderIfNotExists(utils.LogFolder); err != nil {
		return err
	}

	// Create Log File
	logFile, err := utils.CreateFileIfNotExists(utils.LogFolder + "/" + time.Now().Format("20060102") + ".txt")
	if err != nil {
		return err
	}
	Logger.LogFile = logFile

	// Set Loggers
	Logger.Info = log.New(logFile, "INFO: ", log.Ldate|log.Ltime|log.Lshortfile)
	Logger.Warn = log.New(logFile, "WARNING: ", log.Ldate|log.Ltime|log.Lshortfile)
	Logger.Err = log.New(logFile, "ERROR: ", log.Ldate|log.Ltime|log.Lshortfile)

	return nil

}
