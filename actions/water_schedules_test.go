package actions

import (
	"fmt"
	"garden/models"
)

func (as *ActionSuite) Test_WaterSchedules_Show() {
	as.LoadFixture("model test")
	ws := models.WaterSchedule{}

	err := as.DB.First(&ws)
	if err != nil {
		panic(err)
	}

	res := as.HTML(fmt.Sprintf("/water_schedules/%s", ws.ID)).Get()
	body := res.Body.String()
	as.Contains(body, "Water every other day", "The word drip not found on page")

}
