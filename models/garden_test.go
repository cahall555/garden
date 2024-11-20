package models

func (ms *ModelSuite) Test_Garden() {
	g := &Garden{
		Name:        "Salsa Garden",
		Description: "This garden was planted in mid-May and is expected to produce a variety of salsa ingredients.",
	}

	ms.Equal(g.GardenZone(), "Salsa Garden description This garden was planted in mid-May and is expected to produce a variety of salsa ingredients.")

	db := ms.DB
	verrs, err := db.ValidateAndCreate(g)
	if err != nil {
		panic(err)
	}

	ms.NotNil(g.ID, "Garden id is generated when saved to database")
	ms.False(verrs.HasAny(), "All fields must be completed")
}

func (ms *ModelSuite) Test_GardenPlant() {
	g := &Garden{
		Name:        "Salsa Garden",
		Description: "This garden was planted in mid-May and is expected to produce a variety of salsa ingredients.",
		Plants: []Plant{
			{
				Name:          "Tomato",
				Germinated:    true,
				DaysToHarvest: 90,
			},
		},
	}

	db := ms.DB
	_, err := db.Eager().ValidateAndCreate(g)
	if err != nil {
		panic(err)
	}

	ms.Equal(g.Plants[0].PlantName(), "Tomato")

	g2 := Garden{}
	err = db.Find(&g2, g.ID)
	if err != nil {
		panic(err)
	}

	ms.Empty(g2.Plants, "Plants should not be eager loaded")
}

func (ms *ModelSuite) Test_Fixture() {
	ms.LoadFixture("model test")

	var g Garden
	err := ms.DB.Where("name = ?", "Salsa Garden").First(&g)
	if err != nil {
		ms.Fail("Failed to query garden", err.Error())
	}

	ms.Equal(g.Name, "Salsa Garden")
}
