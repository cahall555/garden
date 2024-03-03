package actions

import (
	"garden/models"
	"net/http"
	"fmt"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop/v6"
)

// TagsShow default implementation.
func TagsShow(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	tag := models.Tag{}
	tagID := c.Param("id")

	err := tx.Eager().Find(&tag, tagID)
	if err != nil {
		c.Flash().Add("warning", "Tag not found")
		c.Redirect(301, "/")
	}

	c.Set("tag", tag)
	return c.Render(http.StatusOK, r.HTML("tags/show.html"))
}

func TagsIndex(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	tag := models.Tags{}

	err := tx.All(&tag)
	if err != nil {
		c.Flash().Add("warning", "Tags not found")
		c.Redirect(301, "/")
	}

	c.Set("tag", tag)
	return c.Render(http.StatusOK, r.HTML("tags/index.html"))
}

func TagsCreate(c buffalo.Context) error {
	tag := models.Tag{}
	c.Set("tag", tag)
	return c.Render(http.StatusOK, r.HTML("tags/create.html"))
}

// GardensNew default implementation.
func TagsNew(c buffalo.Context) error {
	tx :=c.Value("tx").(*pop.Connection)
	tag := &models.Tag{}
	err := c.Bind(tag)
	if err != nil {
		c.Flash().Add("warning", "Tag form binding error")
		return c.Redirect(301, "/")
	}
	
	verrs, err := tx.ValidateAndCreate(tag)
	if err != nil {
		return c.Redirect(301, "/")
	}

	if verrs.HasAny() {
		c.Flash().Add("warning", "Tag validation error")
		c.Set("tag", tag)
		c.Set("errors", verrs)
		return c.Render(422, r.HTML("tags/create.html"))
	}

	c.Flash().Add("success", "Tag created")
	return c.Redirect(301, fmt.Sprintf("/tags/%s", tag.ID))
}

func TagsUpdate(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	tag := models.Tag{}
	tagID := c.Param("id")
	c.Logger().Info("Tag id: ", tagID)

	err := tx.Eager().Find(&tag, tagID)
	if err != nil {
		c.Flash().Add("warning", "Tag not found")
		c.Redirect(301, "/")
		c.Logger().Error("Tag not found: ", err)
	}
	c.Set("tag", tag)
	return c.Render(http.StatusOK, r.HTML("tags/update.html"))
}

func TagsEdit(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	tag := &models.Tag{}
	if err := tx.Find(tag, c.Param("tagId")); err != nil {
		return err
	}
	
	err := c.Bind(tag)
	if err != nil {
		c.Flash().Add("warning", "Tag form binding error")
		return c.Redirect(301, "/")
	}

	verrs, err := tx.ValidateAndUpdate(tag)
	if err != nil {
		c.Logger().Error("Tag update error: ", err)
		return c.Redirect(301, "/")
	}

	if verrs.HasAny() {
		c.Flash().Add("warning", "Tag validation error")
		c.Set("tag", tag)
		c.Set("errors", verrs)
		c.Logger().Error("Validation errors: ", verrs)
		return c.Render(422, r.HTML("tag/update.html"))
	}

	c.Flash().Add("success", "Tag updated")
	return c.Redirect(301, fmt.Sprintf("/tags/%s", tag.ID))
}
func TagsDelete(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection) 
	tagId := c.Param("id") 

	tag := models.Tag{}
	if err := tx.Find(&tag, tagId); err != nil {
		c.Logger().Errorf("Error finding Tag with id %s, error: %v", tagId, err)
		c.Flash().Add("error", "Water Schedule not found")
		return c.Redirect(http.StatusFound, "/tags/")
	}
	

	if err := tx.Destroy(&tag); err != nil {
		c.Logger().Errorf("Error deleting Tag with id %s, error: %v", tagId, err)
		c.Flash().Add("error", "Error deleting Tag")
		return c.Redirect(http.StatusFound, "/")
	}

	c.Flash().Add("success", "Tag successfully deleted")
	return c.Redirect(http.StatusFound, "/")
}
