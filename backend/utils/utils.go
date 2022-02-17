package utils

import (
	"fmt"
	"strconv"
)

// CheckPostFormInteger - check integer parameter from request
/*
 * CheckPostFormInteger
 * Params - param string
 * Params - logName string
 * return - int
 * return - bool
 */
func CheckPostFormInteger(param string, logName string) (int, bool) {

	if param == "" {
		fmt.Printf("Bad Request - %s is empty\n", logName)
		return 0, false
	}

	value, err := strconv.Atoi(param)
	if err != nil {
		fmt.Printf("Bad Request - %s is empty\n", logName)
		return 0, false
	}

	return value, true

}

// CheckPostFormString - check string parameter from request
/*
 * CheckPostFormString
 * Params - param string
 * Params - logName string
 * return - string
 * return - bool
 */
func CheckPostFormString(param string, logName string) (string, bool) {

	if param == "" {
		fmt.Printf("Bad Request - %s is empty\n", logName)
		return "", false
	}

	return param, true

}

// CheckPostFormBool - check boolean parameter from request
/*
 * CheckPostFormBool
 * Params - param string
 * Params - logName string
 * return - bool
 * return - bool
 */
func CheckPostFormBool(param string, logName string) (bool, bool) {

	if param == "" {
		fmt.Printf("Bad Request - %s is empty\n", logName)
		return false, false
	}

	value, err := strconv.ParseBool(param)
	if err != nil {
		fmt.Printf("Bad Request - %s cannot be converted to Boolean\n", logName)
		return false, false
	}

	return value, true

}
