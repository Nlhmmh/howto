package tx

import (
	"backend/ers"
	"database/sql"

	"github.com/gin-gonic/gin"
	"github.com/volatiletech/sqlboiler/v4/boil"
)

func Read(c *gin.Context, innerFunc func(tx *sql.Tx) *ers.ErrResp) error {

	tx, err := boil.BeginTx(c, &sql.TxOptions{ReadOnly: true})
	if err != nil {
		ers.InternalServer.New(err).Abort(c)
		return err
	}

	if errResp := innerFunc(tx); errResp != nil {
		errResp.Rollback(c, tx)
		return err
	}

	if err := tx.Commit(); err != nil {
		ers.InternalServer.New(err).Abort(c)
		return err
	}

	return nil

}

func Write(c *gin.Context, innerFunc func(tx *sql.Tx) *ers.ErrResp) error {

	tx, err := boil.BeginTx(c, &sql.TxOptions{ReadOnly: false})
	if err != nil {
		ers.InternalServer.New(err).Abort(c)
		return err
	}

	if errResp := innerFunc(tx); errResp != nil {
		errResp.Rollback(c, tx)
		return err
	}

	if err := tx.Commit(); err != nil {
		ers.InternalServer.New(err).Abort(c)
		return err
	}

	return nil

}
