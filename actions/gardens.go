package actions

import (
	"garden/models"
	"net/http"
	"github.com/gobuffalo/pop/v6"
	"github.com/gobuffalo/buffalo"
)

// GardensShow default implementation.
func GardensShow(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	garden := models.Garden{}
	gardenID := c.Param("id")

	err := tx.Eager().Find(&garden, gardenID)
	if err != nil {
		c.Flash().Add("warning", "Garden not found")
		c.Redirect(301, "/")
	}

	c.Set("garden", garden)
	return c.Render(http.StatusOK, r.HTML("gardens/show.html"))
}



