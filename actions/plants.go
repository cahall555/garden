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
	
	gardenId := c.Param("gardenId")
    	c.Set("gardenId", gardenId)

	tx := c.Value("tx").(*pop.Connection)
	gardens := &models.Gardens{}
	err := tx.All(gardens)
	if err != nil {
		return c.Redirect(302, "/")
	}
	c.Set("gardens", gardens)

	c.Logger().WithField("gardens", gardens).Info("Gardens found")
	return c.Render(http.StatusOK, r.HTML("plants/create.html"))
}

// PlantsNew default implementation.
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

func PlantsUpdate(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	plant := models.Plant{}
	plantID := c.Param("id")
	c.Logger().Info("Plant id: ", plantID)

	err := tx.Eager("PlantTags").Find(&plant, plantID)
   	if err != nil {
		c.Logger().Error("Plant tags: ", plant.PlantTags)
		return c.Redirect(302, "/")
    	}
    
    	var tags []string
    	for _, tag := range plant.PlantTags {
        	tags = append(tags, tag.Name)
    	}
    	tagsStr := strings.Join(tags, ", ")

	gardenId := &plant.GardenID
	c.Logger().Info("Garden id: ", gardenId)
    	c.Set("gardenId", gardenId)

	gardens := &models.Gardens{}
	err = tx.All(gardens)
	if err != nil {
		return c.Redirect(302, "/")
	}
	c.Set("gardens", gardens)

	err = tx.Eager().Find(&plant, plantID)
	if err != nil {
		c.Flash().Add("warning", "Plant not found")
		c.Redirect(301, "/")
		c.Logger().Debug(plantID)
		c.Logger().Error("Plant not found: ", err)
	}
	c.Set("tagsStr", tagsStr)
	c.Set("plant", plant)
	return c.Render(http.StatusOK, r.HTML("plants/update.html"))
}

func PlantsEdit(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	plant := &models.Plant{}
	if err := tx.Find(plant, c.Param("plantId")); err != nil {
		return err
	}
	
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
	c.Logger().Info("New tags: ", newTags)
	for _, nt := range newTags {
		nt = strings.TrimSpace(nt)

	t := &models.Tag{}
	err = tx.Where("name = ?", nt).Last(t)
	c.Logger().Info("Tag: ", t)
	if err != nil {
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

		//If a new tag is added, a new relationship is created on the plants_tags table
		var plantID = plant.ID
		var tagID = t.ID

		var existingRelationship models.PlantsTag
		err := tx.Where("plant_id = ? AND tag_id = ?", plantID, tagID).First(&existingRelationship)

		if err != nil {
    			if errors.Cause(err) == sql.ErrNoRows {
        			newRelationship := &models.PlantsTag{
            				PlantID: plantID,
            				TagID:   tagID,
        	}

        		verrs, err := tx.ValidateAndCreate(newRelationship)
        		if err != nil {
            			return c.Redirect(301, "/")
        		}
        		if verrs.HasAny() {
            			c.Flash().Add("warning", "Relationship validation error")
	    			c.Set("plant", plant)
	    			c.Set("errors", verrs)
	    			c.Logger().Error("Validation errors: ", verrs)
	    			return c.Render(422, r.HTML("plants/update.html"))

    			} else {
        			c.Logger().Error("Relationship error: ", err)
    			}
		} else {
			c.Logger().Info("Relationship already exists")
		}
		}
	
	}

	verrs, err := tx.Eager().ValidateAndUpdate(plant)
	if err != nil {
		c.Logger().Error("Plant update error: ", err)
		return c.Redirect(301, "/")
	}

	if verrs.HasAny() {
		c.Flash().Add("warning", "Plant validation error")
		c.Set("plant", plant)
		c.Set("errors", verrs)
		c.Logger().Error("Validation errors: ", verrs)
		return c.Render(422, r.HTML("plants/update.html"))
	}

	c.Flash().Add("success", "Plant updated")
	return c.Redirect(301, fmt.Sprintf("/plants/%s", plant.ID))
}

func PlantsDelete(c buffalo.Context) error {
	tx :=c.Value("tx").(*pop.Connection)
	plantID := c.Param("id")
	
	plant := &models.Plant{}
	if err := tx.Find(plant, plantID); err != nil {
		c.Flash().Add("warning", "Plant not found")
		return c.Redirect(302, fmt.Sprintf("/plants/%s", plant.ID))
	}

	journals := []models.Journal{}
	if err := tx.Where("plant_id = ?", plantID).All(&journals); err != nil {
		c.Flash().Add("warning", "Error retreiving journals for plant")
		return c.Redirect(302, fmt.Sprintf("/plants/%s", plant.ID))
	}

	for _, j := range journals {
		id := j.ID
		 if err := DeleteJournalById(tx, id); err != nil {
	        	c.Flash().Add("error", "Error deleting journals for plant")
        		return c.Redirect(302, fmt.Sprintf("/plants/%s", plant.ID))
		}
	}
	
	ws := models.WaterSchedule{}
	if ws.Notes != "" {
		if err := tx.Where("plant_id = ?", plantID).First(&ws); err != nil {
			c.Flash().Add("warning", "Error retreiving water schedule for plant")
			return c.Redirect(302, fmt.Sprintf("/plants/%s", plant.ID))
		}

		wsId := ws.ID

		if err := DeleteWSById(tx, wsId); err != nil {
			c.Flash().Add("error", "Error deleting water schedule for plant")
			return c.Redirect(302, fmt.Sprintf("/plants/%s", plant.ID))
		}
	}

	pt := []models.PlantsTag{}
	if err := tx.Where("plant_id = ?", plantID).All(&pt); err != nil {
		c.Flash().Add("warning", "Error retreiving tags for plant")
		c.Logger().Info("Could not retrieve tages for plant")
		return c.Redirect(302, fmt.Sprintf("/plants/%s", plant.ID))
	}

	for _, t := range pt {
		id := t.ID
		if err := DeletePlantTagsById(tx, id); err != nil {
			c.Flash().Add("error", "Error deleting tags from pant")
			c.Logger().Info("Error deleting tags from plant")
			return c.Redirect(302, fmt.Sprintf("/plants/%s", plant.ID))
		}
	}

	if err := tx.Destroy(plant); err != nil {
		c.Logger().Errorf("Error deleting plant with id %s, error: %v", plantID, err)
		c.Flash().Add("error", "Error deleting plant")
		return c.Redirect(http.StatusFound, "/")
	}

	c.Flash().Add("success", "Plant has been deleted.")
	return c.Redirect(301, "/")
}
