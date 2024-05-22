package actions

import (
	"garden/models"
	"net/http"
//	"fmt"
//	"strings"
	"log"
	"time"
//	"database/sql"
	"github.com/gofrs/uuid"
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
	return c.Render(http.StatusOK, r.JSON(plant))//r.HTML("plants/show.html"))
}

// PlantsIndex default implementation is spicifically filtering  by plants in a garden.
func PlantsIndex(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	plant := models.Plants{}
	gardenID := c.Param("garden_id")

	err := tx.Where("garden_id = ?", gardenID).All(&plant)
	if err != nil {
		c.Flash().Add("warning", "Plants not found")
		c.Redirect(301, "/")
	}

	c.Set("plant", plant)
	return c.Render(http.StatusOK, r.JSON(plant))
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
		return err//c.Redirect(302, "/")
	}
	c.Set("gardens", gardens)

	c.Logger().WithField("gardens", gardens).Info("Gardens found")
	return c.Render(http.StatusOK, r.JSON(plant))//r.HTML("plants/create.html"))
}

// PlantsNew default implementation.
func PlantsNew(c buffalo.Context) error {
    tx, ok := c.Value("tx").(*pop.Connection)
    if !ok {
        return c.Error(500, errors.New("no transaction found"))
    }
	plant := &models.Plant{}
	err := c.Bind(plant)
	if err != nil {
	//	c.Flash().Add("warning", "Plant form binding error")
		return err //c.Redirect(301, "/")
	}


	err = c.Request().ParseForm()
	if err != nil {
	//	c.Flash().Add("error", "Plant form parsing error")
		return err//c.Redirect(301, "/")
	}

	c.Logger().Info("*****date planted*****: ", plant.DatePlanted)

	gp := c.Param("gardenId")//c.Request().FormValue("Gardens")
	garden := &models.Garden{}
	err = tx.Find(garden, gp)
	if err != nil {
	//	c.Flash().Add("warning", "Garden not found")
		return err//c.Redirect(301, "/")
	}

	plant.GardenID = garden.ID

	garden.Plants = append(garden.Plants, *plant)
  dateStr := c.Request().FormValue("date_planted") 
  c.Logger().Info("Date planted: ", dateStr)
    if dateStr != "" {
        parsedDate, err := time.Parse(time.DateOnly, dateStr)
	c.Logger().Info("Parsed date: ", parsedDate)
        if err != nil {
            log.Println("Error parsing date:", err)
            return c.Error(400, errors.New("invalid date format"))
        }
        plant.DatePlanted = parsedDate
    }
	dateStr = c.Request().FormValue("date_germinated") 
    if dateStr != "" {
        
       parsedDate, err := time.Parse(time.DateOnly, dateStr)
        if err != nil {
            log.Println("Error parsing date:", err)
            return c.Error(400, errors.New("invalid date format"))
        }
        plant.DateGerminated = parsedDate
    }
	waterSchedules := models.WaterSchedule{
		Monday: false, // default
		Tuesday: false, // default
		Wednesday: false, // default
		Thursday: false, // default
		Friday: false, // default
		Saturday: false, // default
		Sunday: false, // default
		Method: "Drip", // default
        	Notes: "Defalt watering schedule", //defalt
    }
    plant.WaterSchedules = waterSchedules

	verrs, err := tx.Eager().ValidateAndCreate(plant)
	if err != nil {
		return c.Error(500, err)//c.Redirect(301, "/")
	}

	if verrs.HasAny() {
	//	c.Flash().Add("warning", "Plant validation error")
		c.Set("plant", plant)
		c.Set("errors", verrs)
		return c.Render(422, r.JSON(verrs))//r.HTML("plants/create.html"))
	}

	c.Flash().Add("success", "Plant created")
	return c.Render(201, r.JSON(plant))//(301, fmt.Sprintf("/plants/%s", plant.ID))
}

func PlantsUpdate(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	plant := models.Plant{}
	plantID := c.Param("id")
	c.Logger().Info("Plant id: ", plantID)


	gardenId := &plant.GardenID
	c.Logger().Info("Garden id: ", gardenId)
    	c.Set("gardenId", gardenId)

	gardens := &models.Gardens{}
	err := tx.All(gardens)
	if err != nil {
//		return c.Redirect(302, "/")
		return c.Render(500, r.JSON(gardens))
	}
	c.Set("gardens", gardens)

	err = tx.Eager().Find(&plant, plantID)
	if err != nil {
//		c.Flash().Add("warning", "Plant not found")
//		c.Redirect(301, "/")
		return c.Render(500, r.JSON(plant))
		c.Logger().Debug(plantID)
		c.Logger().Error("Plant not found: ", err)
	}
	c.Set("plant", plant)
//	return c.Render(http.StatusOK, r.HTML("plants/update.html"))
	return c.Render(200, r.JSON(plant))
}

func PlantsEdit(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	plant := &models.Plant{}
	if err := tx.Find(plant, c.Param("id")); err != nil {
//		return err
		return c.Render(500, r.JSON(plant))
	}
	
	err := c.Bind(plant)
	if err != nil {
//		c.Flash().Add("warning", "Plant form binding error")
//		return c.Redirect(301, "/")
		return c.Render(500, r.JSON(plant))
	}

	err = c.Request().ParseForm()
	if err != nil {
//		c.Flash().Add("error", "Plant form parsing error")
//		return c.Redirect(301, "/")
		return c.Render(500, r.JSON(plant))
	}

  dateStr := c.Request().FormValue("date_planted") 
  c.Logger().Info("Date planted: ", dateStr)
    if dateStr != "" {
        parsedDate, err := time.Parse(time.DateOnly, dateStr)
	c.Logger().Info("Parsed date: ", parsedDate)
        if err != nil {
            log.Println("Error parsing date:", err)
            return c.Error(400, errors.New("invalid date format"))
        }
        plant.DatePlanted = parsedDate
    }
	dateStr = c.Request().FormValue("date_germinated") 
    if dateStr != "" {
        
       parsedDate, err := time.Parse(time.DateOnly, dateStr)
        if err != nil {
            log.Println("Error parsing date:", err)
            return c.Error(400, errors.New("invalid date format"))
        }
        plant.DateGerminated = parsedDate
    }


	verrs, err := tx.Eager().ValidateAndUpdate(plant)
	if err != nil {
		c.Logger().Error("Plant update error: ", err)
//		return c.Redirect(301, "/")
		return c.Render(500, r.JSON(plant))
	}

	if verrs.HasAny() {
//		c.Flash().Add("warning", "Plant validation error")
		c.Set("plant", plant)
		c.Set("errors", verrs)
		c.Logger().Error("Validation errors: ", verrs)
//		return c.Render(422, r.HTML("plants/update.html"))
		return c.Render(422, r.JSON(verrs))
	}

//	c.Flash().Add("success", "Plant updated")
//	return c.Redirect(301, fmt.Sprintf("/plants/%s", plant.ID))
	return c.Render(200, r.JSON(plant))
}

func PlantsDelete(c buffalo.Context) error {
	tx :=c.Value("tx").(*pop.Connection)
	plantID := c.Param("id")
	
	plant := &models.Plant{}
	if err := tx.Find(plant, plantID); err != nil {
//		c.Flash().Add("warning", "Plant not found")
//		return c.Redirect(302, fmt.Sprintf("/plants/%s", plant.ID))
		return c.Render(500, r.JSON(plant))
	}

	journals := []models.Journal{}
	if err := tx.Where("plant_id = ?", plantID).All(&journals); err != nil {
//		c.Flash().Add("warning", "Error retreiving journals for plant")
//		return c.Redirect(302, fmt.Sprintf("/plants/%s", plant.ID))
		return c.Render(500, r.JSON(plant))
	}

	for _, j := range journals {
		id := j.ID
		 if err := DeleteJournalById(tx, id); err != nil {
//	        	c.Flash().Add("error", "Error deleting journals for plant")
//        		return c.Redirect(302, fmt.Sprintf("/plants/%s", plant.ID))
			return c.Render(500, r.JSON(plant))
		}
	}
	
	ws := models.WaterSchedule{}
	if err := tx.Where("plant_id = ?", plantID).First(&ws); err != nil {
		c.Logger().Info("Error retreiving water schedule for plant, continuing on.")
	} else {

		wsId := ws.ID

		if err := DeleteWSById(tx, wsId); err != nil {
//			c.Flash().Add("error", "Error deleting water schedule for plant")
//			return c.Redirect(302, fmt.Sprintf("/plants/%s", plant.ID))
			return c.Render(500, r.JSON(plant))
		}
	}

	pt := []models.PlantsTag{}
	if err := tx.Where("plant_id = ?", plantID).All(&pt); err != nil {
//		c.Flash().Add("warning", "Error retreiving tags for plant")
		c.Logger().Info("Could not retrieve tags for plant")
//		return c.Redirect(302, fmt.Sprintf("/plants/%s", plant.ID))
		return c.Render(500, r.JSON(plant))
	}

	for _, t := range pt {
		id := t.ID
		if err := DeletePlantTagsById(tx, id); err != nil {
//			c.Flash().Add("error", "Error deleting tags from pant")
			c.Logger().Info("Error deleting tags from plant")
//			return c.Redirect(302, fmt.Sprintf("/plants/%s", plant.ID))
			return c.Render(500, r.JSON(plant))
		}
	}

	if err := tx.Destroy(plant); err != nil {
		c.Logger().Errorf("Error deleting plant with id %s, error: %v", plantID, err)
//		c.Flash().Add("error", "Error deleting plant")
//		return c.Redirect(http.StatusFound, "/")
		return c.Render(500, r.JSON(plant))
	}

//	c.Flash().Add("success", "Plant has been deleted.")
//	return c.Redirect(301, "/")
	return c.Render(200, r.JSON(plant))
}

// Delete plant as part of parent delete
func DeletePlantById(tx *pop.Connection, plantID uuid.UUID) error {
    plant := &models.Plant{}
	if err := tx.Find(plant, plantID); err != nil {
        	return err
    	}

	journals := []models.Journal{}
	if err := tx.Where("plant_id = ?", plantID).All(&journals); err != nil {
		return err
	}

	for _, j := range journals {
		id := j.ID
		 if err := DeleteJournalById(tx, id); err != nil {
        		return err
		}
	}
	
	ws := models.WaterSchedule{}
	if err := tx.Where("plant_id = ?", plantID).First(&ws); err != nil {
		log.Printf("There is no water schedule for this plant, continuing.")
	} else {

		wsId := ws.ID

		if err := DeleteWSById(tx, wsId); err != nil {
			return err
		}
	}

	pt := []models.PlantsTag{}
	if err := tx.Where("plant_id = ?", plantID).All(&pt); err != nil {
		return err
	}

	for _, t := range pt {
		id := t.ID
		if err := DeletePlantTagsById(tx, id); err != nil {
			return err
		}
	}


	return tx.Destroy(plant)
}
