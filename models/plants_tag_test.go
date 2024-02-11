package models

import (
	"github.com/gofrs/uuid"
)

func (ms *ModelSuite) Test_PlantsTag() {
	g := &Garden{
		Name: "Salsa Garden",
		Zone: "13",
	}

	db := ms.DB
	_, err := db.ValidateAndCreate(g)
	if err != nil {
		panic(err)
	}

	ms.NotNil(g.ID, "Garden id is generated when saved to database")

	p := &Plant{
		Name:          "Tomato",
		Germinated:    true,
		DaysToHarvest: 90,
		GardenID:      g.ID,
	}

	_, err = db.ValidateAndCreate(p)
	if err != nil {
		panic(err)
	}

	ms.Equal(p.PlantName(), "Tomato")
	ms.NotEqual(uuid.Nil, p.ID, "Plant id is created when saving to database")

	t1 := &Tag{
		Name: "perennial",
	}

	t2 := &Tag{
		Name: "fruit",
	}

	verrs, err := db.ValidateAndCreate(t1)
	if err != nil {
		panic(err)
	}

	ms.NotEqual(uuid.Nil, t1.ID, "Tag id is created when saving to database")
	ms.False(verrs.HasAny(), "No errors when creating tag")
	ms.Equal(t1.TagName(), "perennial")

	verrs, err = db.ValidateAndCreate(t2)
	if err != nil {
		panic(err)
	}

	ms.NotEqual(uuid.Nil, t2.ID, "Tag id is created when saving to database")
	ms.False(verrs.HasAny(), "No errors when creating tag")
	ms.Equal(t2.TagName(), "fruit")

	pt := &PlantsTag{
		PlantID: p.ID,
		TagID:   t1.ID,
	}

	verrs, err = db.ValidateAndCreate(pt)
	if err != nil {
		panic(err)
	}

	ms.NotEqual(uuid.Nil, pt.ID, "PlantsTag id is created when saving to database")
	ms.False(verrs.HasAny(), "No errors when creating PlantsTag")

	pt2 := &PlantsTag{
		PlantID: p.ID,
		TagID:   t2.ID,
	}

	verrs, err = db.ValidateAndCreate(pt2)
	if err != nil {
		panic(err)
	}

	ms.NotEqual(uuid.Nil, pt2.ID, "PlantsTag id is created when saving to database")
	ms.False(verrs.HasAny(), "No errors when creating PlantsTag")

	ptTag, err := pt.ListPlantTags(ms.DB)
	if err != nil {
		ms.Fail("Error fetching plant tags", err.Error())
	}

	ms.Equal(ptTag, []string{"Tomato", "perennial"}, "Expected tag names to match")

	ptTag2, err := pt2.ListPlantTags(ms.DB)
	if err != nil {
		ms.Fail("Error fetching plant tags", err.Error())
	}

	ms.Equal(ptTag2, []string{"Tomato", "fruit"}, "Expected tag names to match")
}
