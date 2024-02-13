package actions

import (
	"fmt"
	"garden/models"
)

func (as *ActionSuite) Test_Journals_Show() {
	as.LoadFixture("model test")

	journal := models.Journal{}

	err := as.DB.First(&journal)
	if err != nil {
		panic(err)
	}

	res := as.HTML(fmt.Sprintf("/journals/%s", journal.ID)).Get()
	body := res.Body.String()
	as.Contains(body, "Observations", "The word observations not found on page")

}
