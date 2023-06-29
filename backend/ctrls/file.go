package ctrls

import (
	"backend/ers"
	"backend/utils"
	"net/http"
	"os"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
)

type file struct{}

var (
	File *file
)

// *********************************************** //

func (o *file) Upload(c *gin.Context) {

	file, err := c.FormFile("file")
	if err != nil {
		ers.BadRequestResp(c, err)
		return
	}

	filePath := strconv.FormatInt(time.Now().Unix(), 10) + "-" + file.Filename
	if err := c.SaveUploadedFile(file, "./media/"+filePath); err != nil {
		ers.ServerErrorResp(c, err)
		return
	}

	c.JSON(http.StatusOK, RespMap{"filePath": "/api/file/media/" + filePath})

}

func (o *file) Delete(filePath string) error {

	if err := os.Remove(
		utils.MediaFolder +
			"/" +
			strings.ReplaceAll(filePath, "/api/file/media/", ""),
	); err != nil {
		return err
	}

	return nil

}

// *********************************************** //
