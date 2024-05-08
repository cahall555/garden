package actions

import (
	"garden/models"
	"net/http"
//	"fmt"
	"github.com/pkg/errors"
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
	return c.Render(http.StatusOK, r.JSON(garden))//r.HTML("gardens/index.html"))
}

// GardensCreate default implementation.
func GardensCreate(c buffalo.Context) error {
	garden := models.Garden{}
	c.Set("garden", garden)
	return c.Render(http.StatusOK, r.JSON(garden)) //r.HTML("gardens/create.html"))
}

// GardensNew default implementation.
func GardensNew(c buffalo.Context) error {
	tx, ok := c.Value("tx").(*pop.Connection)
    if !ok {
        return c.Error(500, errors.New("no transaction found"))
    }
    garden := &models.Garden{}
    if err := c.Bind(garden); err != nil {
        return err
    }
    verrs, err := tx.ValidateAndCreate(garden)
    if err != nil {
        return c.Error(500, err)
    }
    if verrs.HasAny() {
        return c.Render(422, r.JSON(verrs))
    }
    return c.Render(201, r.JSON(garden))

/*
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
	return c.Redirect(301, fmt.Sprintf("/gardens/%s", garden.ID)) */
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
	return c.Render(http.StatusOK, r.JSON(garden))// r.HTML("gardens/update.html"))
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
		return c.Render(422, r.JSON(garden)) //r.HTML("gardens/update.html"))
	}

	c.Flash().Add("success", "Garden updated")
	return c.Render(http.StatusOK, r.JSON(garden)) //fmt.Sprintf("/gardens/%s", garden.ID))
}

func GardensDelete(c buffalo.Context) error {
	tx :=c.Value("tx").(*pop.Connection)
	gardenID := c.Param("id")
	
	garden := &models.Garden{}
	if err := tx.Find(garden, gardenID); err != nil {
//		c.Flash().Add("warning", "Garden not found")
//		return c.Redirect(302, fmt.Sprintf("/gardens/%s", garden.ID))
		return c.Render(http.StatusNotFound, r.JSON("Garden not found"))
	}

	plants := []models.Plant{}
	if err := tx.Where("garden_id = ?", gardenID).All(&plants); err != nil {
//		c.Flash().Add("warning", "Error retreiving plants for garden.")
//		return c.Redirect(302, fmt.Sprintf("/gardens/%s", garden.ID))
		return c.Render(http.StatusNotFound, r.JSON("Error retreiving plants for garden."))
	}

	for _, p := range plants {
		id := p.ID
		 if err := DeletePlantById(tx, id); err != nil {
//	        	c.Flash().Add("error", "Error deleting plants for garden.")
//        		return c.Redirect(302, fmt.Sprintf("/gardens/%s", garden.ID))
			return c.Render(http.StatusNotFound, r.JSON("Error deleting plants for garden."))
		}
	}

	if err := tx.Destroy(garden); err != nil {
		c.Logger().Errorf("Error deleting garden with id %s, error: %v", gardenID, err)
//		c.Flash().Add("error", "Error deleting garden.")
//		return c.Redirect(http.StatusFound, "/")
		return c.Render(http.StatusNotFound, r.JSON("Error deleting garden."))
	}

//	c.Flash().Add("success", "Garden successfully deleted")
//	return c.Redirect(http.StatusFound, "/")
	return c.Render(http.StatusOK, r.JSON("Garden successfully deleted"))

}
