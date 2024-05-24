package actions

import (
	"garden/models"
	"net/http"
	"os"
	"io"
	"log"
	"path/filepath"
	"github.com/gofrs/uuid"
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
		c.Render(404, r.JSON(map[string]string{"error": "Journal not found"}))
	}

	c.Set("journal", journal)
	return c.Render(http.StatusOK, r.JSON(journal))
}

// JournalsIndex default implementation.
func JournalsIndex(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	journal := models.Journals{}

	err := tx.All(&journal)
	if err != nil {
		c.Render(500, r.JSON(map[string]string{"error": "Journals not found"}))
	}

	c.Set("journal", journal)
	return c.Render(http.StatusOK, r.JSON(journal))
}

// JournalsIndex default implementation filtering by plant.
func PlantJournals(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	journal := models.Journals{}
	plantID := c.Param("plant_id")

	err := tx.Where("plant_id = ?", plantID).All(&journal)
	if err != nil {
		return c.Render(500, r.JSON(map[string]string{"error": "Journals not found"}))
	}

	c.Set("journal", journal)
	return c.Render(http.StatusOK, r.JSON(journal))
}

func JournalsCreate(c buffalo.Context) error {
	journal := models.Journal{}	
	c.Set("journal", journal)
	
	tx := c.Value("tx").(*pop.Connection)
	plants := &models.Plants{}
	err := tx.All(plants)
	if err != nil {
		c.Logger().Error("Plants not found")
		return c.Render(500, r.JSON(map[string]string{"error": "Plants not found"}))
	}
	
	c.Set("plants", plants)

	plantId := c.Param("plantId")
    	c.Set("plantId", plantId)
	
	c.Logger().Debug("Trying to understand the plants and plantId.")
	c.Logger().Warn("Trying to understand the plants and plantId.")
	c.Logger().Error("plantId: ", plantId)
	c.Logger().WithField("Plants", plants).Info("Plants found.")

	return c.Render(http.StatusOK, r.JSON(journal))
}
func JournalsNew(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	journal := &models.Journal{}

	if err := c.Request().ParseMultipartForm(10 << 20); err != nil { 
		c.Logger().Error("Failed to parse multipart form: ", err)
		return c.Render(400, r.JSON(map[string]string{"error": "Error parsing form"}))
	}

	journal.Title = c.Request().FormValue("title")
	journal.Entry = c.Request().FormValue("entry")
	journal.Category = models.Category(c.Request().FormValue("category"))
	journal.PlantID = uuid.FromStringOrNil(c.Request().FormValue("plant_id"))
	journal.DisplayOnGarden = c.Request().FormValue("display_in_garden") == "true"

	file, header, err := c.Request().FormFile("_imagePath")
	if err == http.ErrMissingFile {
		c.Logger().Info("No file uploaded, skipping image logic.")
		journal.Image = ""
	} else if err != nil {
		c.Logger().Error("Error getting uploaded file: ", err)
		return c.Render(400, r.JSON(map[string]string{"error": "Error processing uploaded file"}))
	} else {
		defer file.Close()
		newFileName := uuid.Must(uuid.NewV4()).String() + filepath.Ext(header.Filename)
		savePath := filepath.Join("frontend/assets", newFileName)

		outFile, err := os.Create(savePath)
		if err != nil {
			c.Logger().Error("Error creating file on server: ", err)
			return c.Render(500, r.JSON(map[string]string{"error": "Error saving file on server"}))
		}
		defer outFile.Close()

		if _, err = io.Copy(outFile, file); err != nil {
			c.Logger().Error("Error copying file to server: ", err)
			return c.Render(500, r.JSON(map[string]string{"error": "Error saving file on server"}))
		}
		journal.Image = newFileName
	}

	verrs, err := tx.Eager().ValidateAndCreate(journal)
	if err != nil {
		c.Logger().Error("Journal creation failed: ", err)
		return c.Render(500, r.JSON(map[string]string{"error": "Error saving journal"}))
	}

	if verrs.HasAny() {
		c.Set("journal", journal)
		c.Set("errors", verrs)
		return c.Render(422, r.JSON(verrs))
	}

	return c.Render(200, r.JSON(journal))
}

func JournalsUpdate(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	journal := models.Journal{}
	journalID := c.Param("id")
	c.Logger().Info("Journal id: ", journalID)

	err := tx.Eager().Find(&journal, journalID)
	if err != nil {
		c.Logger().Error("Journal not found, id: ", journalID)
		c.Render(404, r.JSON(map[string]string{"error": "Journal not found, id: " + journalID}))
	}

	c.Set("journal", journal)

	plants := &models.Plants{}
	err = tx.All(plants)
	if err != nil {
		c.Logger().Error("Plants not found")
		return c.Render(500, r.JSON(map[string]string{"error": "Plants not found"}))
	}
	
	plantId := journal.PlantID
	c.Set("plantId", plantId)
	c.Set("plants", plants)

	return c.Render(http.StatusOK, r.JSON(journal))

}

func JournalsEdit(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	journal := &models.Journal{}
	if err := tx.Find(journal, c.Param("id")); err != nil {
		return c.Render(404, r.JSON(map[string]string{"error": "Journal not found"}))
	}

	if err := c.Request().ParseMultipartForm(10 << 20); err != nil {
		c.Logger().Error("Failed to parse multipart form: ", err)
		return c.Render(400, r.JSON(map[string]string{"error": "Error parsing form"}))
	}

	journal.Title = c.Request().FormValue("title")
	journal.Entry = c.Request().FormValue("entry")
	journal.Category = models.Category(c.Request().FormValue("category"))
	journal.PlantID = uuid.FromStringOrNil(c.Request().FormValue("plant_id"))
	journal.DisplayOnGarden = c.Request().FormValue("display_in_garden") == "true"

	c.Logger().Info("****Journal entry *******: ", journal.Entry)

	file, header, err := c.Request().FormFile("_imagePath")
	c.Logger().Info("File: ", file)
	c.Logger().Info("Header: ", header)
	c.Logger().Info("Error: ", err)
	if err == http.ErrMissingFile{
		c.Logger().Info("No new file uploaded, preserving existing image if exists.")
	} else if err != nil {
		c.Logger().Error("Error getting uploaded file: ", err)
		return c.Render(400, r.JSON(map[string]string{"error": "Error processing uploaded file"}))
	} else {
		defer file.Close()

		newFileName := uuid.Must(uuid.NewV4()).String() + filepath.Ext(header.Filename)
		savePath := filepath.Join("frontend/assets", newFileName)

		outFile, err := os.Create(savePath)
		if err != nil {
			c.Logger().Error("Error creating file on server: ", err)
			return c.Render(500, r.JSON(map[string]string{"error": "Error saving file on server"}))
		}
		defer outFile.Close()

		if _, err = io.Copy(outFile, file); err != nil {
			c.Logger().Error("Error copying file to server: ", err)
			return c.Render(500, r.JSON(map[string]string{"error": "Error saving file on server"}))
		}
		c.Logger().Info("New image saved: ", newFileName)
		c.Logger().Info("Old image: ", journal.Image)
		if journal.Image != "" && journal.Image != newFileName {
			oldImagePath := filepath.Join("frontend/assets", journal.Image)
			if err := os.Remove(oldImagePath); err != nil {
				c.Logger().Error("Failed to delete old image: ", err)
			}
		}
		journal.Image = newFileName
		c.Logger().Info("Switching to new image: ", newFileName)
	}

	verrs, err := tx.Eager().ValidateAndUpdate(journal)
	if err != nil {
		return c.Render(500, r.JSON(map[string]string{"error": "Error saving journal"}))
	}

	if verrs.HasAny() {
		c.Set("journal", journal)
		c.Set("errors", verrs)
		return c.Render(422, r.JSON(verrs))
	}
	c.Logger().Info("Journal updated successfully")
	return c.Render(200, r.JSON(journal))
}

func JournalsDelete (c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection) 
	journalId := c.Param("id") 

	journal := models.Journal{}
	if err := tx.Find(&journal, journalId); err != nil {
		c.Logger().Errorf("Error finding Journal with id %s, error: %v", journalId, err)
		return c.Render(404, r.JSON(map[string]string{"error": "Journal not found"}))
	}
	
    	imagePath := filepath.Join("frontend/assets", journal.Image)

    	if err := os.Remove(imagePath); err != nil {
        	c.Logger().Errorf("Error deleting image file %s, error: %v", imagePath, err)
    	}

	if err := tx.Destroy(&journal); err != nil {
		c.Logger().Errorf("Error deleting Journal with id %s, error: %v", journalId, err)
		return c.Render(500, r.JSON(map[string]string{"error": "Error deleting Journal"}))
	}

	c.Flash().Add("success", "Journal successfully deleted")
	return c.Render(200, r.JSON(map[string]string{"success": "Journal successfully deleted"}))

}

// Delete journals as part of parent delete
func DeleteJournalById(tx *pop.Connection, journalID uuid.UUID) error {
    journal := &models.Journal{}
    if err := tx.Find(journal, journalID); err != nil {
        return err
    }

    if journal.Image != "" {
        imagePath := filepath.Join("frontend/assets", journal.Image)
        if err := os.Remove(imagePath); err != nil {
            log.Printf("Warning: Error deleting image file %s, error: %v", imagePath, err)
        }
	}    
    return tx.Destroy(journal)
}

