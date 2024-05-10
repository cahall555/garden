package actions

import (
	"garden/models"
	"net/http"
	"github.com/gofrs/uuid"
	"github.com/pkg/errors"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop/v6"
)

func UsersAccountIndex(c buffalo.Context) error {
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

func UsersAccountCreate(c buffalo.Context) error {
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

func UsersAccountDelete(c buffalo.Context) error {
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
