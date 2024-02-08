package actions

import (
	"net/http"
	"garden/models"
	"github.com/gobuffalo/pop/v6"
	"github.com/gobuffalo/buffalo"
)

// TagsShow default implementation.
func TagsShow(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	tag := models.Tag{}
	tagID := c.Param("id")

	err := tx.Eager().Find(&tag, tagID)
	if err != nil {
		c.Flash().Add("warning", "Tag not found")
		c.Redirect(301, "/")
	}

	c.Set("tag", tag)
	return c.Render(http.StatusOK, r.HTML("tags/show.html"))
}

