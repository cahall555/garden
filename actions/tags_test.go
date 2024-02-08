package actions

import (
	"fmt"
	"garden/models"
)

func (as *ActionSuite) Test_Tags_Show() {
	as.LoadFixture("model test")

	tag := models.Tag{}
	err := as.DB.First(&tag)

	if err != nil {
		panic(err)
	}

	res := as.HTML(fmt.Sprintf("/tags/%s", tag.ID)).Get()
	body := res.Body.String()
	as.Contains(body, "Annual", "Tag name not found on page")
	as.Contains(body, "Tomato", "Plant name not found on page")
	

}

