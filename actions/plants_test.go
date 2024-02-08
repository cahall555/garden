package actions

import (
	"fmt"
	"garden/models"
)

func (as *ActionSuite) Test_Plants_Show() {
	as.LoadFixture("model test")
	
	plant := models.Plant{}
	err := as.DB.First(&plant)
	if err != nil {
		panic(err)
	}

	res := as.HTML(fmt.Sprintf("/plants/%s", plant.ID)).Get()
	body := res.Body.String()
	as.Contains(body, "Tomato", "Plant name not found on page")
	as.Contains(body, "Annual", "Tag name not found on page")
	as.Contains(body, "Vegetable", "Tag name not found on page")
	
}

