package controllers

import (
	"backend/boiler"
	"backend/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

type adminUserCtrl struct{}

var (
	adminUserCtrls *adminUserCtrl
)

// *********************************************** //

func (o *adminUserCtrl) GetAll(c *gin.Context) {

	// Get All Users
	users, err := boiler.Users().AllG(c)
	if err != nil {
		ServerErrorResp(c, err)
		return
	}

	c.JSON(http.StatusOK, users)

}

// *********************************************** //

func (o *adminUserCtrl) Get(c *gin.Context) {

	// Get userID
	userID, err := utils.CheckBlankString(c.Param("userID"))
	if err != nil {
		BadRequestResp(c, err)
		return
	}

	// Get User
	user, err := boiler.FindUserG(c, userID)
	if err != nil {
		ServerErrorResp(c, err)
		return
	}

	c.JSON(http.StatusOK, user)

}