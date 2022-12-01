package controllers

import (
	"backend/boiler"
	"database/sql"
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/volatiletech/sqlboiler/v4/boil"
	"github.com/volatiletech/sqlboiler/v4/queries/qm"
)

type contentCtrl struct{}

var (
	contentCtrls *contentCtrl
)

// *********************************************** //

func (o *contentCtrl) GetAll(c *gin.Context) {

	// Check Request
	var resq ContentGetAllRequest
	if err := c.BindQuery(&resq); err != nil {
		BadRequestResp(c, err)
		return
	}

	// Get All Contents
	var contentList []ContentWithUserName

	qms := []qm.QueryMod{}
	qms = append(qms, qm.Select(
		`
			contents.*, 
			user_profiles.display_name as user_name,
			content_categories.name as category_str
		`,
	))
	qms = append(qms, qm.From("contents"))
	qms = append(qms, qm.InnerJoin("user_profiles ON user_profiles.user_id = contents.user_id"))
	qms = append(qms, qm.InnerJoin("content_categories ON content_categories.id = contents.category_id"))

	// Limit
	if resq.Limit > 0 {
		qms = append(qms, qm.Limit(resq.Limit))
	} else {
		qms = append(qms, qm.Limit(20))
	}
	// Offset
	if resq.Offset > 0 {
		qms = append(qms, qm.Offset(resq.Offset))
	} else {
		qms = append(qms, qm.Offset(0))
	}
	// SortBy
	switch resq.SortBy {
	case "LATEST":
		qms = append(qms, qm.OrderBy("updated_at DESC"))
	case "OLDEST":
		qms = append(qms, qm.OrderBy("updated_at ASC"))
	default:
		qms = append(qms, qm.OrderBy("updated_at DESC"))
	}

	if err := boiler.NewQuery(qms...).BindG(c, &contentList); err != nil {
		ServerErrorResp(c, err)
		return
	}

	c.JSON(http.StatusOK, contentList)

}

// *********************************************** //

func (o *contentCtrl) CreateContent(c *gin.Context) {

	// Check Request
	var resq CreateContentRequest
	if err := c.ShouldBindJSON(&resq); err != nil {
		BadRequestResp(c, err)
		return
	}

	userID := c.GetString("userID")

	WriteTransaction(c, func(tx *sql.Tx) bool {

		// Check DisplayName
		titleExists, err := boiler.Contents(
			qm.Where("title = ?", resq.Title),
		).Exists(c, tx)
		if err != nil {
			RespWithRollbackTx(c, err, tx, ServerErrorResp)
			return true
		}
		if titleExists {
			RespWithRollbackTx(c, errors.New("title already exists"), tx, ContentTitleAlreadyExistResp)
			return true
		}

		// Insert Content
		content := new(boiler.Content)
		content.ID = uuid.NewString()
		content.UserID = userID
		content.Title = resq.Title
		content.CategoryID = resq.CategoryID

		if err := content.Insert(c, tx, boil.Infer()); err != nil {
			RespWithRollbackTx(c, err, tx, ServerErrorResp)
			return true
		}

		c.JSON(http.StatusOK, content)
		return false

	})

}
