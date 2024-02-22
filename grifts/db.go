package grifts

import (
	"garden/models"

	"github.com/gobuffalo/grift/grift"
)

var _ = grift.Namespace("db", func() {

	grift.Desc("seed", "Seeds a database")
	grift.Add("seed", func(c *grift.Context) error {

		//Seed gardens
		salsaGarden := models.Garden{Name: "Salsa Garden", Zone: "13"}
		err := models.DB.Create(&salsaGarden)
		if err != nil {
			panic(err)
		}
		herbGarden := models.Garden{Name: "Herb Garden", Zone: "13"}
		err = models.DB.Create(&herbGarden)
		if err != nil {
			panic(err)
		}
		veggieGarden := models.Garden{Name: "Veggie Garden", Zone: "13"}
		err = models.DB.Create(&veggieGarden)
		if err != nil {
			panic(err)
		}

		//Seed plants
		basil := models.Plant{Name: "Basil", Germinated: true, DaysToHarvest: 30, GardenID: herbGarden.ID}
		err = models.DB.Create(&basil)
		if err != nil {
			panic(err)
		}
		oregano := models.Plant{Name: "Oregano", Germinated: false, DaysToHarvest: 30, GardenID: herbGarden.ID}
		err = models.DB.Create(&oregano)
		if err != nil {
			panic(err)
		}
		tomato := models.Plant{Name: "Tomato", Germinated: true, DaysToHarvest: 90, GardenID: salsaGarden.ID}
		err = models.DB.Create(&tomato)
		if err != nil {
			panic(err)
		}
		jalapeno := models.Plant{Name: "Jalapeno", Germinated: true, DaysToHarvest: 90, GardenID: salsaGarden.ID}
		err = models.DB.Create(&jalapeno)
		if err != nil {
			panic(err)
		}
		cucumber := models.Plant{Name: "Cucumber", Germinated: true, DaysToHarvest: 60, GardenID: veggieGarden.ID}
		err = models.DB.Create(&cucumber)
		if err != nil {
			panic(err)
		}
		carrot := models.Plant{Name: "Carrot", Germinated: false, DaysToHarvest: 60, GardenID: veggieGarden.ID}
		err = models.DB.Create(&carrot)
		if err != nil {
			panic(err)
		}

		//Seed tags
		herbTag := models.Tag{Name: "Herb"}
		err = models.DB.Create(&herbTag)
		if err != nil {
			panic(err)
		}
		perinnialTag := models.Tag{Name: "Perinnial"}
		err = models.DB.Create(&perinnialTag)
		if err != nil {
			panic(err)
		}
		annualTag := models.Tag{Name: "Annual"}
		err = models.DB.Create(&annualTag)
		if err != nil {
			panic(err)
		}

		//Seed plant_tags
		pt1 := models.PlantsTag{PlantID: basil.ID, TagID: herbTag.ID}
		err = models.DB.Create(&pt1)
		if err != nil {
			panic(err)
		}
		pt2 := models.PlantsTag{PlantID: basil.ID, TagID: perinnialTag.ID}
		err = models.DB.Create(&pt2)
		if err != nil {
			panic(err)
		}

		//Seed Journals
		j1 := models.Journal{Title: "Observation", Entry: "Basil is growing well", DisplayOnGarden: false, Category: "Planting", PlantID: basil.ID}
		err = models.DB.Create(&j1)
		if err != nil {
			panic(err)
		}

		j2 := models.Journal{Title: "Observation", Entry: "Oregano is not germinating", DisplayOnGarden: false, Category: "Germination", PlantID: oregano.ID}
		err = models.DB.Create(&j2)
		if err != nil {
			panic(err)
		}

		j3 := models.Journal{Title: "New leaves", Entry: "New leaves are growing!", DisplayOnGarden: false, Image: "tomato.jpg", Category: "Germination", PlantID: tomato.ID}
		err = models.DB.Create(&j3)
		if err != nil {
			panic(err)
		}

		//Seed WaterSchedules
		ws1 := models.WaterSchedule{Monday: true, Tuesday: false, Wednesday: true, Thursday: false, Friday: true, Saturday: false, Sunday: true, Method: "Drip", Notes:"Watering every other day", PlantID: basil.ID}
		err = models.DB.Create(&ws1)
		if err != nil {
			panic(err)
		}

		return nil
	})

})
