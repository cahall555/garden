package models

import (
	"github.com/gofrs/uuid"
)

func (ms *ModelSuite) Test_Tag() {
	t := &Tag{
		Name: "annual",
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
}

