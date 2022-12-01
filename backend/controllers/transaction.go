package controllers

import (
	"database/sql"

	"github.com/gin-gonic/gin"
	"github.com/volatiletech/sqlboiler/v4/boil"
)

func ReadOnlyTransaction(c *gin.Context, innerFunc func(tx *sql.Tx) bool) {

	tx, err := boil.BeginTx(c, &sql.TxOptions{ReadOnly: true})
	if err != nil {
		ServerErrorResp(c, err)
		return
	}

	skipCommit := innerFunc(tx)
	if skipCommit {
		return
	}

	if err := tx.Commit(); err != nil {
		ServerErrorResp(c, err)
		return
	}

}

func WriteTransaction(c *gin.Context, innerFunc func(tx *sql.Tx) bool) {

	tx, err := boil.BeginTx(c, &sql.TxOptions{ReadOnly: false})
	if err != nil {
		ServerErrorResp(c, err)
		return
	}

	skipCommit := innerFunc(tx)
	if skipCommit {
		return
	}

	if err := tx.Commit(); err != nil {
		ServerErrorResp(c, err)
		return
	}

}
