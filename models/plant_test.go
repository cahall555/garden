package models


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
		Name: "Tomato",
		Germinated: true,
		DaysToHarvest: 90,
		GardenID: g.ID,
	}

	g.Plants = append(g.Plants, *p)

	ms.Equal(p.PlantName(), "Tomato")
	
	verrs, err = db.ValidateAndCreate(p)
	if err != nil {
		panic(err)
	}
	ms.Equal(g.ID, p.GardenID, "Plant's GardenID should match the Garden's ID")
	ms.False(verrs.HasAny(), "All fields must be completed")
}
