package actions

import (
	"garden/models"
	"net/http"
	"fmt"
	"log"
	"github.com/gofrs/uuid"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop/v6"
)

func PlantTagDelete(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	tagID := c.Param("tagid")
	plantID := c.Param("plantid")
	
 	query := tx.Where("plant_id = ? AND tag_id = ?", plantID, tagID)
    	pt := models.PlantsTag{}
    
    	err := query.First(&pt)
    	if err != nil {
        	c.Logger().Errorf("Error finding PlantTag with PlantID %s and TagID %s, error: %v", plantID, tagID, err)
        	c.Flash().Add("error", "PlantTag not found")
        	return c.Redirect(http.StatusFound, "/tags/") 
    	}

	if err := tx.Destroy(&pt); err != nil {
		c.Logger().Errorf("Error deleting Plant Tag with tagid %s and plantid %s, error: %v", tagID, plantID, err)
		c.Flash().Add("error", "Error deleting Plant Tag")
		return c.Redirect(http.StatusFound, "/")
	}

	c.Flash().Add("success", "Plant Tag relationship updated")
	return c.Redirect(301, fmt.Sprintf("/tags/%s", tagID))

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

