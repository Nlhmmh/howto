package ctrls

import (
	"backend/boiler"
	"backend/ers"
	"backend/utils"
	"database/sql"
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/volatiletech/null/v8"
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
	var req ContentGetAllReq
	if err := c.BindQuery(&req); err != nil {
		ers.BadRequestResp(c, err)
		return
	}

	// Get All Contents
	var contentList []ContentWhole

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
	if req.Limit > 0 {
		qms = append(qms, qm.Limit(req.Limit))
	} else {
		qms = append(qms, qm.Limit(20))
	}
	// Offset
	if req.Offset > 0 {
		qms = append(qms, qm.Offset(req.Offset))
	} else {
		qms = append(qms, qm.Offset(0))
	}
	// SortBy
	switch req.SortBy {
	case "DATE_DESC":
		qms = append(qms, qm.OrderBy("contents.updated_at DESC"))
	case "DATE_ASC":
		qms = append(qms, qm.OrderBy("contents.updated_at ASC"))
	default:
		qms = append(qms, qm.OrderBy("contents.updated_at DESC"))
	}
	// SearchTitle
	if req.SearchTitle != "" {
		qms = append(qms, qm.Where("contents.title LIKE ?", "%"+req.SearchTitle+"%"))
	}
	// SearchCatID
	if req.SearchCatID > 0 {
		qms = append(qms, qm.Where("contents.category_id = ?", req.SearchCatID))
	}
	// SearchUserID
	if req.SearchUserID != "" {
		qms = append(qms, qm.Where("contents.user_id = ?", req.SearchUserID))
	}

	if err := boiler.NewQuery(qms...).BindG(c, &contentList); err != nil {
		ers.ServerErrorResp(c, err)
		return
	}

	if contentList == nil {
		contentList = []ContentWhole{}
	}

	c.JSON(http.StatusOK, contentList)

}

// *********************************************** //

func (o *contentCtrl) CreateContentWhole(c *gin.Context) {

	// Check Request
	var req CreateContentReq
	if err := c.ShouldBindJSON(&req); err != nil {
		ers.BadRequestResp(c, err)
		return
	}

	userID := c.GetString("userID")

	content := new(boiler.Content)
	WriteTx(c, func(tx *sql.Tx) (ers.ErrRespFunc, error) {

		// Check Title
		titleExists, err := boiler.Contents(
			qm.Where("title = ?", req.Title),
		).Exists(c, tx)
		if err != nil {
			return ers.ServerErrorResp, err
		}
		if titleExists {
			return ers.ContentTitleAlreadyExistResp, errors.New("title already exists")
		}

		contentID := uuid.NewString()

		// Insert Content
		content.ID = contentID
		content.UserID = userID
		content.Title = req.Title
		content.CategoryID = req.CategoryID
		if req.ImageUrl != "" {
			content.ImageURL = null.StringFrom(req.ImageUrl)
		}

		if err := content.Insert(c, tx, boil.Infer()); err != nil {
			return ers.ServerErrorResp, err
		}

		for _, v := range req.ContentHtmlList {

			// Insert ContentHtml
			contentHtml := new(boiler.ContentHTML)
			contentHtml.ContentID = contentID
			contentHtml.OrderNo = v.OrderNo
			contentHtml.HTML = v.Html

			if err := contentHtml.Insert(c, tx, boil.Infer()); err != nil {
				return ers.ServerErrorResp, err
			}

		}

		return nil, nil

	})

	c.JSON(http.StatusOK, content)

}

func (o *contentCtrl) GetOne(c *gin.Context) {

	// Get contentID
	contentID, err := utils.CheckBlankString(c.Param("contentID"))
	if err != nil {
		ers.BadRequestResp(c, err)
		return
	}

	// Get Content
	var content ContentWhole
	ReadTx(c, func(tx *sql.Tx) (ers.ErrRespFunc, error) {

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
		qms = append(qms, qm.Where("contents.id = ?", contentID))
		qms = append(qms, qm.Limit(1))

		if err := boiler.NewQuery(qms...).Bind(c, tx, &content); err != nil {
			return ers.ServerErrorResp, err
		}

		contentHtmlList, err := boiler.ContentHTMLS(
			qm.Where("content_id = ?", content.ID),
		).All(c, tx)
		if err != nil {
			return ers.ServerErrorResp, err
		}
		content.ContentHtmlList = contentHtmlList

		return nil, nil

	})

	c.JSON(http.StatusOK, content)

}

// *********************************************** //

func (o *contentCtrl) GetAllCategories(c *gin.Context) {

	// Get All Content Categories
	contentCategoryList, err := boiler.ContentCategories().AllG(c)
	if err != nil {
		ers.ServerErrorResp(c, err)
	}

	if contentCategoryList == nil {
		contentCategoryList = []*boiler.ContentCategory{}
	}

	c.JSON(http.StatusOK, contentCategoryList)

}
