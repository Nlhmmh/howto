package utils

import (
	"database/sql"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

// ErrorProcessAPI - handle error log
func ErrorProcessAPI(
	log string,
	httpStatusCode int,
	err error,
	c *gin.Context,
) {

	// if httpStatusCode == http.StatusBadRequest {
	// 	fmt.Printf("Bad Request - Failed to %s - %s\n", log, err.Error())
	// } else if httpStatusCode == http.StatusInternalServerError {
	// 	fmt.Printf("Server Error - Failed to %s - %s\n", log, err.Error())
	// }
	fmt.Printf("Failed to %s - %s\n", log, err.Error())
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
