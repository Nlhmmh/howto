package controllers

// import (
// 	"backend/models"
// 	"backend/utils"
// 	"context"
// 	"fmt"
// 	"net/http"

// 	"github.com/gin-gonic/gin"
// 	"github.com/volatiletech/null"
// 	"github.com/volatiletech/sqlboiler/v4/queries/qm"
// )

// type ContentWithUserName struct {
// 	ID        uint      `boil:"id" json:"id" toml:"id" yaml:"id"`
// 	UserID    uint      `boil:"user_id" json:"userID" toml:"userID" yaml:"userID"`
// 	Title     string    `boil:"title" json:"title" toml:"title" yaml:"title"`
// 	Category  string    `boil:"category" json:"category" toml:"category" yaml:"category"`
// 	ViewCount int       `boil:"view_count" json:"viewCount" toml:"viewCount" yaml:"viewCount"`
// 	CreatedAt null.Time `boil:"created_at" json:"createdAt,omitempty" toml:"createdAt" yaml:"createdAt,omitempty"`
// 	UpdatedAt null.Time `boil:"updated_at" json:"updatedAt,omitempty" toml:"updatedAt" yaml:"updatedAt,omitempty"`
// 	DeletedAt null.Time `boil:"deleted_at" json:"deletedAt,omitempty" toml:"deletedAt" yaml:"deletedAt,omitempty"`

// 	UserName string `boil:"user_name" json:"userName" toml:"userName" yaml:"userName"`
// }

// // *********************************************** //

// // FetchAllContents - Get All Contents
// func FetchAllContents(c *gin.Context) {

// 	fmt.Println("API -- FetchAllContents")

// 	ctx := context.Background()

// 	// Get All Contents
// 	var contentList []ContentWithUserName
// 	if err := models.NewQuery(
// 		qm.Select("contents.*, users.display_name as user_name"),
// 		qm.From("contents"),
// 		qm.InnerJoin("users ON users.id = contents.user_id"),
// 		qm.OrderBy("updated_at DESC"),
// 	).BindG(ctx, &contentList); err != nil {
// 		utils.ErrorProcessAPI(
// 			"Get All Contents",
// 			http.StatusInternalServerError,
// 			err,
// 			c,
// 		)
// 		return
// 	}

// 	c.JSON(http.StatusOK, contentList)

// }

// // *********************************************** //

// // CreateContent - Create Content
// // func CreateContent(c *gin.Context) {

// // 	fmt.Println("API -- CreateContent")

// // 	ctx := context.Background()

// // 	// Get id
// // 	_, userID, ok := utils.CheckPostFormInteger(c.PostForm("userID"), "userID", c)
// // 	if !ok {
// // 		return
// // 	}

// // 	// Get title
// // 	title, ok := utils.CheckPostFormString(c.PostForm("title"), "title", c)
// // 	if !ok {
// // 		return
// // 	}

// // 	// Get category
// // 	category, ok := utils.CheckPostFormString(c.PostForm("category"), "category", c)
// // 	if !ok {
// // 		return
// // 	}

// // 	// Insert Content
// // 	content := new(models.Content)
// // 	content.UserID = userID
// // 	content.Title = title
// // 	content.Category = category

// // 	if err := content.InsertG(ctx, boil.Infer()); err != nil {
// // 		utils.ErrorProcessAPI(
// // 			"Insert User",
// // 			http.StatusInternalServerError,
// // 			err,
// // 			c,
// // 		)
// // 		return
// // 	}

// // 	c.Status(http.StatusOK)

// // }
