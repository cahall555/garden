package actions

import (
	"fmt"
	"garden/models"
)

func (as *ActionSuite) Test_Gardens_Show() {
	as.LoadFixture("model test")

	garden := models.Garden{}
	err := as.DB.First(&garden)
	if err != nil {
		panic(err)
	}

	res := as.HTML(fmt.Sprintf("/gardens/%s", garden.ID)).Get()
	body := res.Body.String()
	as.Contains(body, "Salsa Garden", "Garden name not found on page")
	as.Contains(body, "13", "Garden zone not found on page")
	as.Contains(body, "Tomato", "Plant name not found on page")
	as.Contains(body, "Jalapeno", "Plant name not found on page")
}
