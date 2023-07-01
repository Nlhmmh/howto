package logger

import (
	"backend/utils"
	"io"
	"log"
	"os"
	"time"
)

var (
	Info    *log.Logger
	Warn    *log.Logger
	Err     *log.Logger
	LogFile *os.File
)

// Init - Initialize Logger
func Init(deleteLogs bool) error {

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
	LogFile = logFile

	// Set Loggers
	Info = log.New(io.MultiWriter(os.Stdout, logFile), "INFO: ", log.Ldate|log.Ltime|log.Lshortfile)
	Warn = log.New(io.MultiWriter(os.Stdout, logFile), "WARNING: ", log.Ldate|log.Ltime|log.Lshortfile)
	Err = log.New(io.MultiWriter(os.Stdout, logFile), "ERROR: ", log.Ldate|log.Ltime|log.Lshortfile)

	return nil

}
