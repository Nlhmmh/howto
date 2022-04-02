package controllers

import (
	"backend/models"
	"backend/utils"
	"context"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
)

// *********************************************** //

// FetchAllContents - Get All Contents
func FetchAllContents(c *gin.Context) {

	fmt.Println("API -- FetchAllContents")

	ctx := context.Background()

	// Get All Contents
	contents, err := models.Contents().AllG(ctx)
	if err != nil {
		utils.ErrorProcessAPI(
			"Get All Contents",
			http.StatusInternalServerError,
			err,
			c,
		)
		return
	}

	c.JSON(http.StatusOK, contents)

}
