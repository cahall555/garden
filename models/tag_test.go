package models

import (
	"github.com/gofrs/uuid"
)

func (ms *ModelSuite) Test_Tag() {
	t := &Tag{
		Name: "perennial",
	}

	db := ms.DB
	verrs, err := db.ValidateAndCreate(t)
	if err != nil {
		panic(err)
	}

	ms.NotEqual(uuid.Nil, t.ID, "Tag id is created when saving to database")
	ms.False(verrs.HasAny(), "No errors when creating tag")
}

func (ms *ModelSuite) Test_TagGetPlants() {
	t1 := &Tag{
		Name: "perennial",
	}

	t2 := &Tag{
		Name: "annual",
	}

	db := ms.DB
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
	ms.Equal(t2.TagName(), "annual")

	g:= &Garden{
		Name: "backyard",
		Zone: "13",
	}

	verrs, err = db.ValidateAndCreate(g)
	if err != nil {
		panic(err)
	}

	p1 := &Plant{
		Name: "rose",
		Germinated: true,
		DaysToHarvest: 50,
		GardenID: g.ID,
		PlantTags: Tags{*t1},
	}

	p2 := &Plant{
		Name: "tomato",
		Germinated: true,
		DaysToHarvest: 100,
		GardenID: g.ID,
		PlantTags: Tags{*t2},
	}

	verrs, err = db.ValidateAndCreate(p1)
	if err != nil {
		panic(err)
	}

	ms.NotEqual(uuid.Nil, p1.ID, "Plant id is created when saving to database")
	ms.False(verrs.HasAny(), "No errors when creating plant")

	verrs, err = db.ValidateAndCreate(p2)
	if err != nil {
		panic(err)
	}

	ms.NotEqual(uuid.Nil, p2.ID, "Plant id is created when saving to database")
	ms.False(verrs.HasAny(), "No errors when creating plant")


	g.Plants = append(g.Plants, *p1, *p2)
	ms.Equal(g.Plants[0].PlantName(), "rose")
	ms.Equal(g.Plants[1].PlantName(), "tomato")

}
