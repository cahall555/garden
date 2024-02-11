package models

import (
	"github.com/gofrs/uuid"
)

func (ms *ModelSuite) Test_Journal() {
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

	j := &Journal{
		Title:   "First Planting",
		Entry:   "Planted 4 seeds in the ground",
		DisplayOnGarden: false,
		Category: "Planting",
		PlantID: p.ID,
	}

	p.Journals = append(p.Journals, *j)

	verrs, err = db.ValidateAndCreate(j)
	if err != nil {
		panic(err)
	}

	ms.Equal(j.Category.CatStr(), "Planting")

	ms.Equal(p.Journals[0].Title, "First Planting")
	ms.Equal(p.ID, j.PlantID, "Journals's PlantID should match the plant's ID")

	ms.NotEqual(uuid.Nil, j.ID, "Journal id is generated when saved to database")
	ms.False(verrs.HasAny(), "All fields must be completed")

}
