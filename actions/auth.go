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

// AuthLanding shows a landing page to login or sign up
func AuthLanding(c buffalo.Context) error {
	return c.Render(200, r.JSON("auth landing successful"))//r.HTML("auth/landing.html"))
}

//AuthNew loads the sign in page
func AuthNew(c buffalo.Context) error {
	c.Set("user", &models.User{})
	return c.Render(200, r.JSON("auth new successful"))//r.HTML("auth/new.html"))
}

//AuthCreate attempts to log the user in with an existing account
func AuthCreate(c buffalo.Context) error {
	log.Println("***************AuthCreate start *************** ")
	u := &models.User{}
	if err := c.Bind(u); err != nil {
		return err
	}
	tx := c.Value("tx").(*pop.Connection)
	log.Println("***************AuthCreate: ", u.Email, u.Password)
	// find a user with the email
	err := tx.Where("email = ?", strings.ToLower(strings.TrimSpace(u.Email))).First(u)

	// helper function to handle bad attempts
	bad := func() error {
		verrs := validate.NewErrors()
		verrs.Add("email", "invalid email/password") //TODO: change this message when done testing.

		c.Set("errors", verrs)
		c.Set("user", u)

		return c.Render(http.StatusUnauthorized, r.JSON(u))//HTML("auth/new.plush.html"))
	}

	if err != nil {
		if errors.Cause(err) == sql.ErrNoRows {
			// couldn't find an user with the supplied email address.
			return bad()
		}
		return err
	}

	// confirm that the given password matches the hashed password from the db
	err = bcrypt.CompareHashAndPassword([]byte(u.PasswordHash), []byte(u.Password))
	if err != nil {
		return bad()
	}
	c.Session().Set("current_user_id", u.ID)
	c.Flash().Add("success", "Welcome Back to Buffalo!")

	return c.Render(200, r.JSON(u))//c.Redirect(302, redirectURL)
}

// AuthDestroy clears the session and logs a user out
func AuthDelete(c buffalo.Context) error {
	c.Session().Clear()
	c.Flash().Add("success", "You have been logged out!")
	return c.Redirect(302, "/")
}
