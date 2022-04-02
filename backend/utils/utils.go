package utils

import (
	"database/sql"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

// CheckPostFormInteger - check integer parameter from request
func CheckPostFormInteger(
	param string,
	logName string,
	c *gin.Context,
) (int, uint, bool) {

	if param == "" {
		fmt.Printf("Bad Request - %s is empty\n", logName)
		c.AbortWithStatus(http.StatusBadRequest)
		return 0, 0, false
	}

	valueInt, err := strconv.Atoi(param)
	if err != nil {
		fmt.Printf("Bad Request - %s cannot be converted to int\n", logName)
		c.AbortWithStatus(http.StatusBadRequest)
		return 0, 0, false
	}

	valueUint, err := strconv.ParseUint(param, 10, 32)
	if err != nil {
		fmt.Printf("Bad Request - %s cannot be converted to uint\n", logName)
		c.AbortWithStatus(http.StatusBadRequest)
		return 0, 0, false
	}

	return valueInt, uint(valueUint), true

}

// CheckPostFormString - check string parameter from request
func CheckPostFormString(
	param string,
	logName string,
	c *gin.Context,
) (string, bool) {

	if param == "" {
		fmt.Printf("Bad Request - %s is empty\n", logName)
		c.AbortWithStatus(http.StatusBadRequest)
		return "", false
	}

	return param, true

}

// CheckPostFormBool - check boolean parameter from request
func CheckPostFormBool(
	param string,
	logName string,
	c *gin.Context,
) (bool, bool) {

	if param == "" {
		fmt.Printf("Bad Request - %s is empty\n", logName)
		c.AbortWithStatus(http.StatusBadRequest)
		return false, false
	}

	value, err := strconv.ParseBool(param)
	if err != nil {
		fmt.Printf("Bad Request - %s cannot be converted to Boolean\n", logName)
		c.AbortWithStatus(http.StatusBadRequest)
		return false, false
	}

	return value, true

}

// ErrorProcessAPI - handle error log
func ErrorProcessAPI(
	log string,
	httpStatusCode int,
	err error,
	c *gin.Context,
) {

	if httpStatusCode == http.StatusBadRequest {
		fmt.Printf("Bad Request - Failed to %s - %s\n", log, err.Error())
	} else if httpStatusCode == http.StatusInternalServerError {
		fmt.Printf("Server Error - Failed to %s - %s\n", log, err.Error())
	}
	c.AbortWithStatus(httpStatusCode)

}

// ErrorProcessAPI - handle error log
func ErrorProcessAPIWithoutError(
	log string,
	httpStatusCode int,
	c *gin.Context,
) {

	if httpStatusCode == http.StatusBadRequest {
		fmt.Printf("Bad Request -  %s\n", log)
	} else if httpStatusCode == http.StatusInternalServerError {
		fmt.Printf("Server Error - %s\n", log)
	}
	c.AbortWithStatus(httpStatusCode)

}

// ErrorProcessAPI - handle error log
func ErrorProcessAPIWithTx(
	log string,
	httpStatusCode int,
	err error,
	c *gin.Context,
	tx *sql.Tx,
) {

	if httpStatusCode == http.StatusBadRequest {
		fmt.Printf("Bad Request - Failed to %s - %s\n", log, err.Error())
	} else if httpStatusCode == http.StatusInternalServerError {
		fmt.Printf("Server Error - Failed to %s - %s\n", log, err.Error())
	}
	tx.Rollback()
	c.AbortWithStatus(httpStatusCode)

}

// ErrorProcessAPIWithoutC - handle error log with c
func ErrorProcessAPIWithoutC(
	log string,
	httpStatusCode int,
	err error,
) {

	if httpStatusCode == http.StatusBadRequest {
		fmt.Printf("Bad Request - Failed to %s - %s\n", log, err.Error())
	} else if httpStatusCode == http.StatusInternalServerError {
		fmt.Printf("Server Error - Failed to %s - %s\n", log, err.Error())
	}

}
