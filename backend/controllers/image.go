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

// GetImage - Get Image
func GetImage(c *gin.Context) {

	fmt.Println("API -- GetImage")

	ctx := context.Background()

	// Get itemID
	itemID, ok := utils.CheckPostFormInteger(c.PostForm("itemID"), "itemID")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Find image
	image, err := models.FindImageG(ctx, uint(itemID))
	if err != nil {
		fmt.Printf("Server Error - Find image %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, image)

}
