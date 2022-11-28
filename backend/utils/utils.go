package utils

import (
	"errors"
	"strconv"
)

// CheckPostFormInteger - check integer parameter from request
func ConvertInt(
	param string,
) (int, uint, error) {

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
