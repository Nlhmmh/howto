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

// *********************************************** //

// GetAllUserAddress - Get User Addresses
func GetAllUserAddress(c *gin.Context) {

	fmt.Println("API -- GetAllUserAddress")

	ctx := context.Background()

	// Get user_id
	userID, ok := utils.CheckPostFormInteger(c.PostForm("userID"), "userID")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get All User Addresses
	userCarts, err := models.UserAddresses(
		qm.Where("user_id=?", userID),
	).AllG(ctx)
	if err != nil {
		fmt.Printf("Server Error - Get All User Addresses %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, userCarts)

}

// *********************************************** //

// UserAddressInsert - Insert User Address
func UserAddressInsert(c *gin.Context) {

	fmt.Println("API -- UserAddressInsert")

	ctx := context.Background()

	// Get user_id
	userID, ok := utils.CheckPostFormInteger(c.PostForm("userID"), "userID")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get addressName
	addressName, ok := utils.CheckPostFormString(c.PostForm("addressName"), "addressName")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get postCode
	postCode, ok := utils.CheckPostFormString(c.PostForm("postCode"), "postCode")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get address1
	address1, ok := utils.CheckPostFormString(c.PostForm("address1"), "address1")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get address2
	address2, ok := utils.CheckPostFormString(c.PostForm("address2"), "address2")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get address3
	address3, ok := utils.CheckPostFormString(c.PostForm("address3"), "address3")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Insert User Address
	userAddress := new(models.UserAddress)
	userAddress.UserID = uint(userID)
	userAddress.AddressName = addressName
	userAddress.PostCode = postCode
	userAddress.Address1 = address1
	userAddress.Address2 = address2
	userAddress.Address3 = address3

	err := userAddress.InsertG(ctx, boil.Infer())
	if err != nil {
		fmt.Printf("Server Error - Insert User Address %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, userAddress)

}

// *********************************************** //

// UserAddressEdit - Edit User Address
func UserAddressEdit(c *gin.Context) {

	fmt.Println("API -- UserAddressEdit")

	ctx := context.Background()

	// Get id
	id, ok := utils.CheckPostFormInteger(c.PostForm("id"), "id")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get addressName
	addressName, ok := utils.CheckPostFormString(c.PostForm("addressName"), "addressName")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get postCode
	postCode, ok := utils.CheckPostFormString(c.PostForm("postCode"), "postCode")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get address1
	address1, ok := utils.CheckPostFormString(c.PostForm("address1"), "address1")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get address2
	address2, ok := utils.CheckPostFormString(c.PostForm("address2"), "address2")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get address3
	address3, ok := utils.CheckPostFormString(c.PostForm("address3"), "address3")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Find User Address
	userAddress, err := models.FindUserAddressG(ctx, uint(id))
	if err != nil {
		fmt.Printf("Server Error - Find User Address %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	userAddress.AddressName = addressName
	userAddress.PostCode = postCode
	userAddress.Address1 = address1
	userAddress.Address2 = address2
	userAddress.Address3 = address3

	// Update User Address
	_, err = userAddress.UpdateG(ctx, boil.Infer())
	if err != nil {
		fmt.Printf("Server Error - Update User Address %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, userAddress)

}

// *********************************************** //

// UserAddressDelete - Delete User Address
func UserAddressDelete(c *gin.Context) {

	fmt.Println("API -- UserAddressDelete")

	ctx := context.Background()

	// Get id
	id, ok := utils.CheckPostFormInteger(c.PostForm("id"), "id")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Find User Address
	userAddress, err := models.FindUserAddressG(ctx, uint(id))
	if err != nil {
		fmt.Printf("Server Error - Find User Address %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	// Delete User Address
	_, err = userAddress.DeleteG(ctx, false)
	if err != nil {
		fmt.Printf("Server Error - Delete User Address %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, id)

}
