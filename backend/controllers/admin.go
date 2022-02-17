package controllers

import (
	"backend/models"
	"context"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/volatiletech/sqlboiler/v4/queries/qm"
)

// *********************************************** //

// AdminGetAllOrders - Get All Orders (Admin)
func AdminGetAllOrders(c *gin.Context) {

	fmt.Println("API -- AdminGetAllOrders")

	ctx := context.Background()

	queries := []qm.QueryMod{}

	// Get offset
	offset := c.PostForm("offset")
	if offset != "" {
		offset, err := strconv.Atoi(offset)
		if err != nil {
			fmt.Printf("Bad Request - offset is empty\n")
			c.AbortWithStatus(http.StatusBadRequest)
			return
		}
		queries = append(queries, qm.Offset(offset))
	}
	// Get limit
	limit := c.PostForm("limit")
	if limit != "" {
		limit, err := strconv.Atoi(limit)
		if err != nil {
			fmt.Printf("Bad Request - limit is empty\n")
			c.AbortWithStatus(http.StatusBadRequest)
			return
		}
		queries = append(queries, qm.Limit(limit))
	}

	// Admin Get All Orders
	userOrders, err := models.UserOrders(queries...).AllG(ctx)
	if err != nil {
		fmt.Printf("Server Error - Admin Get All Orders %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, userOrders)

}
