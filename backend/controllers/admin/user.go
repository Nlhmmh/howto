package admin

import (
	"backend/boiler"
	"backend/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

type userCtrl struct{}

var (
	UserCtrl *userCtrl
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
