package controllers

import (
	"backend/boiler"
	"backend/models"
	"backend/utils"
	"fmt"
	"net/http"
	"time"

	"golang.org/x/crypto/bcrypt"

	"github.com/gin-gonic/gin"
	"github.com/volatiletech/null"
	"github.com/volatiletech/sqlboiler/v4/boil"
)

const dateLayout = "2006-01-02"

// *********************************************** //

// FetchAllUsers - Fetch All Users
func FetchAllUsers(c *gin.Context) {

	fmt.Println("API -- FetchAllUsers")

	// Get All Users
	users, err := boiler.Users().AllG(c)
	if err != nil {
		utils.ErrorProcessAPI(
			"Get All Users",
			http.StatusInternalServerError,
			err,
			c,
		)
		return
	}

	c.JSON(http.StatusOK, users)

}

// *********************************************** //

// FetchUser - Fetch User
// func FetchUser(c *gin.Context) {

// 	fmt.Println("API -- FetchUser")

// 	// Get userID
// 	_, userID, ok := utils.CheckPostFormInteger(c.PostForm("userID"), "userID", c)
// 	if !ok {
// 		return
// 	}

// 	// Get User
// 	user, err := boiler.FindUserG(c, userID)
// 	if err != nil {
// 		utils.ErrorProcessAPI(
// 			"Get User",
// 			http.StatusInternalServerError,
// 			err,
// 			c,
// 		)
// 		return
// 	}

// 	c.JSON(http.StatusOK, user)

// }

// *********************************************** //

// RegisterUser - User Register
func RegisterUser(c *gin.Context) {

	fmt.Println("API -- UserRegister")

	// Check Request
	var resq models.User
	if err := c.ShouldBindJSON(&resq); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// Generate Hash Password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(resq.Password), 10)
	if err != nil {
		utils.ErrorProcessAPI(
			"Generate Hash Password",
			http.StatusBadRequest,
			err,
			c,
		)
		return
	}

	// Insert User
	user := new(boiler.User)
	user.DisplayName = resq.DisplayName
	user.Name = resq.Name
	user.BirthDate = resq.BirthDate
	user.Phone = resq.Phone
	user.Email = resq.Email
	user.Password = string(hashedPassword)
	user.Type = resq.Type
	user.Role = "user"
	user.Status = "active"
	user.CreatedAt = time.Now()
	user.UpdatedAt = null.TimeFrom(time.Now())

	if err = user.InsertG(c, boil.Infer()); err != nil {
		utils.ErrorProcessAPI(
			"Insert User",
			http.StatusInternalServerError,
			err,
			c,
		)
		return
	}

	// Generate Token
	token := GenerateToken(user.DisplayName, false)
	user.Password = "*****"
	c.JSON(http.StatusOK, &LoginResponse{
		User:  user,
		Token: token,
	})

}

// *********************************************** //

// LoginUser - User Login
// func LoginUser(c *gin.Context) {

// 	fmt.Println("API -- UserLogin")

// 	ctx := context.Background()

// 	// Get emailOrDispName
// 	emailOrDispName, ok := utils.CheckPostFormString(c.PostForm("emailOrDispName"), "emailOrDispName", c)
// 	if !ok {
// 		return
// 	}

// 	// Get password
// 	password, ok := utils.CheckPostFormString(c.PostForm("password"), "password", c)
// 	if !ok {
// 		return
// 	}

// 	// Find User
// 	user, err := boiler.Users(
// 		qm.Or("display_name=?", emailOrDispName),
// 		qm.Or("email=?", emailOrDispName),
// 	).OneG(ctx)
// 	if err != nil {
// 		utils.ErrorProcessAPI(
// 			"Find User",
// 			http.StatusInternalServerError,
// 			err,
// 			c,
// 		)
// 		return
// 	}

// 	// Check Password
// 	err = bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password))
// 	if err != nil {
// 		utils.ErrorProcessAPI(
// 			"Check Password",
// 			http.StatusInternalServerError,
// 			err,
// 			c,
// 		)
// 		return
// 	}

// 	// Generate Token
// 	token := GenerateToken(user.DisplayName, user.IsAdmin)
// 	user.Password = "*****"
// 	c.JSON(http.StatusOK, &LoginResponse{
// 		User:  user,
// 		Token: token,
// 	})

// }

// *********************************************** //

// CheckUserDisplayName - Check User DisplayName
// func CheckUserDisplayName(c *gin.Context) {

// 	fmt.Println("API -- CheckUserDisplayName")

// 	ctx := context.Background()

// 	// Get displayName
// 	displayName, ok := utils.CheckPostFormString(c.PostForm("displayName"), "displayName", c)
// 	if !ok {
// 		return
// 	}

// 	// Find UserCount
// 	userCount, err := boiler.Users(
// 		qm.Where("display_name=?", displayName),
// 	).CountG(ctx)
// 	if err != nil {
// 		utils.ErrorProcessAPI(
// 			"Find UserCount",
// 			http.StatusInternalServerError,
// 			err,
// 			c,
// 		)
// 		return
// 	}

// 	if userCount > 0 {
// 		c.JSON(http.StatusOK, true)
// 	} else {
// 		c.JSON(http.StatusOK, false)
// 	}

// }

// *********************************************** //

// CheckEmail - Check Email
// func CheckEmail(c *gin.Context) {

// 	fmt.Println("API -- CheckEmail")

// 	ctx := context.Background()

// 	// Get email
// 	email, ok := utils.CheckPostFormString(c.PostForm("email"), "email", c)
// 	if !ok {
// 		return
// 	}

// 	// Find UserCount
// 	userCount, err := boiler.Users(
// 		qm.Where("email=?", email),
// 	).CountG(ctx)
// 	if err != nil {
// 		utils.ErrorProcessAPI(
// 			"Find UserCount",
// 			http.StatusInternalServerError,
// 			err,
// 			c,
// 		)
// 		return
// 	}

// 	if userCount > 0 {
// 		c.JSON(http.StatusOK, true)
// 	} else {
// 		c.JSON(http.StatusOK, false)
// 	}

// }

// *********************************************** //

// EditUser - User Edit
// func EditUser(c *gin.Context) {

// 	fmt.Println("API -- UserEdit")

// 	ctx := context.Background()

// 	// Get id
// 	_, userID, ok := utils.CheckPostFormInteger(c.PostForm("userID"), "userID", c)
// 	if !ok {
// 		return
// 	}

// 	// Get displayName
// 	displayName, ok := utils.CheckPostFormString(c.PostForm("displayName"), "displayName", c)
// 	if !ok {
// 		return
// 	}

// 	// Get name
// 	name, ok := utils.CheckPostFormString(c.PostForm("name"), "name", c)
// 	if !ok {
// 		return
// 	}

// 	// Get birthDate
// 	birthDate, ok := utils.CheckPostFormString(c.PostForm("birthDate"), "birthDate", c)
// 	if !ok {
// 		return
// 	}
// 	// Parse BirthDate
// 	birthDateDate, err := time.Parse(dateLayout, birthDate)
// 	if err != nil {
// 		utils.ErrorProcessAPI(
// 			"Parse BirthDate",
// 			http.StatusBadRequest,
// 			err,
// 			c,
// 		)
// 		return
// 	}

// 	// // Get phone
// 	// phone, ok := utils.CheckPostFormString(c.PostForm("phone"), "phone", c)
// 	// if !ok {
// 	// 	return
// 	// }

// 	// Find User
// 	user, err := boiler.FindUserG(ctx, userID)
// 	if err != nil {
// 		utils.ErrorProcessAPI(
// 			"Find User",
// 			http.StatusInternalServerError,
// 			err,
// 			c,
// 		)
// 		return
// 	}

// 	// Update User
// 	user.DisplayName = displayName
// 	user.Name = name
// 	user.BirthDate = null.TimeFrom(birthDateDate)
// 	// user.Phone = null.StringFrom(phone)

// 	_, err = user.UpdateG(ctx, boil.Infer())
// 	if err != nil {
// 		utils.ErrorProcessAPI(
// 			"Update User",
// 			http.StatusInternalServerError,
// 			err,
// 			c,
// 		)
// 		return
// 	}

// 	c.JSON(http.StatusOK, user)

// }

// *********************************************** //

// EditPassword - Edit Password
// func EditPassword(c *gin.Context) {

// 	fmt.Println("API -- EditPassword")

// 	ctx := context.Background()

// 	// Get userID
// 	_, userID, ok := utils.CheckPostFormInteger(c.PostForm("userID"), "userID", c)
// 	if !ok {
// 		return
// 	}

// 	// Get oldPassword
// 	oldPassword := c.PostForm("oldPassword")
// 	// Get newPassword
// 	newPassword := c.PostForm("newPassword")

// 	// Find User
// 	user, err := boiler.FindUserG(ctx, userID)
// 	if err != nil {
// 		utils.ErrorProcessAPI(
// 			"Find User",
// 			http.StatusInternalServerError,
// 			err,
// 			c,
// 		)
// 		return
// 	}

// 	// Update User
// 	if oldPassword != "" && newPassword != "" {
// 		// Check Old Password
// 		err := bcrypt.CompareHashAndPassword(
// 			[]byte(user.Password),
// 			[]byte(oldPassword),
// 		)
// 		if err != nil {
// 			utils.ErrorProcessAPIWithoutC(
// 				"Old Password is wrong",
// 				http.StatusBadRequest,
// 				err,
// 			)
// 			c.String(http.StatusBadRequest, "oldPasswordWrong")
// 			return
// 		}
// 		// Generate Hash New Password
// 		hashedNewPassword, err := bcrypt.GenerateFromPassword([]byte(newPassword), 10)
// 		if err != nil {
// 			utils.ErrorProcessAPIWithoutC(
// 				"Generate Hash New Password",
// 				http.StatusBadRequest,
// 				err,
// 			)
// 			c.String(http.StatusBadRequest, "newPasswordError")
// 			return
// 		}
// 		user.Password = string(hashedNewPassword)
// 	}

// 	_, err = user.UpdateG(ctx, boil.Infer())
// 	if err != nil {
// 		utils.ErrorProcessAPI(
// 			"Update User",
// 			http.StatusInternalServerError,
// 			err,
// 			c,
// 		)
// 		return
// 	}

// 	c.Status(http.StatusOK)

// }
