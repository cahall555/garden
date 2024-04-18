package actions

import (
	"garden/models"
	"net/http"
	"fmt"
	"os"
	"io"
	"log"
	"path/filepath"
	"github.com/gofrs/uuid"
	"github.com/microcosm-cc/bluemonday"
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
//		c.Flash().Add("warning", "Journal not found")
		c.Redirect(301, "/")
	}

	c.Set("journal", journal)
	return c.Render(http.StatusOK, r.JSON(journal))//r.HTML("journals/show.html"))
}

// JournalsIndex default implementation.
func JournalsIndex(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	journal := models.Journals{}

	err := tx.All(&journal)
	if err != nil {
//		c.Flash().Add("warning", "Journals not found")
		c.Redirect(301, "/")
	}

	c.Set("journal", journal)
	return c.Render(http.StatusOK, r.JSON(journal))//r.HTML("journals/index.html"))
}

// JournalsIndex default implementation filtering by plant.
func PlantJournals(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	journal := models.Journals{}
	plantID := c.Param("plant_id")

	err := tx.Where("plant_id = ?", plantID).All(&journal)
	if err != nil {
	//	c.Flash().Add("warning", "Journals not found")
		c.Redirect(301, "/")
	}

	c.Set("journal", journal)
	return c.Render(http.StatusOK, r.JSON(journal))//r.HTML("journals/index.html"))
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
	c.Logger().Error("plantId: ", plantId)
	c.Logger().WithField("Plants", plants).Info("Plants found.")

	return c.Render(http.StatusOK, r.JSON(journal))//r.HTML("journals/create.html"))
}
func JournalsNew(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	journal := &models.Journal{}

	// This line ensures multipart data is processed correctly
	if err := c.Request().ParseMultipartForm(10 << 20); err != nil { // 10 MB
		c.Logger().Error("Failed to parse multipart form: ", err)
		return c.Error(400, err)
	}

	// Assigning form values to journal fields
	journal.Title = c.Request().FormValue("title")
	journal.Entry = c.Request().FormValue("entry")
	journal.Category = models.Category(c.Request().FormValue("category"))
	journal.PlantID = uuid.FromStringOrNil(c.Request().FormValue("plant_id"))
	journal.DisplayOnGarden = c.Request().FormValue("display_in_garden") == "true"

	// Handling file upload
	file, header, err := c.Request().FormFile("_imagePath")
	if err == http.ErrMissingFile {
		c.Logger().Info("No file uploaded, skipping image logic.")
	} else if err != nil {
		c.Logger().Error("Error getting uploaded file: ", err)
		return c.Render(400, r.JSON(map[string]string{"error": "Error processing uploaded file"}))
	} else {
		defer file.Close()
		newFileName := uuid.Must(uuid.NewV4()).String() + filepath.Ext(header.Filename)
		savePath := filepath.Join("public/uploads", newFileName)

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

	// Validate and create the journal record
	verrs, err := tx.Eager().ValidateAndCreate(journal)
	if err != nil {
		c.Logger().Error("Journal creation failed: ", err)
		return c.Error(500, err)
	}

	if verrs.HasAny() {
		c.Set("journal", journal)
		c.Set("errors", verrs)
		return c.Render(422, r.JSON(verrs))
	}

	return c.Render(201, r.JSON(journal))
}

//func JournalsNew(c buffalo.Context) error {
//	tx := c.Value("tx").(*pop.Connection)
//	journal := &models.Journal{}
//	err := c.Bind(journal)
//	if err != nil {
//		c.Flash().Add("warning", "Journal form binding error")
//		return c.Redirect(301, "/")
//	}

//	err = c.Request().ParseForm()
//	if err != nil {
//		c.Flash().Add("error", "Journal form parsing error")
//		return c.Redirect(301, "/")
//	}

//	pj := c.Param("plantId") //c.Request().FormValue("Plant")
//	plant := &models.Plant{}
//	err = tx.Find(plant, pj)
//	if err != nil {
//		c.Logger().Error("Plant not found")
	//	c.Flash().Add("warning", "Plant not found")
//		return c.Redirect(301, "/")
//	}

//	journal.PlantID = plant.ID

//	plant.Journals = append(plant.Journals, *journal)
//
	//rawEntry := c.Request().FormValue("Entry")
	//cleanEntry := bluemonday.StrictPolicy().Sanitize(rawEntry)
	//journal.Entry = cleanEntry

//	file, header, err := c.Request().FormFile("_imagePath")
//	if err == http.ErrMissingFile {
//		c.Logger().Error("No file uploaded, skipping image logic.")

//	} else if err != nil {
//		c.Logger().Error("Error getting uploaded file")
//		return c.Render(400, r.JSON(map[string]string{"error": "Error processing uploaded file"}))
//	} else {
//		defer file.Close()

//		newFileName := uuid.Must(uuid.NewV4()).String() + filepath.Ext(header.Filename)

//		savePath := filepath.Join("public/uploads", newFileName)

//		outFile, err := os.Create(savePath)
//		if err != nil {
//			c.Logger().Error("Outfile error, save path variable error: ", err, " outfile: ", outFile)
//			c.Logger().Error("Error creating file on server")
//			return c.Render(500, r.JSON(map[string]string{"error": "Error saving file on server"}))
//		}
//		defer outFile.Close()

//		if _, err = io.Copy(outFile, file); err != nil {
//			c.Logger().Error("Error copying file")
//			c.Logger().Error("Error saving file on server")
//			return c.Render(500, r.JSON(map[string]string{"error": "Error saving file on server"}))
//		}

//		journal.Image = newFileName
//	}

//	verrs, err := tx.Eager().ValidateAndCreate(journal)
//	if err != nil {
//		c.Logger().Error("Journal error, issue with validation and creation")
//		return c.Redirect(301, "/")
//	}

//	if verrs.HasAny() {
//		c.Flash().Add("warning", "Journal validation error")
//		c.Set("journal", journal)
//		c.Set("errors", verrs)
//		return c.Render(422, r.JSON(verrs))//r.HTML("journals/create.html"))
//	}
	

	//c.Flash().Add("success", "Journal created")
//	return c.Render(301, r.JSON(journal))//fmt.Sprintf("/journals/%s", journal.ID))
//}

func JournalsUpdate(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	journal := models.Journal{}
	journalID := c.Param("id")
	c.Logger().Info("Journal id: ", journalID)

	err := tx.Eager().Find(&journal, journalID)
	if err != nil {
		c.Logger().Error("Journal not found, id: ", journalID)
		c.Flash().Add("warning", "Journal not found")
		c.Redirect(301, "/")
	}

	c.Set("journal", journal)

	plants := &models.Plants{}
	err = tx.All(plants)
	if err != nil {
		c.Logger().Error("Plants not found")
		return c.Redirect(302, "/")
	}
	
	plantId := journal.PlantID
	c.Set("plantId", plantId)
	c.Set("plants", plants)

	return c.Render(http.StatusOK, r.HTML("journals/update.html"))

}

func JournalsEdit(c buffalo.Context) error {
	tx :=c.Value("tx").(*pop.Connection)
	journal := &models.Journal{}
	if err := tx.Find(journal, c.Param("journalId")); err != nil {
		return err
	}
	
	originalImageName := journal.Image
	c.Logger().Info("Original image name: ", originalImageName)

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

	pws := c.Request().FormValue("Plant")
	plant := &models.Plant{}
	err = tx.Find(plant, pws)
	if err != nil {
		c.Logger().Error("Plant not found")
		c.Flash().Add("warning", "Plant not found")
		return c.Redirect(301, "/")
	}


	rawEntry := c.Request().FormValue("Entry")
	cleanEntry := bluemonday.StrictPolicy().Sanitize(rawEntry)
	journal.Entry = cleanEntry


	file, header, err := c.Request().FormFile("Image")
	c.Logger().Info("This is file: ", file)
	c.Logger().Info("This is header: ", header)
	c.Logger().Info("This is err: ", err)
	if err == http.ErrMissingFile {
		c.Logger().Info("No new file uploaded, preserving existing image if exists.")
		journal.Image = originalImageName

	} else if err != nil {
		c.Logger().Error("Error getting uploaded file")
		return c.Render(400, r.JSON(map[string]string{"error": "Error processing uploaded file"}))
	} else {
		defer file.Close()

		newFileName := uuid.Must(uuid.NewV4()).String() + filepath.Ext(header.Filename)
		savePath := filepath.Join("public/uploads", newFileName)
			
		outFile, err := os.Create(savePath)
		if err != nil {
			c.Logger().Error("Outfile error, save path variable error: ", err, " outfile: ", outFile)
			c.Logger().Error("Error creating file on server")
			return c.Render(500, r.JSON(map[string]string{"error": "Error saving file on server"}))
		}
		
		defer outFile.Close()
		
		if _, err = io.Copy(outFile, file); err != nil {
			c.Logger().Error("Error copying file")
			c.Logger().Error("Error saving file on server")
			return c.Render(500, r.JSON(map[string]string{"error": "Error saving file on server"}))
		}

		if journal.Image != "" && journal.Image != newFileName {
    			oldImagePath := filepath.Join("public/uploads", journal.Image)
    			if err := os.Remove(oldImagePath); err != nil {
             			c.Logger().Error("Failed to delete old image: ", err)
            		}
        	}

		journal.Image = newFileName 
		c.Logger().Info("switching to new image: ", newFileName)
	}

	verrs, err := tx.Eager().ValidateAndUpdate(journal)
	if err != nil {
		return c.Redirect(301, "/")
	}

	if verrs.HasAny() {
		c.Flash().Add("warning", "Journal validation error")
		c.Set("journal", journal)
		c.Set("errors", verrs)
		return c.Render(422, r.HTML("journals/update.html"))
	}

	c.Flash().Add("success", "Journal updated")
	return c.Redirect(301, fmt.Sprintf("/journals/%s", journal.ID))

}

func JournalsDelete (c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection) 
	journalId := c.Param("id") 

	journal := models.Journal{}
	if err := tx.Find(&journal, journalId); err != nil {
		c.Logger().Errorf("Error finding Journal with id %s, error: %v", journalId, err)
		c.Flash().Add("error", "Journal not found")
		return c.Redirect(http.StatusFound, "/journals/")
	}
	
    	imagePath := filepath.Join("public/uploads", journal.Image)

    	if err := os.Remove(imagePath); err != nil {
        	c.Logger().Errorf("Error deleting image file %s, error: %v", imagePath, err)
    	}

	if err := tx.Destroy(&journal); err != nil {
		c.Logger().Errorf("Error deleting Journal with id %s, error: %v", journalId, err)
		c.Flash().Add("error", "Error deleting Journal")
		return c.Redirect(http.StatusFound, "/")
	}

	c.Flash().Add("success", "Journal successfully deleted")
	return c.Redirect(http.StatusFound, "/")

}

// Delete journals as part of parent delete
func DeleteJournalById(tx *pop.Connection, journalID uuid.UUID) error {
    journal := &models.Journal{}
    if err := tx.Find(journal, journalID); err != nil {
        return err
    }

    if journal.Image != "" {
        imagePath := filepath.Join("public/uploads", journal.Image)
        if err := os.Remove(imagePath); err != nil {
            log.Printf("Warning: Error deleting image file %s, error: %v", imagePath, err)
        }
	}    
    return tx.Destroy(journal)
}

