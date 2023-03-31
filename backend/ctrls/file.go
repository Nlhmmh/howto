package ctrls

import (
	"backend/ers"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

type fileCtrl struct{}

var (
	fileCtrls *fileCtrl
)

// *********************************************** //

func (o *fileCtrl) Upload(c *gin.Context) {

	file, err := c.FormFile("file")
	if err != nil {
		ers.BadRequestResp(c, err)
		return
	}

	filePathName := strconv.FormatInt(time.Now().Unix(), 10) + "-" + file.Filename
	if err := c.SaveUploadedFile(file, "./media/"+filePathName); err != nil {
		ers.ServerErrorResp(c, err)
		return
	}

	c.JSON(http.StatusOK, map[string]any{"filePath": "/api/file/media/" + filePathName})

}
