package ctrls

import (
	"backend/boiler"
	"backend/ers"
	"backend/tx"
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

type content struct{}

var (
	Content *content
)

// *********************************************** //

func (o *content) List(c *gin.Context) {

	// Check Request
	var req ContentGetAllReq
	if err := c.BindQuery(&req); err != nil {
		ers.BadRequest.New(err).Abort(c)
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
		ers.InternalServer.New(err).Abort(c)
		return
	}

	if contentList == nil {
		contentList = []ContentWhole{}
	}

	c.JSON(http.StatusOK, RespList{List: contentList})

}

func (o *content) Get(c *gin.Context) {

	// Get contentID
	contentID, err := utils.CheckBlankString(c.Param("contentID"))
	if err != nil {
		ers.BadRequest.New(err).Abort(c)
		return
	}

	// Get Content
	var content ContentWhole
	if err := tx.Read(c, func(tx *sql.Tx) *ers.ErrResp {

		qms := []qm.QueryMod{}
		qms = append(qms, qm.Select(
			`
			contents.*, 
			user_profiles.display_name as user_name,
			content_categories.name as category_str,
			user_favourites.is_favourite as is_favourite
		`,
		))
		qms = append(qms, qm.From("contents"))
		qms = append(qms, qm.InnerJoin("user_profiles ON user_profiles.user_id = contents.user_id"))
		qms = append(qms, qm.InnerJoin("content_categories ON content_categories.id = contents.category_id"))
		qms = append(qms, qm.LeftOuterJoin("user_favourites ON user_favourites.content_id = ? AND user_favourites.content_id = contents.id", contentID))
		qms = append(qms, qm.Where("contents.id = ?", contentID))
		qms = append(qms, qm.Limit(1))

		if err := boiler.NewQuery(qms...).Bind(c, tx, &content); err != nil {
			return ers.InternalServer.New(err)
		}

		contentHtmlList, err := boiler.ContentHTMLS(
			qm.Where("content_id = ?", content.ID),
		).All(c, tx)
		if err != nil {
			return ers.InternalServer.New(err)
		}
		content.ContentHtmlList = contentHtmlList

		return nil

	}); err != nil {
		ers.InternalServer.New(err).Abort(c)
		return
	}

	c.JSON(http.StatusOK, content)

}

func (o *content) Create(c *gin.Context) {

	// Check Request
	var req CreateContentReq
	if err := c.ShouldBindJSON(&req); err != nil {
		ers.BadRequest.New(err).Abort(c)
		return
	}

	userID := c.GetString("userID")

	content := new(boiler.Content)
	if err := tx.Write(c, func(tx *sql.Tx) *ers.ErrResp {

		// Check Title
		titleExists, err := boiler.Contents(
			qm.Where("title = ?", req.Title),
		).Exists(c, tx)
		if err != nil {
			return ers.InternalServer.New(err)
		}
		if titleExists {
			return ers.ContentTitleAlreadyExist.New(errors.New("title already exists"))
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
			return ers.InternalServer.New(err)
		}

		for _, v := range req.ContentHtmlList {

			// Insert ContentHtml
			contentHtml := new(boiler.ContentHTML)
			contentHtml.ContentID = contentID
			contentHtml.OrderNo = v.OrderNo
			contentHtml.HTML = v.Html

			if err := contentHtml.Insert(c, tx, boil.Infer()); err != nil {
				return ers.InternalServer.New(err)
			}

		}

		return nil

	}); err != nil {
		return
	}

	c.JSON(http.StatusOK, content)

}

func (o *content) Delete(c *gin.Context) {

	// Check Request
	var req DeleteContentReq
	if err := c.ShouldBindJSON(&req); err != nil {
		ers.BadRequest.New(err).Abort(c)
		return
	}

	userID := c.GetString("userID")

	// Get Content
	content, err := boiler.Contents(
		boiler.ContentWhere.ID.EQ(req.ContentID),
		boiler.ContentWhere.UserID.EQ(userID),
	).OneG(c)
	if err != nil {
		ers.InternalServer.New(err).Abort(c)
		return
	}

	// Delete Content
	if _, err := content.DeleteG(c, true); err != nil {
		ers.InternalServer.New(err).Abort(c)
		return
	}

	// Delet Image
	File.Delete(content.ImageURL.String)

	c.JSON(http.StatusOK, RespMap{})

}

// *********************************************** //

func (o *content) Categories(c *gin.Context) {

	// Get All Content Categories
	contentCategoryList, err := boiler.ContentCategories().AllG(c)
	if err != nil {
		ers.InternalServer.New(err).Abort(c)
	}

	if contentCategoryList == nil {
		contentCategoryList = []*boiler.ContentCategory{}
	}

	c.JSON(http.StatusOK, RespList{List: contentCategoryList})

}

// *********************************************** //
