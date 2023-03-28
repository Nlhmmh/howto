package controllers

import (
	"database/sql"

	"github.com/gin-gonic/gin"
	"github.com/volatiletech/sqlboiler/v4/boil"
)

func ReadTx(c *gin.Context, innerFunc func(tx *sql.Tx) (ErrRespFunc, error)) {

	tx, err := boil.BeginTx(c, &sql.TxOptions{ReadOnly: true})
	if err != nil {
		ServerErrorResp(c, err)
		return
	}

	if errRespFunc, err := innerFunc(tx); err != nil {
		RespWithRollbackTx(c, err, tx, errRespFunc)
		return
	}

	if err := tx.Commit(); err != nil {
		ServerErrorResp(c, err)
		return
	}

}

func WriteTx(c *gin.Context, innerFunc func(tx *sql.Tx) (ErrRespFunc, error)) {

	tx, err := boil.BeginTx(c, &sql.TxOptions{ReadOnly: false})
	if err != nil {
		ServerErrorResp(c, err)
		return
	}

	if errRespFunc, err := innerFunc(tx); err != nil {
		RespWithRollbackTx(c, err, tx, errRespFunc)
		return
	}

	if err := tx.Commit(); err != nil {
		ServerErrorResp(c, err)
		return
	}

}
