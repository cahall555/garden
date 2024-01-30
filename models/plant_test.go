package models

func (ms *ModelSuite) Test_Plant() {
	p := &Plant{
		Name:"Tomato",
		DaysHarvast: 10,
		Germinated: false,
	}
	ms.Equal("Tomato", p.Type(), "The name should be Tomato")
	
	db := ms.DB
	verrs, err := db.ValidateAndCreate(p)
	if err != nil {
		panic(err)
	}

	ms.NotNil(p.ID, "The ID should be not nil")
	ms.False(verrs.HasAny(), "Required plant fields are missing.")
}
