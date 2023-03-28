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

type ErrRespFunc func(c *gin.Context, err error)

func abortWithErrResp(c *gin.Context, statusCode int, errResp ErrorResponse) {
	c.AbortWithStatusJSON(statusCode, errResp)
}

func BadRequestResp(c *gin.Context, err error) {
	abortWithErrResp(c, http.StatusBadRequest, ErrorResponse{Code: 4, Message: "Bad Request", Error: err.Error()})
}

func ServerErrorResp(c *gin.Context, err error) {
	abortWithErrResp(c, http.StatusInternalServerError, ErrorResponse{Code: 5, Message: "Server Error", Error: err.Error()})
}

func NotFoundResp(c *gin.Context, err error) {
	abortWithErrResp(c, http.StatusNotFound, ErrorResponse{Code: 10, Message: "Not Found", Error: err.Error()})
}

func UnAuthorizedResp(c *gin.Context, err error) {
	abortWithErrResp(c, http.StatusUnauthorized, ErrorResponse{Code: 10, Message: "UnAuthorized", Error: err.Error()})
}

func UserWithEmailNotExistResp(c *gin.Context, err error) {
	abortWithErrResp(c, http.StatusNotFound, ErrorResponse{Code: 11, Message: "User with email does not exist", Error: err.Error()})
}

func UserWithEmailAlreadyExistResp(c *gin.Context, err error) {
	abortWithErrResp(c, http.StatusNotFound, ErrorResponse{Code: 12, Message: "User with email already exist", Error: err.Error()})
}

func PasswordWrongResp(c *gin.Context, err error) {
	abortWithErrResp(c, http.StatusBadRequest, ErrorResponse{Code: 13, Message: "Password is wrong", Error: err.Error()})
}

func DisplayNameAlreadyExistResp(c *gin.Context, err error) {
	abortWithErrResp(c, http.StatusConflict, ErrorResponse{Code: 14, Message: "Display name already exists : ", Error: err.Error()})
}

func ContentTitleAlreadyExistResp(c *gin.Context, err error) {
	abortWithErrResp(c, http.StatusConflict, ErrorResponse{Code: 15, Message: "Content title already exists : ", Error: err.Error()})
}

func RespWithRollbackTx(c *gin.Context, er error, tx *sql.Tx, errRespFunc ErrRespFunc) {
	if err := tx.Rollback(); err != nil {
		ServerErrorResp(c, err)
		return
	}
	errRespFunc(c, er)
}
