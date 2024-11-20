package models

import (
	"github.com/gofrs/uuid"
)

func (ms *ModelSuite) Test_WaterSchedule() {
	g := &Garden{
		Name: "Herb Garden",
		Zone: "5",
	}

	db := ms.DB
	verrs, err := db.ValidateAndCreate(g)
	if err != nil {
		panic(err)
	}

	p := &Plant{
		Name:          "Cilantro",
		Germinated:    true,
		DaysToHarvest: 30,
		GardenID:      g.ID,
	}

	g.Plants = append(g.Plants, *p)

	verrs, err = db.ValidateAndCreate(p)
	if err != nil {
		panic(err)
	}

	ws := &WaterSchedule{
		Monday:    true,
		Tuesday:   false,
		Wednesday: true,
		Thursday:  false,
		Friday:    true,
		Saturday:  false,
		Sunday:    true,
		Method:    "Drip",
		Notes:     "Water every day",
		PlantID:   p.ID,
	}

	verrs, err = db.ValidateAndCreate(ws)
	if err != nil {
		panic(err)
	}

	ms.Equal(ws.Method.MethodStr(), "Drip")

	ms.Equal(ws.Wednesday, true)
	ms.Equal(p.ID, ws.PlantID, "Water schedules PlantID should match the plant's ID")

	ms.NotEqual(uuid.Nil, ws.ID, "Water schedule id is generated when saved to database")
	ms.False(verrs.HasAny(), "All fields must be completed")

}
