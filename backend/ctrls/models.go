package ctrls

import (
	"backend/boiler"
	"time"

	"github.com/volatiletech/null/v8"
)

// *********************************************** //

type UserRegisterSendOtpReq struct {
	Email string `json:"email" binding:"required"`
}

type UserRegisterCheckOtpReq struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
	Otp      string `json:"otp" binding:"required"`
}

type UserRegisterRequest struct {
	Email       string      `json:"email" binding:"required"`
	Password    string      `json:"password" binding:"required"`
	DisplayName string      `json:"displayName" binding:"required"`
	Name        string      `json:"name" binding:"required"`
	BirthDate   null.Time   `json:"birthDate,omitempty"`
	Phone       null.String `json:"phone,omitempty"`
	ImageUrl    null.String `json:"imagUrl,omitempty"`
	Type        string      `json:"type" binding:"required"`
}

type UserLoginReq struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type UserProfileEditReq struct {
	DisplayName null.String `json:"displayName,omitempty"`
	Name        null.String `json:"name,omitempty"`
	BirthDate   null.Time   `json:"birthDate,omitempty"`
	Phone       null.String `json:"phone,omitempty"`
	ImageUrl    null.String `json:"imagUrl,omitempty"`
}

type UserEditPwReq struct {
	OldPassword string `json:"oldPassword" binding:"required"`
	NewPassword string `json:"newPassword" binding:"required"`
}

type CheckEmailReq struct {
	Email string `json:"email" binding:"required"`
}

type CheckDisplayNameReq struct {
	DisplayName string `json:"displayName" binding:"required"`
}

type UserSetFavReq struct {
	ContentID   string `json:"contentID" binding:"required"`
	IsFavourite bool   `json:"isFavourite" binding:"required"`
}

type UserFavGetAllReq struct {
	Limit  int `form:"limit"`
	Offset int `form:"offset"`
}

// *********************************************** //

type ContentWhole struct {
	ID         string      `boil:"id" json:"id" toml:"id" yaml:"id"`
	UserID     string      `boil:"user_id" json:"userID" toml:"userID" yaml:"userID"`
	CategoryID uint        `boil:"category_id" json:"categoryID" toml:"categoryID" yaml:"categoryID"`
	Title      string      `boil:"title" json:"title" toml:"title" yaml:"title"`
	ImageUrl   null.String `boil:"image_url" json:"imageUrl" toml:"imageUrl" yaml:"imageUrl"`
	ViewCount  int         `boil:"view_count" json:"viewCount" toml:"viewCount" yaml:"viewCount"`
	CreatedAt  time.Time   `boil:"created_at" json:"createdAt" toml:"createdAt" yaml:"createdAt"`
	UpdatedAt  null.Time   `boil:"updated_at" json:"updatedAt,omitempty" toml:"updatedAt" yaml:"updatedAt,omitempty"`

	UserName string `boil:"user_name" json:"userName" toml:"userName" yaml:"userName"`

	CategoryStr string `boil:"category_str" json:"categoryStr" toml:"categoryStr" yaml:"categoryStr"`

	ContentHtmlList boiler.ContentHTMLSlice `json:"contentHtmlList"`
}

type ContentGetAllReq struct {
	Limit        int    `form:"limit"`
	Offset       int    `form:"offset"`
	SortBy       string `form:"sortBy"`
	SearchTitle  string `form:"searchTitle"`
	SearchCatID  uint   `form:"searchCatID"`
	SearchUserID string `form:"searchUserID"`
}

type CreateContentReq struct {
	Title           string `json:"title" binding:"required"`
	CategoryID      uint   `json:"categoryID" binding:"required"`
	ImageUrl        string `json:"imageUrl"`
	ContentHtmlList []struct {
		OrderNo int16  `json:"orderNo" binding:"required"`
		Html    string `json:"html" binding:"required"`
	} `json:"contentHtmlList"`
}

// *********************************************** //

type RespList struct {
	List any `json:"list"`
}

type RespMap map[string]any
