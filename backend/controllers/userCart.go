package controllers

import (
	"backend/models"
	"backend/utils"
	"context"
	"fmt"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/volatiletech/sqlboiler/v4/boil"
	"github.com/volatiletech/sqlboiler/v4/queries/qm"
)

type cartResp struct {
	Status   string           `json:"status"` // delete, update
	UserCart *models.UserCart `json:"userCart"`
}

// *********************************************** //

// CartGetAllItems - Get All Items from User Cart
func CartGetAllItems(c *gin.Context) {

	fmt.Println("API -- CartGetAllItems")

	ctx := context.Background()

	// Get user_id
	userID, ok := utils.CheckPostFormInteger(c.PostForm("userID"), "userID")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get All Items from UserCart
	userCarts, err := models.UserCarts(
		qm.Where("user_id=?", userID),
		qm.Where("ordered=false"),
	).AllG(ctx)
	if err != nil {
		fmt.Printf("Server Error - Get All Items from UserCart %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, userCarts)

}

// *********************************************** //

// CartItemInsert - Insert Item into User Cart
func CartItemInsert(c *gin.Context) {

	fmt.Println("API -- CartItemInsert")

	ctx := context.Background()

	// Get user_id
	userID, ok := utils.CheckPostFormInteger(c.PostForm("userID"), "userID")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get item_id
	itemID, ok := utils.CheckPostFormInteger(c.PostForm("itemID"), "itemID")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get count
	count, ok := utils.CheckPostFormInteger(c.PostForm("count"), "count")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Find userCart
	userCarts, err := models.UserCarts(
		qm.Where("item_id=?", itemID),
	).AllG(ctx)
	if err != nil {
		fmt.Printf("Server Error - Find userCart %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	// IF userCart already exist
	if len(userCarts) > 0 {

		userCart := userCarts[0]
		userCart.Count = userCart.Count + count

		// Update userCart
		_, err = userCart.UpdateG(ctx, boil.Infer())
		if err != nil {
			fmt.Printf("Server Error - Update userCart %s\n", err.Error())
			c.AbortWithStatus(http.StatusInternalServerError)
			return
		}

		c.JSON(http.StatusOK, userCart)

	} else {

		// Find Item
		item, err := models.FindItemG(ctx, uint(itemID))
		if err != nil {
			fmt.Printf("Server Error - Find Item %s\n", err.Error())
			c.AbortWithStatus(http.StatusInternalServerError)
			return
		}

		userCart := new(models.UserCart)
		userCart.UserID = uint(userID)
		userCart.ItemID = uint(itemID)
		userCart.Ordered = false
		userCart.Name = item.Name
		userCart.Count = count
		userCart.Price = item.Price
		userCart.Discount = item.Discount

		// Insert Item
		err = userCart.InsertG(ctx, boil.Greylist(models.UserCartColumns.Ordered))
		if err != nil {
			fmt.Printf("Server Error - Insert Item %s\n", err.Error())
			c.AbortWithStatus(http.StatusInternalServerError)
			return
		}

		c.JSON(http.StatusOK, userCart)

	}

}

// *********************************************** //

// CartItemChangeCount - Change count of Item into User Cart
func CartItemChangeCount(c *gin.Context) {

	fmt.Println("API -- CartItemChangeCount")

	ctx := context.Background()

	// Get id
	id, ok := utils.CheckPostFormInteger(c.PostForm("id"), "id")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get count
	count, ok := utils.CheckPostFormInteger(c.PostForm("count"), "count")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Find userCart
	userCart, err := models.FindUserCartG(ctx, uint(id))
	if err != nil {
		fmt.Printf("Server Error - Find userCart %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	if userCart.Count+count <= 0 {

		// Delete userCart
		_, err := userCart.DeleteG(ctx, false)
		if err != nil {
			fmt.Printf("Server Error - Delete userCart %s\n", err.Error())
			c.AbortWithStatus(http.StatusInternalServerError)
			return
		}

		c.JSON(http.StatusOK, cartResp{
			Status:   "delete",
			UserCart: userCart})

	} else {

		userCart.Count = userCart.Count + count

		// Update userCart
		_, err = userCart.UpdateG(ctx, boil.Infer())
		if err != nil {
			fmt.Printf("Server Error - Update userCart %s\n", err.Error())
			c.AbortWithStatus(http.StatusInternalServerError)
			return
		}

		c.JSON(http.StatusOK, cartResp{
			Status:   "update",
			UserCart: userCart})

	}

}

// *********************************************** //

// CartItemDelete - Delete Item from User Cart
func CartItemDelete(c *gin.Context) {

	fmt.Println("API -- CartItemDelete")

	ctx := context.Background()

	// Get id
	id, ok := utils.CheckPostFormInteger(c.PostForm("id"), "id")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Find userCart
	userCart, err := models.FindUserCartG(ctx, uint(id))
	if err != nil {
		fmt.Printf("Server Error - Find userCart %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	// Delete userCart
	_, err = userCart.DeleteG(ctx, false)
	if err != nil {
		fmt.Printf("Server Error - Delete userCart %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	c.Status(http.StatusOK)

}
