package controllers

import (
	"database/sql"
	"net/http"

	"github.com/gin-gonic/gin"
)

type ErrorResponse struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
	Error   string `json:"error"`
}

func AbortWithErrorResp(c *gin.Context, statusCode int, errResp ErrorResponse) {
	c.AbortWithStatusJSON(statusCode, errResp)
}

func BadRequestResp(c *gin.Context, err error) {
	AbortWithErrorResp(c, http.StatusBadRequest, ErrorResponse{Code: 4, Message: "Bad Request", Error: err.Error()})
}

func ServerErrorResp(c *gin.Context, err error) {
	AbortWithErrorResp(c, http.StatusInternalServerError, ErrorResponse{Code: 5, Message: "Server Error", Error: err.Error()})
}

// func ServerErrorRespWithTx(c *gin.Context, err error, tx *sql.Tx) {
// 	if err := tx.Rollback(); err != nil {
// 		ServerErrorResp(c, err)
// 		return
// 	}
// 	ServerErrorResp(c, err)
// }

func NotFoundResp(c *gin.Context, err error) {
	AbortWithErrorResp(c, http.StatusNotFound, ErrorResponse{Code: 10, Message: "Not Found", Error: err.Error()})
}

func UnAuthorizedResp(c *gin.Context, err error) {
	AbortWithErrorResp(c, http.StatusUnauthorized, ErrorResponse{Code: 10, Message: "UnAuthorized", Error: err.Error()})
}

func UserWithEmailNotExistResp(c *gin.Context, err error) {
	AbortWithErrorResp(c, http.StatusNotFound, ErrorResponse{Code: 11, Message: "User with email does not exist", Error: err.Error()})
}

func PasswordWrongResp(c *gin.Context, err error) {
	AbortWithErrorResp(c, http.StatusBadRequest, ErrorResponse{Code: 12, Message: "Password is wrong", Error: err.Error()})
}

func DisplayNameAlreadyExistResp(c *gin.Context, err error) {
	AbortWithErrorResp(c, http.StatusConflict, ErrorResponse{Code: 11, Message: "Display name already exists : ", Error: err.Error()})
}

func ContentTitleAlreadyExistResp(c *gin.Context, err error) {
	AbortWithErrorResp(c, http.StatusConflict, ErrorResponse{Code: 12, Message: "Content title already exists : ", Error: err.Error()})
}

func RespWithRollbackTx(
	c *gin.Context, er error, tx *sql.Tx,
	errRespFunc func(c *gin.Context, err error),
) {
	if err := tx.Rollback(); err != nil {
		ServerErrorResp(c, err)
		return
	}
	errRespFunc(c, er)
}
