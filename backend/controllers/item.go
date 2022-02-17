package controllers

import (
	"backend/models"
	"backend/utils"
	"context"
	"fmt"
	"net/http"

	"github.com/volatiletech/null/v8"

	"github.com/gin-gonic/gin"
	"github.com/volatiletech/sqlboiler/v4/boil"
	"github.com/volatiletech/sqlboiler/v4/queries/qm"
)

// *********************************************** //

// GetAllItems - Get All Items
func GetAllItems(c *gin.Context) {

	fmt.Println("API -- GetAllItems")

	ctx := context.Background()
	db := utils.GetDB()

	// Get offset
	offset, ok := utils.CheckPostFormInteger(c.PostForm("offset"), "offset")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get offset
	limit, ok := utils.CheckPostFormInteger(c.PostForm("limit"), "limit")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	queries := []qm.QueryMod{}
	queries = append(queries, qm.Offset(offset))
	queries = append(queries, qm.Limit(limit))

	// Get searchText
	searchText := c.PostForm("searchText")
	if searchText != "" {
		queries = append(queries, qm.Where("name LIKE ?", "%"+searchText+"%"))
	}

	// Get category
	category := c.PostForm("category")
	if category != "" {
		queries = append(queries, qm.Where("category = ?", category))
	}

	// Get All Items
	items, err := models.Items(queries...).All(ctx, db)
	if err != nil {
		fmt.Printf("Server Error - Get All Items %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, items)

}

// *********************************************** //

// GetCountItems - Get Count Items
func GetCountItems(c *gin.Context) {

	fmt.Println("API -- GetCountItems")

	ctx := context.Background()
	db := utils.GetDB()

	queries := []qm.QueryMod{}

	// Get searchText
	searchText := c.PostForm("searchText")
	if searchText != "" {
		queries = append(queries, qm.Where("name LIKE ?", "%"+searchText+"%"))
	}

	// Get category
	category := c.PostForm("category")
	if category != "" {
		queries = append(queries, qm.Where("category = ?", category))
	}

	// Count All Items
	count, err := models.Items(queries...).Count(ctx, db)
	if err != nil {
		fmt.Printf("Server Error - Count All Items %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, count)

}

// *********************************************** //

// SearchItems - Search Items
func SearchItems(c *gin.Context) {

	fmt.Println("API -- SearchItems")

	ctx := context.Background()
	db := utils.GetDB()

	queries := []qm.QueryMod{}

	// Get searchText
	searchText := c.PostForm("searchText")
	if searchText != "" {
		queries = append(queries, qm.Where("name LIKE ?", "%"+searchText+"%"))
	}

	// Get category
	category := c.PostForm("category")
	if category != "" {
		queries = append(queries, qm.Where("category = ?", category))
	}

	// Get All Items
	items, err := models.Items(queries...).All(ctx, db)
	if err != nil {
		fmt.Printf("Server Error - Get All Items %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, items)

}

// *********************************************** //

// GetItem - Get Item
func GetItem(c *gin.Context) {

	fmt.Println("API -- GetItem")

	ctx := context.Background()
	db := utils.GetDB()

	// Get id
	id, ok := utils.CheckPostFormInteger(c.PostForm("id"), "id")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Find Item
	item, err := models.FindItem(ctx, db, uint(id))
	if err != nil {
		fmt.Printf("Server Error - Find Item %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, item)

}

// *********************************************** //

// ItemInsert - Insert Item
func ItemInsert(c *gin.Context) {

	fmt.Println("API -- ItemInsert")

	ctx := context.Background()
	tx, err := utils.GetDB().BeginTx(ctx, nil)
	if err != nil {
		fmt.Println("Server Error : Transaction Begin Failed - ", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	// Get name
	name, ok := utils.CheckPostFormString(c.PostForm("name"), "name")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get category
	category, ok := utils.CheckPostFormString(c.PostForm("category"), "category")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get price
	price, ok := utils.CheckPostFormInteger(c.PostForm("price"), "price")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get discount
	discount, ok := utils.CheckPostFormInteger(c.PostForm("discount"), "discount")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get deliveryFee
	deliveryFee, ok := utils.CheckPostFormInteger(c.PostForm("deliveryFee"), "deliveryFee")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get weight
	weight, ok := utils.CheckPostFormInteger(c.PostForm("weight"), "weight")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get description
	description, ok := utils.CheckPostFormString(c.PostForm("description"), "description")
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

	// Get fileType
	fileType, ok := utils.CheckPostFormString(c.PostForm("fileType"), "fileType")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get file
	file, ok := utils.CheckPostFormString(c.PostForm("file"), "file")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	item := new(models.Item)
	item.Name = name
	item.Category = category
	item.Price = price
	item.Discount = null.IntFrom(discount)
	item.DeliveryFee = null.IntFrom(deliveryFee)
	item.Weight = null.IntFrom(weight)
	item.Description = null.StringFrom(description)
	item.Payment = null.StringFrom(payment)

	// Insert Item
	err = item.Insert(ctx, tx, boil.Infer())
	if err != nil {
		fmt.Printf("Server Error - Insert Item %s\n", err.Error())
		tx.Rollback()
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	image := new(models.Image)
	image.ItemID = uint(item.ID)
	image.FileType = fileType
	image.File = []byte(file)

	// Insert Image
	err = image.Insert(ctx, tx, boil.Infer())
	if err != nil {
		fmt.Printf("Server Error - Insert Image %s\n", err.Error())
		tx.Rollback()
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	tx.Commit()

	c.JSON(http.StatusOK, item)

}

// *********************************************** //

// ItemEdit - Edit Item
func ItemEdit(c *gin.Context) {

	fmt.Println("API -- ItemEdit")

	ctx := context.Background()
	tx, err := utils.GetDB().BeginTx(ctx, nil)
	if err != nil {
		fmt.Println("Server Error : Transaction Begin Failed - ", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	// Get id
	id, ok := utils.CheckPostFormInteger(c.PostForm("id"), "id")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get name
	name, ok := utils.CheckPostFormString(c.PostForm("name"), "name")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get category
	category, ok := utils.CheckPostFormString(c.PostForm("category"), "category")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get price
	price, ok := utils.CheckPostFormInteger(c.PostForm("price"), "price")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get discount
	discount, ok := utils.CheckPostFormInteger(c.PostForm("discount"), "discount")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get deliveryFee
	deliveryFee, ok := utils.CheckPostFormInteger(c.PostForm("deliveryFee"), "deliveryFee")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get weight
	weight, ok := utils.CheckPostFormInteger(c.PostForm("weight"), "weight")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get description
	description, ok := utils.CheckPostFormString(c.PostForm("description"), "description")
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

	// Get fileType
	fileType, ok := utils.CheckPostFormString(c.PostForm("fileType"), "fileType")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get file
	file, ok := utils.CheckPostFormString(c.PostForm("file"), "file")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Find Item
	item, err := models.FindItemG(ctx, uint(id))
	if err != nil {
		fmt.Printf("Server Error - Find Item %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	item.Name = name
	item.Category = category
	item.Price = price
	item.Discount = null.IntFrom(discount)
	item.DeliveryFee = null.IntFrom(deliveryFee)
	item.Weight = null.IntFrom(weight)
	item.Description = null.StringFrom(description)
	item.Payment = null.StringFrom(payment)

	// Update Item
	_, err = item.Update(ctx, tx, boil.Infer())
	if err != nil {
		fmt.Printf("Server Error - Update Item %s\n", err.Error())
		tx.Rollback()
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	// Find Image
	image, err := models.FindImageG(ctx, uint(id))
	if err != nil {
		fmt.Printf("Server Error - Find Image %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	image.FileType = fileType
	image.File = []byte(file)

	// Update Image
	_, err = image.Update(ctx, tx, boil.Infer())
	if err != nil {
		fmt.Printf("Server Error - Update Image %s\n", err.Error())
		tx.Rollback()
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	tx.Commit()

	c.JSON(http.StatusOK, item)

}

// *********************************************** //

// ItemDelete - Delete Item
func ItemDelete(c *gin.Context) {

	fmt.Println("API -- ItemDelete")

	ctx := context.Background()
	tx, err := utils.GetDB().BeginTx(ctx, nil)
	if err != nil {
		fmt.Println("Server Error : Transaction Begin Failed - ", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	// Get id
	id, ok := utils.CheckPostFormInteger(c.PostForm("id"), "id")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Find Item
	item, err := models.FindItemG(ctx, uint(id))
	if err != nil {
		fmt.Printf("Server Error - Find Item %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	// Delete Item
	_, err = item.Delete(ctx, tx, false)
	if err != nil {
		fmt.Printf("Server Error - Delete Item %s\n", err.Error())
		tx.Rollback()
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	// Find Image
	image, err := models.FindImageG(ctx, uint(id))
	if err != nil {
		fmt.Printf("Server Error - Find Image %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	// Delete Image
	_, err = image.Delete(ctx, tx, false)
	if err != nil {
		fmt.Printf("Server Error - Delete Image %s\n", err.Error())
		tx.Rollback()
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	tx.Commit()

	c.Status(http.StatusOK)

}
