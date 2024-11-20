package actions

import (
	"fmt"

	"github.com/gobuffalo/buffalo"
)

func CsrfToken(c buffalo.Context) error {
	csrfToken, ok := c.Value("authenticity_token").(string)
	if !ok {
		return fmt.Errorf("expected CSRF token got %T", c.Value("authenticity_token"))
	}

	c.Logger().Info("csrfToken: ", csrfToken)
	return c.Render(200, r.JSON(map[string]string{"csrf_token": csrfToken}))
}
