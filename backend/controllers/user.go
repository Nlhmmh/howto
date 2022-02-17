package controllers

import (
	"backend/models"
	"backend/utils"
	"context"
	"fmt"
	"net/http"
	"time"

	"github.com/volatiletech/null/v8"
	"golang.org/x/crypto/bcrypt"

	"github.com/gin-gonic/gin"
	"github.com/volatiletech/sqlboiler/v4/boil"
	"github.com/volatiletech/sqlboiler/v4/queries/qm"
)

const dateLayout = "2006-01-02"

// *********************************************** //

// GetAllUsers - Get All Users
func GetAllUsers(c *gin.Context) {

	fmt.Println("API -- GetAllUsers")

	ctx := context.Background()
	db := utils.GetDB()

	// Get All Users
	users, err := models.Users().All(ctx, db)
	if err != nil {
		fmt.Printf("Server Error - Get All Users %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, users)

}

// *********************************************** //

// UserRegister - User Register
func UserRegister(c *gin.Context) {

	fmt.Println("API -- UserRegister")

	ctx := context.Background()
	tx, err := utils.GetDB().BeginTx(ctx, nil)
	if err != nil {
		fmt.Println("Server Error : Transaction Begin Failed - ", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	// Get displayName
	displayName, ok := utils.CheckPostFormString(c.PostForm("displayName"), "displayName")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get firstName
	firstName, ok := utils.CheckPostFormString(c.PostForm("firstName"), "firstName")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get lastName
	lastName, ok := utils.CheckPostFormString(c.PostForm("lastName"), "lastName")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get birthDate
	birthDate, ok := utils.CheckPostFormString(c.PostForm("birthDate"), "birthDate")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}
	// Parse BirthDate
	birthDateDate, err := time.Parse(dateLayout, birthDate)
	if err != nil {
		fmt.Printf("Bad Request -Parse BirthDate %s\n", err.Error())
		tx.Rollback()
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get email
	email, ok := utils.CheckPostFormString(c.PostForm("email"), "email")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get password
	password, ok := utils.CheckPostFormString(c.PostForm("password"), "password")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}
	hashedPassword, _ := bcrypt.GenerateFromPassword([]byte(password), 10)

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

	// Get phone
	phone, ok := utils.CheckPostFormString(c.PostForm("phone"), "phone")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Insert User
	user := new(models.User)
	user.DisplayName = displayName
	user.FirstName = null.StringFrom(firstName)
	user.LastName = null.StringFrom(lastName)
	user.BirthDate = birthDateDate
	user.Email = null.StringFrom(email)
	user.Password = string(hashedPassword)
	user.Phone = null.StringFrom(phone)

	err = user.Insert(ctx, tx, boil.Infer())
	if err != nil {
		fmt.Printf("Server Error - Insert User %s\n", err.Error())
		tx.Rollback()
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	// Insert User Address
	userAddress := new(models.UserAddress)
	userAddress.UserID = user.ID
	userAddress.PostCode = postCode
	userAddress.Address1 = address1
	userAddress.Address2 = address2
	userAddress.Address3 = address3

	err = userAddress.Insert(ctx, tx, boil.Infer())
	if err != nil {
		fmt.Printf("Server Error - Insert User Address %s\n", err.Error())
		tx.Rollback()
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	// Update User Default Address
	user.DefaultAddress = null.IntFrom(int(userAddress.ID))

	_, err = user.Update(ctx, tx, boil.Infer())
	if err != nil {
		fmt.Printf("Server Error - Update User Default Address %s\n", err.Error())
		tx.Rollback()
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	tx.Commit()

	var userAddressList models.UserAddressSlice
	userAddressList = append(userAddressList, userAddress)

	// Generate Token
	token := GenerateToken(user.DisplayName, false)
	user.Password = "*****"
	c.JSON(http.StatusOK, &LoginResponse{
		User:          user,
		UserAddresses: userAddressList,
		Token:         token,
	})

}

// *********************************************** //

// UserLogin - User Login
func UserLogin(c *gin.Context) {

	fmt.Println("API -- UserLogin")

	ctx := context.Background()
	db := utils.GetDB()

	// Get displayName
	displayName, ok := utils.CheckPostFormString(c.PostForm("displayName"), "displayName")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get email
	// email, ok := utils.CheckPostFormString(c.PostForm("email"), "email")
	// if !ok {
	// 	c.AbortWithStatus(http.StatusBadRequest)
	// 	return
	// }

	// Get password
	password, ok := utils.CheckPostFormString(c.PostForm("password"), "password")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Find User
	user, err := models.Users(
		qm.Where("display_name=?", displayName),
	).One(ctx, db)
	if err != nil {
		fmt.Printf("Server Error - Find User %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	// Check Password
	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password))
	if err != nil {
		fmt.Printf("Bad Request - Password is wrong %s\n", err.Error())
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Find User Addresses
	userAddresses, err := models.UserAddresses(
		qm.Where("user_id=?", user.ID),
	).AllG(ctx)
	if err != nil {
		fmt.Printf("Server Error - Find User Addresses %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	// Generate Token
	token := GenerateToken(user.DisplayName, user.IsAdmin)
	user.Password = "*****"
	c.JSON(http.StatusOK, &LoginResponse{
		User:          user,
		UserAddresses: userAddresses,
		Token:         token,
	})

}

// *********************************************** //

// CheckUserDisplayName - Check User DisplayName
func CheckUserDisplayName(c *gin.Context) {

	fmt.Println("API -- CheckUserDisplayName")

	ctx := context.Background()
	db := utils.GetDB()

	// Get displayName
	displayName, ok := utils.CheckPostFormString(c.PostForm("displayName"), "displayName")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get email
	// email, ok := utils.CheckPostFormString(c.PostForm("email"), "email")
	// if !ok {
	// 	c.AbortWithStatus(http.StatusBadRequest)
	// 	return
	// }

	// Find User
	users, err := models.Users(
		qm.Where("display_name=?", displayName),
	).All(ctx, db)
	if err != nil {
		fmt.Printf("Server Error - Find User %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}
	if len(users) > 0 {
		c.JSON(http.StatusOK, true)
	} else {
		c.JSON(http.StatusOK, false)
	}

}

// *********************************************** //

// UserEdit - User Edit
func UserEdit(c *gin.Context) {

	fmt.Println("API -- UserEdit")

	ctx := context.Background()
	db := utils.GetDB()

	// Get displayName
	displayName, ok := utils.CheckPostFormString(c.PostForm("displayName"), "displayName")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get firstName
	firstName, ok := utils.CheckPostFormString(c.PostForm("firstName"), "firstName")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get lastName
	lastName, ok := utils.CheckPostFormString(c.PostForm("lastName"), "lastName")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get email
	email, ok := utils.CheckPostFormString(c.PostForm("email"), "email")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get doEditPassword
	doEditPassword, ok := utils.CheckPostFormBool(c.PostForm("doEditPassword"), "doEditPassword")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get password
	password, ok := utils.CheckPostFormString(c.PostForm("password"), "password")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}
	hashedPassword, _ := bcrypt.GenerateFromPassword([]byte(password), 10)

	// Get phone
	phone, ok := utils.CheckPostFormString(c.PostForm("phone"), "phone")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Find User
	user, err := models.Users(
		qm.Where("display_name=?", displayName),
	).One(ctx, db)
	if err != nil {
		fmt.Printf("Server Error - Find User %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	user.FirstName = null.StringFrom(firstName)
	user.LastName = null.StringFrom(lastName)
	user.Email = null.StringFrom(email)
	if doEditPassword {
		user.Password = string(hashedPassword)
	}
	user.Phone = null.StringFrom(phone)

	// Update User
	_, err = user.Update(ctx, db, boil.Infer())
	if err != nil {
		fmt.Printf("Server Error - Update User %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	user.Password = "*****"
	c.JSON(http.StatusOK, user)

}

// *********************************************** //

// SetDefaultUserAddress - Set Default User Address
func SetDefaultUserAddress(c *gin.Context) {

	fmt.Println("API -- SetDefaultUserAddress")

	ctx := context.Background()

	// Get id
	id, ok := utils.CheckPostFormInteger(c.PostForm("id"), "id")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Get user_id
	userID, ok := utils.CheckPostFormInteger(c.PostForm("userID"), "userID")
	if !ok {
		c.AbortWithStatus(http.StatusBadRequest)
		return
	}

	// Find User
	user, err := models.FindUserG(ctx, uint(userID))
	if err != nil {
		fmt.Printf("Server Error - Find User %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	// Update User
	user.DefaultAddress = null.IntFrom(id)

	// Update User
	_, err = user.UpdateG(ctx, boil.Infer())
	if err != nil {
		fmt.Printf("Server Error - Update User %s\n", err.Error())
		c.AbortWithStatus(http.StatusInternalServerError)
		return
	}

	c.JSON(http.StatusOK, user)

}
