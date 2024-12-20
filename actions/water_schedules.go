package actions

import (
	"garden/models"
	"net/http"

	//	"fmt"
	"database/sql"

	"github.com/gofrs/uuid"
	"github.com/pkg/errors"

	//	"github.com/microcosm-cc/bluemonday"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop/v6"
)

// WaterSchedulesShow default implementation.
func WaterSchedulesShow(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	ws := models.WaterSchedule{}
	wsID := c.Param("id")

	err := tx.Eager().Find(&ws, wsID)
	if err != nil {
		c.Flash().Add("warning", "Water Schedule not found")
		return c.Render(http.StatusNotFound, r.JSON(map[string]string{"warning": "Water Schedule not found"}))
	}

	c.Set("ws", ws)

	return c.Render(http.StatusOK, r.JSON(ws)) //r.HTML("water_schedules/show.html"))
}

func WaterSchedulesIndex(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	ws := models.WaterSchedule{}
	plantID := c.Param("plant_id")

	err := tx.Where("plant_id = ?", plantID).First(&ws)

	if errors.Is(err, sql.ErrNoRows) {
		return c.Render(http.StatusNotFound, r.JSON(map[string]string{"warning": "Water Schedule not found for the provided plant ID"}))
	} else if err != nil {
		// For other types of errors, return a 500 Internal Server Error
		return errors.WithStack(err)
	}

	c.Set("ws", ws)
	return c.Render(http.StatusOK, r.JSON(ws))
}

func WaterSchedulesCreate(c buffalo.Context) error {
	ws := models.WaterSchedule{}
	c.Set("ws", ws)

	tx := c.Value("tx").(*pop.Connection)
	plants := &models.Plants{}
	err := tx.All(plants)
	if err != nil {
		//		c.Logger().Error("Plants not found")
		return c.Render(302, r.JSON(map[string]string{"error": "Plants not found"}))
	}

	c.Set("plants", plants)

	plantId := c.Param("plantId")
	c.Set("plantId", plantId)

	return c.Render(http.StatusOK, r.JSON(ws)) //r.HTML("water_schedules/create.html"))
}

func WaterSchedulesNew(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	ws := &models.WaterSchedule{}
	err := c.Bind(ws)
	if err != nil {
		//	c.Flash().Add("warning", "Water Schedule form binding error")
		return c.Render(302, r.JSON(map[string]string{"error": "Water Schedule form binding error"}))
	}

	err = c.Request().ParseForm()
	if err != nil {
		//	c.Flash().Add("error", "Water Schedule form parsing error")
		return c.Render(302, r.JSON(map[string]string{"error": "Water Schedule form parsing error"}))
	}

	pws := c.Param("plantId") //c.Request().FormValue("Plant")
	plant := &models.Plant{}
	err = tx.Find(plant, pws)
	if err != nil {
		c.Logger().Error("Plant not found")
		//	c.Flash().Add("warning", "Plant not found")
		return c.Render(302, r.JSON(map[string]string{"error": "Plant not found"}))
	}

	ws.PlantID = plant.ID

	plant.WaterSchedules = *ws

	//	rawNotes := c.Request().FormValue("Notes")
	//	cleanNotes := bluemonday.StrictPolicy().Sanitize(rawNotes)
	//	ws.Notes = cleanNotes

	verrs, err := tx.Eager().ValidateAndCreate(ws)
	if err != nil {
		return c.Render(500, r.JSON(map[string]string{"error": "Error saving water schedule"}))
	}

	if verrs.HasAny() {
		//		c.Flash().Add("warning", "Water Schedule validation error")
		c.Set("ws", ws)
		c.Set("errors", verrs)
		return c.Render(422, r.JSON(verrs)) //r.HTML("water_schedules/create.html"))
	}

	//	c.Flash().Add("success", "Water Schedule created")
	return c.Render(201, r.JSON(ws)) //c.Redirect(301, fmt.Sprintf("/water_schedules/%s", ws.ID))
}

func WaterSchedulesUpdate(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	ws := models.WaterSchedule{}
	wsID := c.Param("id")
	c.Logger().Info("Water schedule id: ", wsID)

	err := tx.Eager().Find(&ws, wsID)
	if err != nil {
		c.Logger().Error("Water Schedule not found, id: ", wsID)
		//c.Flash().Add("warning", "Water Schedule not found")
		c.Render(http.StatusNotFound, r.JSON(map[string]string{"warning": "Water Schedule not found, id: " + wsID}))
	}

	c.Set("ws", ws)

	plants := &models.Plants{}
	err = tx.All(plants)
	if err != nil {
		c.Logger().Error("Plants not found")
		return c.Render(500, r.JSON(map[string]string{"error": "Plants not found"}))
	}

	plantId := ws.PlantID
	c.Set("plantId", plantId)
	c.Set("plants", plants)

	return c.Render(http.StatusOK, r.JSON(ws)) //r.HTML("water_schedules/update.html"))
}

func WaterSchedulesEdit(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	ws := &models.WaterSchedule{}
	if err := tx.Find(ws, c.Param("wsId")); err != nil {
		return err
	}

	err := c.Bind(ws)
	if err != nil {
		//	c.Flash().Add("warning", "Water Schedule form binding error")
		return c.Render(302, r.JSON(map[string]string{"error": "Water Schedule form binding error"}))
	}

	err = c.Request().ParseForm()
	if err != nil {
		//	c.Flash().Add("error", "Water Schedule form parsing error")
		return c.Render(302, r.JSON(map[string]string{"error": "Water Schedule form parsing error"}))
	}

	pws := c.Param("plantId") //c.Request().FormValue("Plant")
	plant := &models.Plant{}
	err = tx.Find(plant, pws)
	if err != nil {
		c.Logger().Error("Plant not found")
		//	c.Flash().Add("warning", "Plant not found")
		return c.Render(302, r.JSON(map[string]string{"error": "Plant not found"}))
	}

	plant.WaterSchedules = *ws

	//	rawNotes := c.Request().FormValue("Notes")
	//	cleanNotes := bluemonday.StrictPolicy().Sanitize(rawNotes)
	//	ws.Notes = cleanNotes

	verrs, err := tx.Eager().ValidateAndUpdate(ws)
	if err != nil {
		return c.Render(500, r.JSON(map[string]string{"error": "Error saving water schedule"}))
	}

	if verrs.HasAny() {
		c.Flash().Add("warning", "Water Schedule validation error")
		c.Set("ws", ws)
		c.Set("errors", verrs)
		return c.Render(422, r.JSON(verrs)) //r.HTML("water_schedules/update.html"))
	}

	//	c.Flash().Add("success", "Water Schedule updated")
	return c.Render(201, r.JSON(ws)) //c.Redirect(301, fmt.Sprintf("/water_schedules/%s", ws.ID))
}

func WaterSchedulesDelete(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	wsId := c.Param("id")

	ws := models.WaterSchedule{}
	if err := tx.Find(&ws, wsId); err != nil {
		c.Logger().Errorf("Error finding Water Schedule with id %s, error: %v", wsId, err)
		//		c.Flash().Add("error", "Water Schedule not found")
		return c.Render(http.StatusNotFound, r.JSON(map[string]string{"error": "Water Schedule not found"}))
	}

	if err := tx.Destroy(&ws); err != nil {
		c.Logger().Errorf("Error deleting Water Schedule with id %s, error: %v", wsId, err)
		//		c.Flash().Add("error", "Error deleting Water Schedule")
		return c.Render(500, r.JSON(map[string]string{"error": "Error deleting Water Schedule"}))
	}

	c.Flash().Add("success", "Water Schedule successfully deleted")
	return c.Render(200, r.JSON(map[string]string{"success": "Water Schedule successfully deleted"}))
}

// Delete water schedule as part of parent delete
func DeleteWSById(tx *pop.Connection, WSID uuid.UUID) error {
	ws := &models.WaterSchedule{}
	if err := tx.Find(ws, WSID); err != nil {
		return err
	}

	return tx.Destroy(ws)
}
