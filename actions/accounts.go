package actions

import (
	"garden/models"
	"net/http"
	"github.com/pkg/errors"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop/v6"
)

func AccountsShow(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	account := models.Account{}
	accountID := c.Param("id")

	err := tx.Eager().Find(&account, accountID)
	if err != nil {
		c.Flash().Add("warning", "Account not found")
		c.Redirect(301, "/")
	}

	c.Set("account", account)
	return c.Render(http.StatusOK, r.JSON(account))//r.HTML("accounts/show.html"))
}

func AccountsIndex(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	account := models.Accounts{}

	err := tx.All(&account)
	if err != nil {
		c.Flash().Add("warning", "Accounts not found")
		c.Redirect(301, "/")
	}

	c.Set("account", account)
	return c.Render(http.StatusOK, r.JSON(account))//r.HTML("accounts/index.html"))
}

func AccountsCreate(c buffalo.Context) error {
	account := models.Account{}
	c.Set("account", account)
	
	tx := c.Value("tx").(*pop.Connection)
	accounts := &models.Accounts{}
	err := tx.All(accounts)
	if err != nil {
		return err//c.Redirect(302, "/")
	}
	return c.Render(http.StatusOK, r.JSON(account))
}

func AccountsNew(c buffalo.Context) error {
	account := models.Account{}
	c.Set("account", account)
	return c.Render(http.StatusOK, r.JSON(account))
}

func AccountsUpdate(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	account := models.Account{}
	accountID := c.Param("id")

	if err := tx.Find(&account, accountID); err != nil {
		return c.Error(404, err)
	}

	if err := c.Bind(account); err != nil {
		return errors.WithStack(err)
	}

	verrs, err := tx.ValidateAndUpdate(&account)
	if err != nil {
		return errors.WithStack(err)
	}

	if verrs.HasAny() {
		c.Set("account", account)
		c.Set("errors", verrs.Errors)
		return c.Render(422, r.JSON(account))
	}

	return c.Render(http.StatusOK, r.JSON(account))
}

func AccountsEdit(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	account := models.Account{}
	if err := tx.Find(&account, c.Param("id")); err != nil {
		return c.Render(500, r.JSON(account))
	}
	
	err := c.Bind(account)
	if err != nil {
		return c.Render(500, r.JSON(account))
	}

	err = c.Request().ParseForm()
	if err != nil {
		return c.Render(500, r.JSON(account))
	}

	verrs, err := tx.ValidateAndUpdate(account)
	if err != nil {
		return c.Render(500, r.JSON(account))
	}

	if verrs.HasAny() {
		c.Set("account", account)
		c.Set("errors", verrs)
		return c.Render(422, r.JSON(verrs))
	}
	return c.Render(200, r.JSON(account))
}

func AccountsDelete(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	account := models.Account{}
	accountID := c.Param("id")

	if err := tx.Find(&account, accountID); err != nil {
		return c.Error(404, err)
	}

	if err := tx.Destroy(&account); err != nil {
		return errors.WithStack(err)
	}

	return c.Render(http.StatusOK, r.JSON(account))
}
