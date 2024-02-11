package actions

import (
	"garden/models"
	"net/http"

	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop/v6"
)

// PlantsShow default implementation.
func PlantsShow(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	plant := models.Plant{}
	plantID := c.Param("id")

	err := tx.Eager().Find(&plant, plantID)
	if err != nil {
		c.Flash().Add("warning", "Plant not found")
		c.Redirect(301, "/")
	}

	c.Set("plant", plant)
	return c.Render(http.StatusOK, r.HTML("plants/show.html"))
}
