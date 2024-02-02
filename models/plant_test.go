package models

import (
	"github.com/gofrs/uuid"
)

func (ms *ModelSuite) Test_Plant() {
	g := &Garden{
		Name: "Salsa Garden",
		Zone: "13",
	}

	db := ms.DB
	verrs, err := db.ValidateAndCreate(g)
	if err != nil {
		panic(err)
	}

	p := &Plant{
		Name:          "Tomato",
		Germinated:    true,
		DaysToHarvest: 90,
		GardenID:      g.ID,
	}

	p2 := &Plant{
		Name:          "Spinach",
		Germinated:    false,
		DaysToHarvest: 45,
		GardenID:      g.ID,
	}

	g.Plants = append(g.Plants, *p)
	g.Plants = append(g.Plants, *p2)

	ms.Equal(p.PlantName(), "Tomato")

	verrs, err = db.ValidateAndCreate(p)
	if err != nil {
		panic(err)
	}

	verrs, err = db.ValidateAndCreate(p2)
	if err != nil {
		panic(err)
	}

	ms.Equal(g.Plants[1].PlantName(), "Spinach")
	ms.Equal(g.ID, p.GardenID, "Plant's GardenID should match the Garden's ID")
	ms.Equal(g.ID, p2.GardenID, "Plant's GardenID should match the Garden's ID")

	ms.NotEqual(uuid.Nil, p.ID, "Plant id is generated when saved to database")
	ms.NotEqual(uuid.Nil, p2.ID, "Plant id is generated when saved to database")
	ms.False(verrs.HasAny(), "All fields must be completed")
}
