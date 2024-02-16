package actions

import (
	"garden/models"
	"net/http"
	"fmt"
	"strings"
	"log"
	"database/sql"
	"github.com/pkg/errors"
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

// PlantsCreate default implementation.
func PlantsCreate(c buffalo.Context) error {
	plant := models.Plant{}
	c.Set("plant", plant)

	tx := c.Value("tx").(*pop.Connection)
	gardens := &models.Gardens{}
	err := tx.All(gardens)
	if err != nil {
		return c.Redirect(302, "/")
	}
	c.Set("gardens", gardens)

	return c.Render(http.StatusOK, r.HTML("plants/create.html"))
}

// PlantssNew default implementation.
func PlantsNew(c buffalo.Context) error {
	tx :=c.Value("tx").(*pop.Connection)
	plant := &models.Plant{}
	err := c.Bind(plant)
	if err != nil {
		c.Flash().Add("warning", "Plant form binding error")
		return c.Redirect(301, "/")
	}


	err = c.Request().ParseForm()
	if err != nil {
		c.Flash().Add("error", "Plant form parsing error")
		return c.Redirect(301, "/")
	}
	
	pts := c.Request().FormValue("Tags")
	newTags := strings.Split(pts, ",")
	for _, nt := range newTags {
		nt = strings.TrimSpace(nt)

	t := &models.Tag{}
	err = tx.Where("name = ?", nt).Last(t)
	if err != nil {
		c.Flash().Add("warning", "Tags not found")
		if errors.Cause(err) == sql.ErrNoRows {
			t.Name = nt
			err2 := tx.Create(t)
			if err2 != nil {
				log.Fatal(err2)
				c.Flash().Add("error", "Tags creation error")
			}
			} else {
				log.Fatal(err)
				continue
			}
		}
		plant.PlantTags = append(plant.PlantTags, *t)
	}

	gp := c.Request().FormValue("Gardens")
	garden := &models.Garden{}
	err = tx.Find(garden, gp)
	if err != nil {
		c.Flash().Add("warning", "Garden not found")
		return c.Redirect(301, "/")
	}

	plant.GardenID = garden.ID

	garden.Plants = append(garden.Plants, *plant)

	verrs, err := tx.Eager().ValidateAndCreate(plant)
	if err != nil {
		return c.Redirect(301, "/")
	}

	if verrs.HasAny() {
		c.Flash().Add("warning", "Plant validation error")
		c.Set("plant", plant)
		c.Set("errors", verrs)
		return c.Render(422, r.HTML("plants/create.html"))
	}

	c.Flash().Add("success", "Plant created")
	return c.Redirect(301, fmt.Sprintf("/plants/%s", plant.ID))
}

