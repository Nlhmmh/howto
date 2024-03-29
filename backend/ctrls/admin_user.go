package ctrls

import (
	"backend/boiler"
	"backend/ers"
	"backend/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

type adminUser struct{}

var (
	AdminUser *adminUser
)

// *********************************************** //

func (o *adminUser) GetAll(c *gin.Context) {

	// Get All Users
	users, err := boiler.Users().AllG(c)
	if err != nil {
		ers.InternalServer.New(err).Abort(c)
		return
	}

	c.JSON(http.StatusOK, users)

}

// *********************************************** //

func (o *adminUser) Get(c *gin.Context) {

	// Get userID
	userID, err := utils.CheckBlankString(c.Param("userID"))
	if err != nil {
		ers.BadRequest.New(err).Abort(c)
		return
	}

	// Get User
	user, err := boiler.FindUserG(c, userID)
	if err != nil {
		ers.InternalServer.New(err).Abort(c)
		return
	}

	c.JSON(http.StatusOK, user)

}
