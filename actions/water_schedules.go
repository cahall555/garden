package actions

import (
	"garden/models"
	"net/http"
	"github.com/gobuffalo/pop/v6"
	"github.com/gobuffalo/buffalo"
)

// WaterSchedulesShow default implementation.
func WaterSchedulesShow(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	ws := models.WaterSchedule{}
	wsID := c.Param("id")

	err := tx.Eager().Find(&ws, wsID)
	if err != nil {
		c.Flash().Add("warning", "Water Schedule not found")
		c.Redirect(301, "/")
	}

	c.Set("ws", ws)

	return c.Render(http.StatusOK, r.HTML("water_schedules/show.html"))
}

