package models

func (ms *ModelSuite) Test_Garden() {
	g := &Garden{
		Name: "Salsa Garden",
		Zone: "13",
	}

	ms.Equal(g.GardenZone(), "Salsa Garden is in zone 13")

	db := ms.DB
	verrs, err := db.ValidateAndCreate(g)
	if err != nil {
		panic(err)
	}

	ms.NotNil(g.ID, "Garden id is generated when saved to database")
	ms.False(verrs.HasAny(), "All fields must be completed")
}
