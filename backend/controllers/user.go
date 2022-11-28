package controllers

import (
	"backend/boiler"
	"backend/models"
	"backend/utils"
	"net/http"
	"time"

	"golang.org/x/crypto/bcrypt"

	"github.com/gin-gonic/gin"
	"github.com/volatiletech/null"
	"github.com/volatiletech/sqlboiler/v4/boil"
	"github.com/volatiletech/sqlboiler/v4/queries/qm"
)

type userCtrl struct{}

type contentCtrl struct{}

var (
	UserCtrl    *userCtrl
	ContentCtrl *contentCtrl
)

// *********************************************** //

func (o *userCtrl) GetAll(c *gin.Context) {

	// Get All Users
	users, err := boiler.Users().AllG(c)
	if err != nil {
		c.JSON(http.StatusInternalServerError, err)
		return
	}

	c.JSON(http.StatusOK, users)

}

// *********************************************** //

func (o *userCtrl) Get(c *gin.Context) {

	// Get userID
	_, userID, err := utils.ConvertInt(c.Param("userID"))
	if err != nil {
		c.AbortWithError(http.StatusBadRequest, err)
		return
	}

	// Get User
	user, err := boiler.FindUserG(c, userID)
	if err != nil {
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}

	c.JSON(http.StatusOK, user)

}

// *********************************************** //

func (o *userCtrl) Register(c *gin.Context) {

	// Check Request
	var resq models.User
	if err := c.ShouldBindJSON(&resq); err != nil {
		c.AbortWithError(http.StatusBadRequest, err)
		return
	}

	// Generate Hash Password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(resq.Password), 10)
	if err != nil {
		c.AbortWithError(http.StatusBadRequest, err)
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
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}

	// Generate Token
	token, err := GenerateToken(user.DisplayName, user.Role)
	if err != nil {
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}
	user.Password = "*****"
	c.JSON(http.StatusOK, &LoginResponse{
		User:  user,
		Token: token,
	})

}

// *********************************************** //

func (o *userCtrl) Login(c *gin.Context) {

	// Check Request
	var resq models.LoginRequest
	if err := c.ShouldBindJSON(&resq); err != nil {
		c.AbortWithError(http.StatusBadRequest, err)
		return
	}

	// Find User
	user, err := boiler.Users(
		qm.Or("display_name=?", resq.EmailOrDispName),
		qm.Or("email=?", resq.EmailOrDispName),
	).OneG(c)
	if err != nil {
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}

	// Check Password
	if err = bcrypt.CompareHashAndPassword(
		[]byte(user.Password),
		[]byte(resq.Password),
	); err != nil {
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}

	// Generate Token
	token, err := GenerateToken(user.DisplayName, user.Role)
	if err != nil {
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}
	user.Password = "*****"
	c.JSON(http.StatusOK, &LoginResponse{
		User:  user,
		Token: token,
	})

}

// *********************************************** //

func (o *userCtrl) CheckDisplayName(c *gin.Context) {

	// Get displayName
	displayName, err := utils.CheckBlankString(c.PostForm("displayName"))
	if err != nil {
		c.AbortWithError(http.StatusBadRequest, err)
		return
	}

	// Find UserCount
	userCount, err := boiler.Users(
		qm.Where("display_name=?", displayName),
	).CountG(c)
	if err != nil {
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}

	if userCount > 0 {
		c.JSON(http.StatusOK, true)
	} else {
		c.JSON(http.StatusOK, false)
	}

}

// *********************************************** //

func (o *userCtrl) CheckEmail(c *gin.Context) {

	// Get email
	email, err := utils.CheckBlankString(c.PostForm("email"))
	if err != nil {
		c.AbortWithError(http.StatusBadRequest, err)
		return
	}

	// Find UserCount
	userCount, err := boiler.Users(
		qm.Where("email=?", email),
	).CountG(c)
	if err != nil {
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}

	if userCount > 0 {
		c.JSON(http.StatusOK, true)
	} else {
		c.JSON(http.StatusOK, false)
	}

}

// *********************************************** //

func (o *userCtrl) Edit(c *gin.Context) {

	// Check Request
	var resq models.UserEditRequest
	if err := c.ShouldBindJSON(&resq); err != nil {
		c.AbortWithError(http.StatusBadRequest, err)
		return
	}

	// Find User
	user, err := boiler.FindUserG(c, resq.ID)
	if err != nil {
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}

	// Update User
	if !resq.DisplayName.IsZero() {
		user.DisplayName = resq.DisplayName.String
	}
	if !resq.Name.IsZero() {
		user.Name = resq.Name.String
	}
	if !resq.BirthDate.Valid {
		user.BirthDate = resq.BirthDate
	}
	if !resq.Phone.IsZero() {
		user.Phone = resq.Phone
	}

	if _, err = user.UpdateG(c, boil.Infer()); err != nil {
		c.AbortWithError(http.StatusInternalServerError, err)
		return
	}

	c.JSON(http.StatusOK, user)

}

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
