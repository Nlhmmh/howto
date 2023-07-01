package ers

import (
	"backend/logger"
	"database/sql"
	"net/http"

	"github.com/gin-gonic/gin"
)

var (
	BadRequest                = ErrResp{statusCode: http.StatusBadRequest, Code: 4, Message: "Bad Request"}
	InternalServer            = ErrResp{statusCode: http.StatusInternalServerError, Code: 5, Message: "Server Error"}
	NotFound                  = ErrResp{statusCode: http.StatusNotFound, Code: 10, Message: "Not Found"}
	UnAuthorized              = ErrResp{statusCode: http.StatusUnauthorized, Code: 10, Message: "UnAuthorized"}
	UserWithEmailNotExist     = ErrResp{statusCode: http.StatusNotFound, Code: 11, Message: "User with email does not exists"}
	UserWithEmailAlreadyExist = ErrResp{statusCode: http.StatusConflict, Code: 12, Message: "User with email already exists"}
	PasswordWrong             = ErrResp{statusCode: http.StatusBadRequest, Code: 13, Message: "Password is wrong"}
	DisplayNameAlreadyExist   = ErrResp{statusCode: http.StatusConflict, Code: 14, Message: "Display name already exists"}
	ContentTitleAlreadyExist  = ErrResp{statusCode: http.StatusConflict, Code: 15, Message: "Content title already exists"}
)

type ErrResp struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
	Error   string `json:"error"`

	statusCode int   `json:"-"`
	error      error `json:"-"`
}

func (e ErrResp) New(err error) *ErrResp {
	e.error = err
	return &e
}

func (e ErrResp) Abort(c *gin.Context) {
	e.Error = e.error.Error()
	logger.Err.Println(wrap(e.error).Error())
	c.AbortWithStatusJSON(e.statusCode, e)
}

func (e ErrResp) Rollback(c *gin.Context, tx *sql.Tx) {
	if err := tx.Rollback(); err != nil {
		InternalServer.Abort(c)
		return
	}
	e.Abort(c)
}
