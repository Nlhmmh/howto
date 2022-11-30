package controllers

import "github.com/volatiletech/null"

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
	ID          uint        `boil:"id" json:"id" binding:"required"`
	DisplayName null.String `boil:"display_name" json:"displayName,omitempty"`
	Name        null.String `boil:"name" json:"name,omitempty"`
	BirthDate   null.Time   `boil:"birth_date" json:"birthDate,omitempty"`
	Phone       null.String `boil:"phone" json:"phone,omitempty"`
}

type UserEditPwRequest struct {
	UserID      uint   `json:"userID" binding:"required"`
	OldPassword string `json:"oldPassword" binding:"required"`
	NewPassword string `json:"newPassword" binding:"required"`
}

type CheckEmailRequest struct {
	Email string `json:"email" binding:"required"`
}

type CheckDisplayNameRequest struct {
	DisplayName string `json:"displayName" binding:"required"`
}
