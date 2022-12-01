package controllers

import (
	"time"

	"github.com/volatiletech/null/v8"
)

type UserRegisterSendOtpRequest struct {
	Email string `json:"email" binding:"required"`
}

type UserRegisterCheckOtpRequest struct {
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
	Type        string      `json:"type" binding:"required"`
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required"`
	Password string `json:"password" binding:"required"`
}

type UserProfileEditRequest struct {
	DisplayName null.String `json:"displayName,omitempty"`
	Name        null.String `json:"name,omitempty"`
	BirthDate   null.Time   `json:"birthDate,omitempty"`
	Phone       null.String `json:"phone,omitempty"`
}

type UserEditPwRequest struct {
	OldPassword string `json:"oldPassword" binding:"required"`
	NewPassword string `json:"newPassword" binding:"required"`
}

type CheckEmailRequest struct {
	Email string `json:"email" binding:"required"`
}

type CheckDisplayNameRequest struct {
	DisplayName string `json:"displayName" binding:"required"`
}

type ContentWithUserName struct {
	ID         string    `boil:"id" json:"id" toml:"id" yaml:"id"`
	UserID     string    `boil:"user_id" json:"userID" toml:"userID" yaml:"userID"`
	CategoryID uint      `boil:"category_id" json:"categoryID" toml:"categoryID" yaml:"categoryID"`
	Title      string    `boil:"title" json:"title" toml:"title" yaml:"title"`
	ViewCount  int       `boil:"view_count" json:"viewCount" toml:"viewCount" yaml:"viewCount"`
	CreatedAt  time.Time `boil:"created_at" json:"createdAt" toml:"createdAt" yaml:"createdAt"`
	UpdatedAt  null.Time `boil:"updated_at" json:"updatedAt,omitempty" toml:"updatedAt" yaml:"updatedAt,omitempty"`

	UserName string `boil:"user_name" json:"userName" toml:"userName" yaml:"userName"`

	CategoryStr string `boil:"category_str" json:"categoryStr" toml:"categoryStr" yaml:"categoryStr"`
}

type CreateContentRequest struct {
	Title      string `json:"title" binding:"required"`
	CategoryID uint   `json:"categoryID" binding:"required"`
}

type ContentGetAllRequest struct {
	Limit  int    `form:"limit"`
	Offset int    `form:"offset"`
	SortBy string `form:"sortBy"`
}
