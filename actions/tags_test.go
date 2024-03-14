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

func (as *ActionSuite) Test_Tags_Create() {
	tag := &models.Tag{Name: "Spicy"}
	
	res := as.HTML("/tags").Post(tag)
    	as.Equal(301, res.Code)
    	err := as.DB.First(tag)
    	as.NoError(err)
    	as.NotZero(tag.ID)

	as.Equal(fmt.Sprintf("/tags/%s", tag.ID), res.Location())

	as.NotZero(tag.CreatedAt)
    	as.Equal("Spicy", tag.Name)
}

func (as *ActionSuite) Test_Tags_Delete() {
	as.LoadFixture("model test")

	tag := models.Tag{}
	err := as.DB.First(&tag)

	if err != nil {
		panic(err)
	}

	res := as.HTML(fmt.Sprintf("/tags/%s", tag.ID)).Delete()

	as.Equal(302, res.Code)

}
