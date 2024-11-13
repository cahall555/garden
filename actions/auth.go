package actions

import (
	"garden/models"
	"database/sql"
	"net/http"
	"strings"
	"log"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop/v6"
	"github.com/gobuffalo/validate"
	"github.com/pkg/errors"
	"golang.org/x/crypto/bcrypt"
)

//AuthCreate attempts to log the user in with an existing account
func AuthCreate(c buffalo.Context) error {
	c.Logger().Info("***************AuthCreate start *************** ")
	tx, ok := c.Value("tx").(*pop.Connection)
	if !ok {
		return c.Error(500, errors.New("no transaction found"))
	}

	u := &models.User{}
	if err := c.Bind(u); err != nil {
		return err
	}

	err := c.Request().ParseForm()
	if err != nil {
		return err
	}

	log.Println("***************AuthCreate: ", u.Email, u.Password)
	
	err = tx.Where("email = ?", strings.ToLower(strings.TrimSpace(u.Email))).First(u)

	bad := func() error {
		verrs := validate.NewErrors()
		verrs.Add("email", "invalid entry") 

		c.Set("errors", verrs)
		c.Set("user", u)
		c.Logger().Info("***************AuthCreate: bad attempt", verrs.Errors)
		return c.Render(http.StatusUnauthorized, r.JSON(u))
	}

	if err != nil {
		if errors.Cause(err) == sql.ErrNoRows {
			c.Logger().Info("***************AuthCreate: could not find email address: ", err)
			return bad()
		}
		return err
	}


	err = bcrypt.CompareHashAndPassword([]byte(u.PasswordHash), []byte(u.Password))
	if err != nil {
		c.Logger().Info("***************AuthCreate: bad password", err)
		return bad()
	}
	c.Session().Set("current_user_id", u.ID)

	return c.Render(200, r.JSON(u))
}

// AuthDestroy clears the session and logs a user out
func AuthDelete(c buffalo.Context) error {
	c.Session().Clear()
	return c.Render(http.StatusOK, r.JSON("Logged out successfully"))
}
