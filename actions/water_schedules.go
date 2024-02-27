package actions

import (
	"garden/models"
	"net/http"
	"fmt"
	"github.com/microcosm-cc/bluemonday"
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

func WaterSchedulesCreate(c buffalo.Context) error {
	ws := models.WaterSchedule{}
	c.Set("ws", ws)

	tx := c.Value("tx").(*pop.Connection)
	plants := &models.Plants{}
	err := tx.All(plants)
	if err != nil {
		c.Logger().Error("Plants not found")
		return c.Redirect(302, "/")
	}
	
	c.Set("plants", plants)

	plantId := c.Param("plantId")
    	c.Set("plantId", plantId)

	return c.Render(http.StatusOK, r.HTML("water_schedules/create.html"))
}

func WaterSchedulesNew(c buffalo.Context) error {
	tx :=c.Value("tx").(*pop.Connection)
	ws := &models.WaterSchedule{}
	err := c.Bind(ws)
	if err != nil {
		c.Flash().Add("warning", "Water Schedule form binding error")
		return c.Redirect(301, "/")
	}

	err = c.Request().ParseForm()
	if err != nil {
		c.Flash().Add("error", "Water Schedule form parsing error")
		return c.Redirect(301, "/")
	}

	pws := c.Request().FormValue("Plant")
	plant := &models.Plant{}
	err = tx.Find(plant, pws)
	if err != nil {
		c.Logger().Error("Plant not found")
		c.Flash().Add("warning", "Plant not found")
		return c.Redirect(301, "/")
	}

	ws.PlantID = plant.ID

	plant.WaterSchedules = *ws

	rawNotes := c.Request().FormValue("Notes")
	cleanNotes := bluemonday.StrictPolicy().Sanitize(rawNotes)
	ws.Notes = cleanNotes

	verrs, err := tx.Eager().ValidateAndCreate(ws)
	if err != nil {
		return c.Redirect(301, "/")
	}

	if verrs.HasAny() {
		c.Flash().Add("warning", "Water Schedule validation error")
		c.Set("ws", ws)
		c.Set("errors", verrs)
		return c.Render(422, r.HTML("water_schedules/create.html"))
	}

	c.Flash().Add("success", "Water Schedule created")
	return c.Redirect(301, fmt.Sprintf("/water_schedules/%s", ws.ID))
}

func WaterSchedulesUpdate(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	ws := models.WaterSchedule{}
	wsID := c.Param("id")
	c.Logger().Info("Water schedule id: ", wsID)

	err := tx.Eager().Find(&ws, wsID)
	if err != nil {
		c.Logger().Error("Water Schedule not found, id: ", wsID)
		c.Flash().Add("warning", "Water Schedule not found")
		c.Redirect(301, "/")
	}

	c.Set("ws", ws)

	plants := &models.Plants{}
	err = tx.All(plants)
	if err != nil {
		c.Logger().Error("Plants not found")
		return c.Redirect(302, "/")
	}
	
	plantId := ws.PlantID
	c.Set("plantId", plantId)
	c.Set("plants", plants)

	return c.Render(http.StatusOK, r.HTML("water_schedules/update.html"))
}

func WaterSchedulesEdit(c buffalo.Context) error {
	tx :=c.Value("tx").(*pop.Connection)
	ws := &models.WaterSchedule{}
	if err := tx.Find(ws, c.Param("wsId")); err != nil {
		return err
	}

	err := c.Bind(ws)
	if err != nil {
		c.Flash().Add("warning", "Water Schedule form binding error")
		return c.Redirect(301, "/")
	}

	err = c.Request().ParseForm()
	if err != nil {
		c.Flash().Add("error", "Water Schedule form parsing error")
		return c.Redirect(301, "/")
	}

	pws := c.Request().FormValue("Plant")
	plant := &models.Plant{}
	err = tx.Find(plant, pws)
	if err != nil {
		c.Logger().Error("Plant not found")
		c.Flash().Add("warning", "Plant not found")
		return c.Redirect(301, "/")
	}

	plant.WaterSchedules = *ws

	rawNotes := c.Request().FormValue("Notes")
	cleanNotes := bluemonday.StrictPolicy().Sanitize(rawNotes)
	ws.Notes = cleanNotes

	verrs, err := tx.Eager().ValidateAndUpdate(ws)
	if err != nil {
		return c.Redirect(301, "/")
	}

	if verrs.HasAny() {
		c.Flash().Add("warning", "Water Schedule validation error")
		c.Set("ws", ws)
		c.Set("errors", verrs)
		return c.Render(422, r.HTML("water_schedules/update.html"))
	}

	c.Flash().Add("success", "Water Schedule updated")
	return c.Redirect(301, fmt.Sprintf("/water_schedules/%s", ws.ID))
}	

