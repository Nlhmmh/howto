package models

import "github.com/volatiletech/null"

type User struct {
	DisplayName string      `boil:"display_name" json:"displayName" toml:"displayName" yaml:"displayName" binding:"required"`
	Name        string      `boil:"name" json:"name" toml:"name" yaml:"name" binding:"required"`
	BirthDate   null.Time   `boil:"birth_date" json:"birthDate,omitempty" toml:"birthDate" yaml:"birthDate,omitempty"`
	Phone       null.String `boil:"phone" json:"phone,omitempty" toml:"phone" yaml:"phone,omitempty"`
	Email       string      `boil:"email" json:"email" toml:"email" yaml:"email" binding:"required"`
	Password    string      `boil:"password" json:"password" toml:"password" yaml:"password" binding:"required"`
	Type        string      `boil:"type" json:"type" toml:"type" yaml:"type" binding:"required"`
}

type LoginRequest struct {
	EmailOrDispName string `json:"emailOrDispName" binding:"required"`
	Password        string `json:"password" binding:"required"`
}

type UserEditRequest struct {
	ID          uint        `boil:"id" json:"id" binding:"required"`
	DisplayName null.String `boil:"display_name" json:"displayName,omitempty"`
	Name        null.String `boil:"name" json:"name,omitempty"`
	BirthDate   null.Time   `boil:"birth_date" json:"birthDate,omitempty"`
	Phone       null.String `boil:"phone" json:"phone,omitempty"`
}
