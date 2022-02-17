package main

import (
	"backend/controllers"
	"backend/utils"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	_ "github.com/go-sql-driver/mysql"
	"github.com/volatiletech/sqlboiler/v4/boil"
)

func main() {

	// Logging
	utils.InitLogger()

	// Open MySQL DB
	db := utils.OpenDB()
	boil.SetDB(db)
	boil.DebugMode = true

	// Set Server
	// gin.SetMode(gin.ReleaseMode)
	router := gin.Default()
	config := cors.DefaultConfig()
	config.AllowOrigins = []string{"http://localhost:8080"}
	// config.AllowHeaders = []string{
	// 	"Access-Control-Allow-Headers",
	// 	"Content-Type",
	// 	"Content-Length",
	// 	"Accept-Encoding",
	// 	"X-CSRF-Token",
	// 	"Authorization",
	// }
	router.Use(cors.New(config))

	// Admin Routes
	adminGroup := router.Group("/admin")
	adminGroup.Use(controllers.AuthorizeJWT())
	{
		adminGroup.POST("/adminGetAllOrders", controllers.AdminGetAllOrders)
		adminGroup.POST("/getCountUserOrders", controllers.GetCountUserOrders)
	}

	// User Routes
	userGroup := router.Group("/user")
	userGroup.Use(controllers.AuthorizeJWT())
	{
		userGroup.GET("/getAllUsers", controllers.GetAllUsers)

		userGroup.POST("/userRegister", controllers.UserRegister)
		userGroup.POST("/userLogin", controllers.UserLogin)
		userGroup.POST("/userEdit", controllers.UserEdit)
		userGroup.POST("/checkUserDisplayName", controllers.CheckUserDisplayName)
		userGroup.POST("/setDefaultUserAddress", controllers.SetDefaultUserAddress)

		userGroup.POST("/getAllItemsFromCart", controllers.CartGetAllItems)
		userGroup.POST("/insertItemCart", controllers.CartItemInsert)
		userGroup.POST("/deleteItemCart", controllers.CartItemDelete)
		userGroup.POST("/changeCountItemCart", controllers.CartItemChangeCount)

		userGroup.POST("/getAllUserAddress", controllers.GetAllUserAddress)
		userGroup.POST("/userAddressInsert", controllers.UserAddressInsert)
		userGroup.POST("/userAddressEdit", controllers.UserAddressEdit)
		userGroup.POST("/userAddressDelete", controllers.UserAddressDelete)

		userGroup.POST("/getAllUserOrders", controllers.GetAllUserOrders)
		userGroup.POST("/addOrder", controllers.AddOrder)
		userGroup.POST("/getOrder", controllers.GetOrder)
		userGroup.POST("/getCartItemsOfUserOrder", controllers.GetCartItemsOfUserOrder)
	}

	// Item Routes
	itemGroup := router.Group("/item")
	itemGroup.Use(controllers.AuthorizeJWT())
	{
		itemGroup.POST("/getAllItems", controllers.GetAllItems)
		itemGroup.POST("/getCountItems", controllers.GetCountItems)
		itemGroup.POST("/searchItems", controllers.SearchItems)
		itemGroup.POST("/getItem", controllers.GetItem)
		itemGroup.POST("/itemInsert", controllers.ItemInsert)
		itemGroup.POST("/itemEdit", controllers.ItemEdit)
		itemGroup.POST("/itemDelete", controllers.ItemDelete)
		itemGroup.POST("/getImage", controllers.GetImage)
	}

	// Run Server
	router.Run(":8081")

}
