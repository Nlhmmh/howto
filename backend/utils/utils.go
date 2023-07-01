package utils

import (
	"errors"
	"os"
)

// CheckBlankString - check string parameter from request
func CheckBlankString(param string) (string, error) {

	if param == "" {
		return "", errors.New("param is blank")
	}

	return param, nil

}

// CreateFolderIfNotExists - create folder if not exits
func CreateFolderIfNotExists(folderPath string) error {

	if _, err := os.Stat(folderPath); errors.Is(err, os.ErrNotExist) {
		if err := os.Mkdir(folderPath, os.ModePerm); err != nil {
			return err
		}
	}

	return nil

}

// CreateFileIfNotExists - create file if not exits
func CreateFileIfNotExists(filePath string) (*os.File, error) {

	logFile, err := os.OpenFile(filePath, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0666)
	if err != nil {
		return nil, err
	}

	return logFile, nil

}
