package actions

import (
	"garden/models"
	"net/http"

	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop/v6"
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

// GardensIndex default implementation.
func GardensIndex(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	garden := models.Gardens{}

	err := tx.All(&garden)
	if err != nil {
		c.Flash().Add("warning", "Gardens not found")
		c.Redirect(301, "/")
	}

	c.Set("garden", garden)
	return c.Render(http.StatusOK, r.HTML("gardens/index.html"))
}
