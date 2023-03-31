package ctrls

import (
	"backend/boiler"
	"backend/ers"
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

func (o *userCtrl) sentOTP(c *gin.Context) {

	// Check Request
	var resq UserRegisterSendOtpReq
	if err := c.ShouldBindJSON(&resq); err != nil {
		ers.BadRequestResp(c, err)
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
		ers.ServerErrorResp(c, err)
		return
	}

	c.Status(http.StatusOK)

}

func (o *userCtrl) checkOTP(c *gin.Context) {

	// Check Request
	var resq UserRegisterCheckOtpReq
	if err := c.ShouldBindJSON(&resq); err != nil {
		ers.BadRequestResp(c, err)
		return
	}

	// Check OTP
	// Find UserOtpCount
	userOtpCount, err := boiler.UserOtps(
		qm.Where("email=?", resq.Email),
		qm.Where("otp=?", resq.Otp),
	).CountG(c)
	if err != nil {
		ers.ServerErrorResp(c, err)
		return
	}

	if userOtpCount > 0 {
		c.JSON(http.StatusOK, true)
	} else {
		c.JSON(http.StatusOK, false)
	}

}

func (o *userCtrl) register(c *gin.Context) {

	// Check Request
	var resq UserRegisterRequest
	if err := c.ShouldBindJSON(&resq); err != nil {
		ers.BadRequestResp(c, err)
		return
	}
	if resq.Type != boiler.UsersTypeCreator.String() && resq.Type != boiler.UsersTypeViewer.String() {
		ers.BadRequestResp(c, errors.New("type is not creator or viewer"))
		return
	}

	// Generate Hash Password
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(resq.Password), 10)
	if err != nil {
		ers.BadRequestResp(c, err)
		return
	}

	if err := WriteTx(c, func(tx *sql.Tx) (ers.ErrRespFunc, error) {

		// Find User With Email
		if emailExists, err := boiler.Users(
			qm.Where("email=?", resq.Email),
		).Exists(c, tx); err != nil {
			return ers.ServerErrorResp, err
		} else if emailExists {
			return ers.UserWithEmailAlreadyExistResp, errors.New("user with email already exists")
		}

		// Find User With DisplayName
		if userProfileExists, err := boiler.UserProfiles(
			qm.Where("display_name=?", resq.DisplayName),
		).Exists(c, tx); err != nil {
			return ers.ServerErrorResp, err
		} else if userProfileExists {
			return ers.DisplayNameAlreadyExistResp, errors.New("display name already exists")
		}

		// Create User
		user := new(boiler.User)
		user.ID = uuid.NewString()
		user.Email = resq.Email
		user.Password = string(hashedPassword)
		user.Type = boiler.UsersType(resq.Type)
		user.Role = "user"
		user.Status = "active"

		if err := user.Insert(c, tx, boil.Infer()); err != nil {
			return ers.ServerErrorResp, err
		}

		// Create User Profile
		userProfile := new(boiler.UserProfile)
		userProfile.UserID = user.ID
		userProfile.DisplayName = resq.DisplayName
		userProfile.Name = resq.Name
		userProfile.BirthDate = resq.BirthDate
		userProfile.Phone = resq.Phone
		userProfile.ImageURL = resq.ImageUrl

		if err := userProfile.Insert(c, tx, boil.Infer()); err != nil {
			return ers.ServerErrorResp, err
		}

		return nil, nil

	}); err != nil {
		return
	}

	c.Status(http.StatusOK)

}

func (o *userCtrl) login(c *gin.Context) {

	// Check Request
	var resq UserLoginReq
	if err := c.ShouldBindJSON(&resq); err != nil {
		ers.BadRequestResp(c, err)
		return
	}

	// Find User
	user, err := boiler.Users(
		qm.Where("email=?", resq.Email),
	).OneG(c)
	if err != nil && errors.Is(err, sql.ErrNoRows) {
		ers.UserWithEmailNotExistResp(c, err)
		return
	}
	if err != nil {
		ers.ServerErrorResp(c, err)
		return
	}

	// Check Password
	if err := bcrypt.CompareHashAndPassword(
		[]byte(user.Password),
		[]byte(resq.Password),
	); err != nil {
		ers.PasswordWrongResp(c, err)
		return
	}

	// Generate Token
	token, err := GenerateToken(user.ID, user.Role.String())
	if err != nil {
		ers.ServerErrorResp(c, err)
		return
	}
	user.Password = "*****"
	c.JSON(http.StatusOK, &LoginResp{
		User:  user,
		Token: token,
	})

}

// *********************************************** //

func (o *userCtrl) checkDisplayName(c *gin.Context) {

	// Check Request
	var resq CheckDisplayNameReq
	if err := c.ShouldBindJSON(&resq); err != nil {
		ers.BadRequestResp(c, err)
		return
	}

	// Find UserCount
	userProfileExists, err := boiler.UserProfiles(
		qm.Where("display_name=?", resq.DisplayName),
	).ExistsG(c)
	if err != nil {
		ers.ServerErrorResp(c, err)
		return
	}

	c.JSON(http.StatusOK, userProfileExists)

}

// *********************************************** //

func (o *userCtrl) checkEmail(c *gin.Context) {

	// Check Request
	var resq CheckEmailReq
	if err := c.ShouldBindJSON(&resq); err != nil {
		ers.BadRequestResp(c, err)
		return
	}

	// Find UserCount
	userExists, err := boiler.Users(
		qm.Where("email=?", resq.Email),
	).ExistsG(c)
	if err != nil {
		ers.ServerErrorResp(c, err)
		return
	}

	c.JSON(http.StatusOK, userExists)

}

// *********************************************** //

func (o *userCtrl) profileGet(c *gin.Context) {

	userID := c.GetString("userID")

	var resp *boiler.UserProfile
	if err := ReadTx(c, func(tx *sql.Tx) (ers.ErrRespFunc, error) {

		// Find UserProfile
		userProfile, err := boiler.FindUserProfile(c, tx, userID)
		if err != nil {
			return ers.ServerErrorResp, err
		}
		resp = userProfile

		return nil, nil

	}); err != nil {
		return
	}

	c.JSON(http.StatusOK, resp)

}

func (o *userCtrl) profileEdit(c *gin.Context) {

	// Check Request
	var req UserProfileEditReq
	if err := c.ShouldBindJSON(&req); err != nil {
		ers.BadRequestResp(c, err)
		return
	}

	if err := WriteTx(c, func(tx *sql.Tx) (ers.ErrRespFunc, error) {

		userID := c.GetString("userID")

		// Find UserProfile
		userProfile, err := boiler.FindUserProfile(c, tx, userID)
		if err != nil {
			return ers.ServerErrorResp, err
		}

		// Update User
		if !req.DisplayName.IsZero() {

			// Check DisplayName
			if userProfileExists, err := boiler.UserProfiles(
				qm.Where("user_id != ?", userID),
				qm.Where("display_name = ?", req.DisplayName),
			).Exists(c, tx); err != nil {
				return ers.ServerErrorResp, err
			} else if userProfileExists {
				return ers.DisplayNameAlreadyExistResp, errors.New("display name already exists")
			}
			userProfile.DisplayName = req.DisplayName.String

		}

		if !req.Name.IsZero() {
			userProfile.Name = req.Name.String
		}

		if req.BirthDate.Valid {
			userProfile.BirthDate = req.BirthDate
		}

		if !req.Phone.IsZero() {
			userProfile.Phone = req.Phone
		}

		if !req.ImageUrl.IsZero() {
			userProfile.ImageURL = req.ImageUrl
		}

		if _, err = userProfile.Update(c, tx, boil.Infer()); err != nil {
			return ers.ServerErrorResp, err
		}

		return nil, nil

	}); err != nil {
		return
	}

	c.JSON(http.StatusOK, RespMap{})

}

// *********************************************** //

func (o *userCtrl) passwordEdit(c *gin.Context) {

	// Check Request
	var resq UserEditPwReq
	if err := c.ShouldBindJSON(&resq); err != nil {
		ers.BadRequestResp(c, err)
		return
	}

	// Find User
	user, err := boiler.FindUserG(c, c.GetString("userID"))
	if err != nil {
		ers.ServerErrorResp(c, err)
		return
	}

	// Check Old Password
	if err := bcrypt.CompareHashAndPassword(
		[]byte(user.Password),
		[]byte(resq.OldPassword),
	); err != nil {
		ers.PasswordWrongResp(c, err)
		return
	}

	// Generate Hash New Password
	hashedNewPassword, err := bcrypt.GenerateFromPassword(
		[]byte(resq.NewPassword), 10,
	)
	if err != nil {
		ers.BadRequestResp(c, err)
		return
	}
	user.Password = string(hashedNewPassword)

	if _, err := user.UpdateG(c, boil.Infer()); err != nil {
		ers.ServerErrorResp(c, err)
		return
	}

	c.Status(http.StatusOK)

}

// *********************************************** //

func (o *userCtrl) favCreate(c *gin.Context) {

	// Check Request
	var resq UserSetFavReq
	if err := c.ShouldBindJSON(&resq); err != nil {
		ers.BadRequestResp(c, err)
		return
	}

	userID := c.GetString("userID")

	if err := WriteTx(c, func(tx *sql.Tx) (ers.ErrRespFunc, error) {

		// Get Favourite
		userFav, err := boiler.FindUserFavourite(c, tx, userID, resq.ContentID)
		if err != nil && !errors.Is(err, sql.ErrNoRows) {
			return ers.ServerErrorResp, err
		}
		if errors.Is(err, sql.ErrNoRows) {

			// Create UserFavourite
			userFav = new(boiler.UserFavourite)
			userFav.UserID = userID
			userFav.ContentID = resq.ContentID
			userFav.IsFavourite = true

			if err := userFav.Insert(c, tx, boil.Infer()); err != nil {
				return ers.ServerErrorResp, err
			}

		} else {

			// Update UserFavourite
			userFav.IsFavourite = !userFav.IsFavourite

			if _, err := userFav.Update(c, tx, boil.Infer()); err != nil {
				return ers.ServerErrorResp, err
			}

		}

		return nil, nil

	}); err != nil {
		return
	}

	c.JSON(http.StatusOK, RespMap{})

}

func (o *userCtrl) favList(c *gin.Context) {

	// Check Request
	var req UserFavGetAllReq
	if err := c.BindQuery(&req); err != nil {
		ers.BadRequestResp(c, err)
		return
	}

	userID := c.GetString("userID")

	var resp []ContentWhole
	ReadTx(c, func(tx *sql.Tx) (ers.ErrRespFunc, error) {

		// Get All Contents
		var contentList []ContentWhole

		qms := []qm.QueryMod{}
		qms = append(qms, qm.Select(
			`
			contents.*, 
			user_profiles.display_name as user_name,
			content_categories.name as category_str
		`,
		))
		qms = append(qms, qm.From("user_favourites"))
		qms = append(qms, qm.InnerJoin("contents ON contents.id = user_favourites.content_id"))
		qms = append(qms, qm.InnerJoin("user_profiles ON user_profiles.user_id = contents.user_id"))
		qms = append(qms, qm.InnerJoin("content_categories ON content_categories.id = contents.category_id"))
		qms = append(qms, qm.Where("user_favourites.user_id = ?", userID))
		qms = append(qms, qm.Where("user_favourites.is_favourite = true"))
		qms = append(qms, qm.OrderBy("user_favourites.updated_at DESC"))

		// Limit
		if req.Limit > 0 {
			qms = append(qms, qm.Limit(req.Limit))
		} else {
			qms = append(qms, qm.Limit(20))
		}
		// Offset
		if req.Offset > 0 {
			qms = append(qms, qm.Offset(req.Offset))
		} else {
			qms = append(qms, qm.Offset(0))
		}

		if err := boiler.NewQuery(qms...).Bind(c, tx, &contentList); err != nil {
			return ers.ServerErrorResp, err
		}

		for _, content := range contentList {

			// List ContentHtmls
			contentHtmlList, err := boiler.ContentHTMLS(
				qm.Where("content_id = ?", content.ID),
			).All(c, tx)
			if err != nil {
				return ers.ServerErrorResp, err
			}
			content.ContentHtmlList = contentHtmlList

		}

		resp = contentList
		return nil, nil

	})

	c.JSON(http.StatusOK, RespList{List: resp})

}

// *********************************************** //
