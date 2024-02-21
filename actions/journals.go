package actions

import (
	"garden/models"
	"net/http"
	"fmt"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop/v6"
)


// JournalsShow default implementation.
func JournalsShow(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	journal := models.Journal{}
	JournalID := c.Param("id")

	err := tx.Find(&journal, JournalID)
	if err != nil {
		c.Flash().Add("warning", "Journal not found")
		c.Redirect(301, "/")
	}

	c.Set("journal", journal)
	return c.Render(http.StatusOK, r.HTML("journals/show.html"))
}

// JournalsIndex default implementation.
func JournalsIndex(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	journal := models.Journals{}

	err := tx.All(&journal)
	if err != nil {
		c.Flash().Add("warning", "Journals not found")
		c.Redirect(301, "/")
	}

	c.Set("journal", journal)
	return c.Render(http.StatusOK, r.HTML("journals/index.html"))
}

func JournalsCreate(c buffalo.Context) error {
	journal := models.Journal{}	
	c.Set("journal", journal)
	
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
	
	c.Logger().Debug("Trying to understand the plants and plantId.")
	c.Logger().Warn("Trying to understand the plants and plantId.")
	c.Logger().Error("Trying to understand the plants and plantId.")
	c.Logger().WithField("Plants", plants).Info("Plants found.")

	return c.Render(http.StatusOK, r.HTML("journals/create.html"))
}

func JournalsNew(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	journal := &models.Journal{}
	err := c.Bind(journal)
	if err != nil {
		c.Flash().Add("warning", "Journal form binding error")
		return c.Redirect(301, "/")
	}

	err = c.Request().ParseForm()
	if err != nil {
		c.Flash().Add("error", "Journal form parsing error")
		return c.Redirect(301, "/")
	}

	pj := c.Request().FormValue("Plant")
	plant := &models.Plant{}
	err = tx.Find(plant, pj)
	if err != nil {
		c.Logger().Error("Plant not found")
		c.Flash().Add("warning", "Plant not found")
		return c.Redirect(301, "/")
	}

	journal.PlantID = plant.ID

//	plant.Journals = append(plant.Journals, *journal)

	verrs, err := tx.Eager().ValidateAndCreate(journal)
	if err != nil {
		c.Logger().Error("Journal error, issue with validation and creation")
		return c.Redirect(301, "/")
	}

	if verrs.HasAny() {
		c.Flash().Add("warning", "Journal validation error")
		c.Set("journal", journal)
		c.Set("errors", verrs)
		return c.Render(422, r.HTML("journals/create.html"))
	}
	

	c.Flash().Add("success", "Journal created")
	return c.Redirect(301, fmt.Sprintf("/journals/%s", journal.ID))
}
