package controllers

import (
	"backend/models"
	"backend/utils"
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/volatiletech/null/v8"
	"github.com/volatiletech/sqlboiler/v4/boil"
	"github.com/volatiletech/sqlboiler/v4/queries/qm"
)

// *********************************************** //

// GetAllUserOrders - Get All User Orders
func GetAllUserOrders(c *gin.Context) {

	fmt.Println("API -- GetAllUserOrders")

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

	// Get user_id
	userID, ok := utils.CheckPostFormInteger(c.PostForm("userID"), "userID")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}
	queries = append(queries, qm.Where("user_id=?", userID))

	// Get All User Orders
	userOrders, err := models.UserOrders(queries...).AllG(ctx)
	if err != nil {
		fmt.Printf("Server Error - Get All User Orders %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, userOrders)

}

// *********************************************** //

// GetCountUserOrders - Get Count User Orders
func GetCountUserOrders(c *gin.Context) {

	fmt.Println("API -- GetCountUserOrders")

	ctx := context.Background()
	db := utils.GetDB()

	queries := []qm.QueryMod{}

	// Count All User Orders
	count, err := models.UserOrders(queries...).Count(ctx, db)
	if err != nil {
		fmt.Printf("Server Error - Count All User Orders %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, count)

}

// *********************************************** //

// AddOrder - Add Order
func AddOrder(c *gin.Context) {

	fmt.Println("API -- AddOrder")

	ctx := context.Background()
	tx, err := utils.GetDB().BeginTx(ctx, nil)
	if err != nil {
		fmt.Println("Server Error : Transaction Begin Failed - ", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	// Get user_id
	userID, ok := utils.CheckPostFormInteger(c.PostForm("userID"), "userID")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get addressID
	addressID, ok := utils.CheckPostFormInteger(c.PostForm("addressID"), "addressID")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get total
	total, ok := utils.CheckPostFormInteger(c.PostForm("total"), "total")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get payment
	payment, ok := utils.CheckPostFormString(c.PostForm("payment"), "payment")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get status
	status, ok := utils.CheckPostFormString(c.PostForm("status"), "status")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get cartItems
	cartItems, ok := utils.CheckPostFormString(c.PostForm("cartItems"), "cartItems")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}
	var cartItemsParsed []int
	if err := json.Unmarshal([]byte(cartItems), &cartItemsParsed); err != nil {
		fmt.Printf("Server Error - JSON cartItems cannot be parsed %s\n", err.Error())
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}
	fmt.Println("parsed", cartItemsParsed)

	// Insert User Order
	userOrder := new(models.UserOrder)
	userOrder.UserID = uint(userID)
	userOrder.AddressID = uint(addressID)
	userOrder.Total = total
	userOrder.Payment = payment
	userOrder.Status = status

	err = userOrder.Insert(ctx, tx, boil.Infer())
	if err != nil {
		fmt.Printf("Server Error - Insert User Order %s\n", err.Error())
		tx.Rollback()
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	// Update Cart Items
	for _, userCartID := range cartItemsParsed {

		// Find User Cart
		userCart, err := models.FindUserCart(ctx, tx, uint(userCartID))
		if err != nil {
			fmt.Printf("Server Error - Find User Cart %s\n", err.Error())
			tx.Rollback()
			c.AbortWithStatus(http.StatusInternalServerError)
			return
		}

		userCart.OrderID = null.UintFrom(userOrder.ID)
		userCart.Ordered = true

		// UpdateUser Cart
		_, err = userCart.Update(ctx, tx, boil.Infer())
		if err != nil {
			fmt.Printf("Server Error - Update User Cart %s\n", err.Error())
			tx.Rollback()
			c.AbortWithStatus(http.StatusInternalServerError)
			return
		}

	}

	tx.Commit()

	c.JSON(http.StatusOK, userOrder)

}

// *********************************************** //

// GetCartItemsOfUserOrder - Get Cart Items of User Order
func GetCartItemsOfUserOrder(c *gin.Context) {

	fmt.Println("API -- GetCartItemsOfUserOrder")

	ctx := context.Background()

	// Get id
	orderID, ok := utils.CheckPostFormInteger(c.PostForm("orderID"), "orderID")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get All User Carts
	userCarts, err := models.UserCarts(
		qm.Where("order_id=?", orderID),
	).AllG(ctx)
	if err != nil {
		fmt.Printf("Server Error - Get All User Carts %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, userCarts)

}

// *********************************************** //

// GetOrder - Get Order
func GetOrder(c *gin.Context) {

	fmt.Println("API -- GetOrder")

	ctx := context.Background()

	// Get id
	id, ok := utils.CheckPostFormInteger(c.PostForm("id"), "id")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get User Order
	userOrder, err := models.FindUserOrderG(ctx, uint(id))
	if err != nil {
		fmt.Printf("Server Error - Get User Order %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, userOrder)

}
