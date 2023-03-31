package ctrls

import (
	"backend/ers"
	"database/sql"

	"github.com/gin-gonic/gin"
	"github.com/volatiletech/sqlboiler/v4/boil"
)

func ReadTx(c *gin.Context, innerFunc func(tx *sql.Tx) (ers.ErrRespFunc, error)) error {

	tx, err := boil.BeginTx(c, &sql.TxOptions{ReadOnly: true})
	if err != nil {
		ers.ServerErrorResp(c, err)
		return err
	}

	if errRespFunc, err := innerFunc(tx); err != nil {
		ers.RespWithRollbackTx(c, err, tx, errRespFunc)
		return err
	}

	if err := tx.Commit(); err != nil {
		ers.ServerErrorResp(c, err)
		return err
	}

	return nil

}

func WriteTx(c *gin.Context, innerFunc func(tx *sql.Tx) (ers.ErrRespFunc, error)) error {

	tx, err := boil.BeginTx(c, &sql.TxOptions{ReadOnly: false})
	if err != nil {
		ers.ServerErrorResp(c, err)
		return err
	}

	if errRespFunc, err := innerFunc(tx); err != nil {
		ers.RespWithRollbackTx(c, err, tx, errRespFunc)
		return err
	}

	if err := tx.Commit(); err != nil {
		ers.ServerErrorResp(c, err)
		return err
	}

	return nil

}
