package utils

import (
	"errors"
	"os"
	"strconv"
)

// CheckPostFormInteger - check integer parameter from request
func ConvertInt(param string) (int, uint, error) {

	if param == "" {
		return 0, 0, errors.New("param is blank")
	}

	valueInt, err := strconv.Atoi(param)
	if err != nil {
		return 0, 0, errors.New("param cannot be converted to int")
	}

	valueUint, err := strconv.ParseUint(param, 10, 32)
	if err != nil {
		return 0, 0, errors.New("param cannot be converted to uint")
	}

	return valueInt, uint(valueUint), nil

}

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
