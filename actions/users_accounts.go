package actions

import (
	"garden/models"
	"net/http"
	"github.com/pkg/errors"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop/v6"
)

func UserAccountsIndex(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	ua := models.UsersAccounts{}

	err := tx.All(&ua)
	if err != nil {
		c.Flash().Add("warning", "User Accounts not found")
		c.Redirect(301, "/")
	}

	c.Set("ua", ua)
	return c.Render(http.StatusOK, r.JSON(ua))//r.HTML("accounts/index.html"))
}

func UsersAccountShow(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	ua := models.UsersAccount{}
	userID := c.Param("user_id")
	c.Logger().Info("***************UsersAccountShow: ", userID)

	err := tx.Where("user_id = ?", userID).First(&ua)
	if err != nil {
		c.Logger().Info("***************UsersAccountShow: User Account not found")
		c.Render(http.StatusNotFound, r.JSON("User Account not found"))
	}

	c.Set("ua", ua)
	return c.Render(http.StatusOK, r.JSON(ua))
}

func UsersAccountCreate(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	ua := &models.UsersAccount{}
	err := c.Bind(ua)
	if err != nil {
		c.Logger().Errorf("Error binding Users Account form: %v", err)
		return c.Redirect(301, "/")
	}

	verrs, err := tx.ValidateAndCreate(ua)
	if err != nil {
		c.Logger().Errorf("Error validating User Account: %v", err)
		return c.Redirect(301, "/")
	}

	if verrs.HasAny() {
		c.Set("errors", verrs)
		return c.Render(http.StatusUnprocessableEntity, r.JSON(ua))
	}

	return c.Render(201, r.JSON(ua))
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
