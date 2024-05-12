package actions

import (
	"garden/models"
	"net/http"
	"github.com/pkg/errors"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop/v6"
)

func FarmsShow(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	farm := models.Farm{}
	farmID := c.Param("id")

	err := tx.Eager().Find(&farm, farmID)
	if err != nil {
		c.Flash().Add("warning", "Farm not found")
		c.Redirect(301, "/")
	}

	c.Set("farm", farm)
	return c.Render(http.StatusOK, r.JSON(farm))//r.HTML("farms/show.html"))
}

func FarmsIndex(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	farm := models.Farms{}

	err := tx.All(&farm)
	if err != nil {
		c.Flash().Add("warning", "Farms not found")
		c.Redirect(301, "/")
	}

	c.Set("farm", farm)
	return c.Render(http.StatusOK, r.JSON(farm))//r.HTML("farms/index.html"))
}

func FarmsCreate(c buffalo.Context) error {
	farm := models.Farm{}
	c.Set("farm", farm)
	
	tx := c.Value("tx").(*pop.Connection)
	farms := &models.Farms{}
	err := tx.All(farms)
	if err != nil {
		return err//c.Redirect(302, "/")
	}
	return c.Render(http.StatusOK, r.JSON(farm))
}

func FarmsNew(c buffalo.Context) error {
	farm := models.Farm{}
	c.Set("farm", farm)
	return c.Render(http.StatusOK, r.JSON(farm))
}

func FarmsUpdate(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	farm := models.Farm{}
	farmID := c.Param("id")
	err := tx.Find(&farm, farmID)
	if err != nil {
		return errors.WithStack(err)
	}
	err = c.Bind(&farm)
	if err != nil {
		return errors.WithStack(err)
	}
	verrs, err := tx.ValidateAndUpdate(&farm)
	if err != nil {
		return errors.WithStack(err)
	}
	if verrs.HasAny() {
		c.Set("farm", farm)
		c.Set("errors", verrs)
		return c.Render(http.StatusUnprocessableEntity, r.JSON(farm))
	}
	return c.Render(http.StatusOK, r.JSON(farm))
}

func FarmsEdit(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	farm := models.Farm{}
	err := tx.Find(&farm, c.Param("id"))
	if err != nil {
		return errors.WithStack(err)
	}
	return c.Render(http.StatusOK, r.JSON(farm))
}

func FarmsDelete(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	farm := models.Farm{}
	err := tx.Find(&farm, c.Param("id"))
	if err != nil {
		return errors.WithStack(err)
	}
	err = tx.Destroy(&farm)
	if err != nil {
		return errors.WithStack(err)
	}
	return c.Render(http.StatusOK, r.JSON(farm))
}

