package actions

import (
	"garden/models"
	"net/http"
//	"fmt"
	"log"
	"github.com/gofrs/uuid"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop/v6"
)

func PlantTagIndex(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	pt := models.PlantsTags{}
	plantID := c.Param("plant_id")

	err := tx.Where("plant_id = ?", plantID).All(&pt)
	if err != nil {
		c.Flash().Add("warning", "Plant Tags not found")
		c.Redirect(301, "/")
	}

	c.Set("pt", pt)
	return c.Render(http.StatusOK, r.JSON(pt))
}

func PlantTagCreate(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	pt := &models.PlantsTag{}
	err := c.Bind(pt)
	if err != nil {
	//	c.Flash().Add("warning", "Plant Tag form binding error")
		c.Logger().Errorf("Error binding Plant Tag form: %v", err)
		return c.Redirect(301, "/")
	}

	verrs, err := tx.ValidateAndCreate(pt)
	if err != nil {
	//	c.Flash().Add("warning", "Plant Tag validation error")
		c.Logger().Errorf("Error validating Plant Tag: %v", err)
		return c.Redirect(301, "/")
	}

	if verrs.HasAny() {
		c.Set("errors", verrs)
		return c.Render(http.StatusUnprocessableEntity, r.JSON(pt))
	}

	c.Flash().Add("success", "Plant Tag created")
	return c.Render(http.StatusOK, r.JSON(pt))
	//return c.Redirect(301, fmt.Sprintf("/tags/%s", pt.TagID))
}

func PlantTagDelete(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	tagID := c.Param("tagid")
	plantID := c.Param("plantid")
	
 	query := tx.Where("plant_id = ? AND tag_id = ?", plantID, tagID)
    	pt := models.PlantsTag{}
    
    	err := query.First(&pt)
    	if err != nil {
        	c.Logger().Errorf("Error finding PlantTag with PlantID %s and TagID %s, error: %v", plantID, tagID, err)
//        	c.Flash().Add("error", "PlantTag not found")
//        	return c.Redirect(http.StatusFound, "/tags/") 
		return c.Render(http.StatusNotFound, r.JSON("PlantTag not found"))
    	}

	if err := tx.Destroy(&pt); err != nil {
		c.Logger().Errorf("Error deleting Plant Tag with tagid %s and plantid %s, error: %v", tagID, plantID, err)
//		c.Flash().Add("error", "Error deleting Plant Tag")
//		return c.Redirect(http.StatusFound, "/")
		return c.Render(http.StatusNotFound, r.JSON("PlantTag not found"))
	}

//	c.Flash().Add("success", "Plant Tag relationship updated")
//	return c.Redirect(301, fmt.Sprintf("/tags/%s", tagID))
	return c.Render(http.StatusOK, r.JSON("Plant Tag relationship deleted"))

}

// Delete tags as part of parent delete
func DeletePlantTagsById(tx *pop.Connection, ID uuid.UUID) error {
	pt := &models.PlantsTag{}

	if err := tx.Find(pt, ID); err != nil {
        	log.Printf("Warning: Error deleting plant tag relationship %s, error: %v", ID, err)
		return err
    	}

    return tx.Destroy(pt)
}

