package controllers

import (
	"backend/boiler"
	"database/sql"
	"errors"
	"fmt"
	"math/rand"
	"net/http"
	"strings"
	"time"

	"golang.org/x/crypto/bcrypt"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/volatiletech/sqlboiler/v4/boil"
	"github.com/volatiletech/sqlboiler/v4/queries/qm"
)

type userCtrl struct{}

var (
	userCtrls *userCtrl
)

// *********************************************** //

func (o *userCtrl) SendOTP(c *gin.Context) {

	// Check Request
	var resq UserRegisterSendOtpRequest
	if err := c.ShouldBindJSON(&resq); err != nil {
		BadRequestResp(c, err)
		return
	}

	// Generate OTP
	var otp []string
	rand.Seed(time.Now().UnixNano())
	for i := 0; i < 4; i++ {
		otp = append(otp, fmt.Sprintf("%d", rand.Intn(9)))
	}

	// Create OTP
	userOtp := new(boiler.UserOtp)
	userOtp.Email = resq.Email
	userOtp.Otp = strings.Join(otp, "")

	if err := userOtp.InsertG(c, boil.Infer()); err != nil {
		ServerErrorResp(c, err)
		return
	}

	c.Status(http.StatusOK)

}

// *********************************************** //

func (o *userCtrl) CheckOTP(c *gin.Context) {

	// Check Request
	var resq UserRegisterCheckOtpRequest
	if err := c.ShouldBindJSON(&resq); err != nil {
		BadRequestResp(c, err)
		return
	}

	// Check OTP
	// Find UserOtpCount
	userOtpCount, err := boiler.UserOtps(
		qm.Where("email=?", resq.Email),
		qm.Where("otp=?", resq.Otp),
	).CountG(c)
	if err != nil {
		ServerErrorResp(c, err)
		return
	}

	if userOtpCount > 0 {
		c.JSON(http.StatusOK, true)
	} else {
		c.JSON(http.StatusOK, false)
	}

}

// *********************************************** //

func (o *userCtrl) Register(c *gin.Context) {

	// Check Request
	var resq UserRegisterRequest
	if err := c.ShouldBindJSON(&resq); err != nil {
		BadRequestResp(c, err)
		return
	}
	if resq.Type != boiler.UsersTypeCreator.String() && resq.Type != boiler.UsersTypeViewer.String() {
		BadRequestResp(c, errors.New("type is not creator or viewer"))
		return
	}

	// Generate Hash Password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(resq.Password), 10)
	if err != nil {
		BadRequestResp(c, err)
		return
	}

	WriteTransaction(c, func(tx *sql.Tx) bool {

		// Create User
		user := new(boiler.User)
		user.ID = uuid.NewString()
		user.Email = resq.Email
		user.Password = string(hashedPassword)
		user.Type = boiler.UsersType(resq.Type)
		user.Role = "user"
		user.Status = "active"

		if err := user.Insert(c, tx, boil.Infer()); err != nil {
			RespWithRollbackTx(c, err, tx, ServerErrorResp)
			return true
		}

		// Create User Profile
		userProfile := new(boiler.UserProfile)
		userProfile.UserID = user.ID
		userProfile.DisplayName = resq.DisplayName
		userProfile.Name = resq.Name
		userProfile.BirthDate = resq.BirthDate
		userProfile.Phone = resq.Phone

		if err := userProfile.Insert(c, tx, boil.Infer()); err != nil {
			RespWithRollbackTx(c, err, tx, ServerErrorResp)
			return true
		}

		c.Status(http.StatusOK)
		return false

	})

}

// *********************************************** //

func (o *userCtrl) Login(c *gin.Context) {

	// Check Request
	var resq LoginRequest
	if err := c.ShouldBindJSON(&resq); err != nil {
		BadRequestResp(c, err)
		return
	}

	// Find User
	user, err := boiler.Users(
		qm.Where("email=?", resq.Email),
	).OneG(c)
	if err != nil && errors.Is(err, sql.ErrNoRows) {
		UserWithEmailNotExistResp(c, err)
		return
	}
	if err != nil {
		ServerErrorResp(c, err)
		return
	}

	// Check Password
	if err := bcrypt.CompareHashAndPassword(
		[]byte(user.Password),
		[]byte(resq.Password),
	); err != nil {
		PasswordWrongResp(c, err)
		return
	}

	// Generate Token
	token, err := GenerateToken(user.ID, user.Role.String())
	if err != nil {
		ServerErrorResp(c, err)
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

	// Check Request
	var resq CheckDisplayNameRequest
	if err := c.ShouldBindJSON(&resq); err != nil {
		BadRequestResp(c, err)
		return
	}

	// Find UserCount
	userProfileExists, err := boiler.UserProfiles(
		qm.Where("display_name=?", resq.DisplayName),
	).ExistsG(c)
	if err != nil {
		ServerErrorResp(c, err)
		return
	}

	c.JSON(http.StatusOK, userProfileExists)

}

// *********************************************** //

func (o *userCtrl) CheckEmail(c *gin.Context) {

	// Check Request
	var resq CheckEmailRequest
	if err := c.ShouldBindJSON(&resq); err != nil {
		BadRequestResp(c, err)
		return
	}

	// Find UserCount
	userExists, err := boiler.Users(
		qm.Where("email=?", resq.Email),
	).ExistsG(c)
	if err != nil {
		ServerErrorResp(c, err)
		return
	}

	c.JSON(http.StatusOK, userExists)

}

// *********************************************** //

func (o *userCtrl) EditProfile(c *gin.Context) {

	// Check Request
	var resq UserProfileEditRequest
	if err := c.ShouldBindJSON(&resq); err != nil {
		BadRequestResp(c, err)
		return
	}

	WriteTransaction(c, func(tx *sql.Tx) bool {

		userID := c.GetString("userID")

		// Find UserProfile
		userProfile, err := boiler.FindUserProfile(c, tx, userID)
		if err != nil {
			RespWithRollbackTx(c, err, tx, ServerErrorResp)
			return true
		}

		// Update User
		if !resq.DisplayName.IsZero() {

			// Check DisplayName
			if userProfileExists, err := boiler.UserProfiles(
				qm.Where("user_id != ?", userID),
				qm.Where("display_name = ?", resq.DisplayName),
			).Exists(c, tx); err != nil {
				RespWithRollbackTx(c, err, tx, ServerErrorResp)
				return true
			} else if userProfileExists {
				RespWithRollbackTx(c, errors.New("display name already exists"), tx, DisplayNameAlreadyExistResp)
				return true
			}
			userProfile.DisplayName = resq.DisplayName.String

		}

		if !resq.Name.IsZero() {
			userProfile.Name = resq.Name.String
		}

		if resq.BirthDate.Valid {
			userProfile.BirthDate = resq.BirthDate
		}

		if !resq.Phone.IsZero() {
			userProfile.Phone = resq.Phone
		}

		if _, err = userProfile.Update(c, tx, boil.Infer()); err != nil {
			RespWithRollbackTx(c, err, tx, ServerErrorResp)
			return true
		}

		c.JSON(http.StatusOK, userProfile)
		return false

	})

}

// *********************************************** //

func (o *userCtrl) EditPassword(c *gin.Context) {

	// Check Request
	var resq UserEditPwRequest
	if err := c.ShouldBindJSON(&resq); err != nil {
		BadRequestResp(c, err)
		return
	}

	// Find User
	user, err := boiler.FindUserG(c, c.GetString("userID"))
	if err != nil {
		ServerErrorResp(c, err)
		return
	}

	// Check Old Password
	if err := bcrypt.CompareHashAndPassword(
		[]byte(user.Password),
		[]byte(resq.OldPassword),
	); err != nil {
		PasswordWrongResp(c, err)
		return
	}

	// Generate Hash New Password
	hashedNewPassword, err := bcrypt.GenerateFromPassword(
		[]byte(resq.NewPassword), 10,
	)
	if err != nil {
		BadRequestResp(c, err)
		return
	}
	user.Password = string(hashedNewPassword)

	if _, err := user.UpdateG(c, boil.Infer()); err != nil {
		ServerErrorResp(c, err)
		return
	}

	c.Status(http.StatusOK)

}
