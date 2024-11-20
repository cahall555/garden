package actions

import (
	"garden/models"

	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/pop/v6"
	"github.com/pkg/errors"
)

// UsersNew renders the users form
func UsersNew(c buffalo.Context) error {
	u := &models.User{}
	c.Set("user", u)
	return c.Render(200, r.JSON(u))
}

// UsersCreate registers a new user with the application
func UsersCreate(c buffalo.Context) error {
	u := &models.User{}
	if err := c.Bind(u); err != nil {
		return errors.WithStack(err)
	}

	tx := c.Value("tx").(*pop.Connection)
	verrs, err := u.Create(tx)
	if err != nil {
		return errors.WithStack(err)
	}

	if verrs.HasAny() {
		c.Set("user", u)
		c.Set("errors", verrs.Errors)
		return c.Render(422, r.JSON(u))
	}

	c.Session().Set("current_user_id", u.ID)

	return c.Render(201, r.JSON(u))
}

// SetCurrentUser attempts to find a user based on the current_user_id
// in the session. If the user is found it is set on the current context.
func SetCurrentUser(next buffalo.Handler) buffalo.Handler {
	return func(c buffalo.Context) error {
		if uid := c.Session().Get("current_user_id"); uid != nil {
			u := &models.User{}
			tx := c.Value("tx").(*pop.Connection)
			if err := tx.Find(u, uid); err != nil {
				return errors.WithStack(err)
			}
			c.Set("current_user", u)
		}
		return next(c)
	}
}

// Authorize require a user be logged in before accessing route
func Authorize(next buffalo.Handler) buffalo.Handler {
	return func(c buffalo.Context) error {
		if uid := c.Session().Get("current_user_id"); uid == nil {
			c.Session().Set("redirect", c.Request().URL.String())

			err := c.Session().Save()
			if err != nil {
				return errors.WithStack(err)
			}

			return c.Redirect(302, "/signin")
		}
		return next(c)
	}
}
