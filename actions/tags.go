package actions

import (
	"garden/models"
	"net/http"

	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop/v6"
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
