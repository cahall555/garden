package actions

import (
	"garden/models"
	"net/http"
	"github.com/gobuffalo/pop/v6"
	"github.com/gobuffalo/buffalo"
)

// JournalsShow default implementation.
func JournalsShow(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	journal := models.Journal{}
	JournalID := c.Param("id")

	err := tx.Find(&journal, JournalID)
	if err != nil {
		c.Flash().Add("warning", "Journal not found")
		c.Redirect(301, "/")
	}

	c.Set("journal", journal)
	return c.Render(http.StatusOK, r.HTML("journals/show.html"))
}

// JournalsIndex default implementation.
func JournalsIndex(c buffalo.Context) error {
	tx := c.Value("tx").(*pop.Connection)
	journal := models.Journals{}

	err := tx.All(&journal)
	if err != nil {
		c.Flash().Add("warning", "Journals not found")
		c.Redirect(301, "/")
	}

	c.Set("journal", journal)
	return c.Render(http.StatusOK, r.HTML("journals/index.html"))
}
