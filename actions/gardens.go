package actions

import (
	"garden/models"
	"net/http"
	"fmt"
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

// GardensCreate default implementation.
func GardensCreate(c buffalo.Context) error {
	garden := models.Garden{}
	c.Set("garden", garden)
	return c.Render(http.StatusOK, r.HTML("gardens/create.html"))
}

// GardensNew default implementation.
func GardensNew(c buffalo.Context) error {
	tx :=c.Value("tx").(*pop.Connection)
	garden := &models.Garden{}
	err := c.Bind(garden)
	if err != nil {
		c.Flash().Add("warning", "Garden form binding error")
		return c.Redirect(301, "/")
	}
	
	verrs, err := tx.ValidateAndCreate(garden)
	if err != nil {
		return c.Redirect(301, "/")
	}

	if verrs.HasAny() {
		c.Flash().Add("warning", "Garden validation error")
		c.Set("garden", garden)
		c.Set("errors", verrs)
		return c.Render(422, r.HTML("gardens/create.html"))
	}

	c.Flash().Add("success", "Garden created")
	return c.Redirect(301, fmt.Sprintf("/gardens/%s", garden.ID))
}

func GardensUpdate(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	garden := models.Garden{}
	gardenID := c.Param("id")
	c.Logger().Info("Garden id: ", gardenID)

	err := tx.Eager().Find(&garden, gardenID)
	if err != nil {
		c.Flash().Add("warning", "Garden not found")
		c.Redirect(301, "/")
		c.Logger().Debug(gardenID)
		c.Logger().Error("Garden not found: ", err)
	}
	c.Set("garden", garden)
	return c.Render(http.StatusOK, r.HTML("gardens/update.html"))
}

func GardensEdit(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	garden := &models.Garden{}
	if err := tx.Find(garden, c.Param("gardenId")); err != nil {
		return err
	}
	
	err := c.Bind(garden)
	if err != nil {
		c.Flash().Add("warning", "Garden form binding error")
		return c.Redirect(301, "/")
	}

	verrs, err := tx.ValidateAndUpdate(garden)
	if err != nil {
		c.Logger().Error("Garden update error: ", err)
		return c.Redirect(301, "/")
	}

	if verrs.HasAny() {
		c.Flash().Add("warning", "Garden validation error")
		c.Set("garden", garden)
		c.Set("errors", verrs)
		c.Logger().Error("Validation errors: ", verrs)
		return c.Render(422, r.HTML("gardens/update.html"))
	}

	c.Flash().Add("success", "Garden updated")
	return c.Redirect(301, fmt.Sprintf("/gardens/%s", garden.ID))
}
