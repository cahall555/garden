package grifts

import (
	"garden/models"
	"time"
	"github.com/gobuffalo/grift/grift"
)

var _ = grift.Namespace("db", func() {

	grift.Desc("seed", "Seeds a database")
	grift.Add("seed", func(c *grift.Context) error {
		//Seed accounts
		free := models.Account{Plan: "Free"}
		err := models.DB.Create(&free)
		if err != nil {
			panic(err)
		}
		premium := models.Account{Plan: "Premium"}
		err = models.DB.Create(&premium)
		if err != nil {
			panic(err)
		}
	
		//Seed users
		user1 := models.User{FirstName: "John", LastName: "Doe", Email: "john@garden.com", PasswordHash: "password"}
		err = models.DB.Create(&user1)
		if err != nil {
			panic(err)
		}
		user2 := models.User{FirstName: "Jane", LastName: "Doe", Email: "jane@garden.com", PasswordHash: "password"}
		err = models.DB.Create(&user2)
		if err != nil {
			panic(err)
		}

		//Seed users_account
		ua1 := models.UsersAccount{UserID: user1.ID, AccountID: free.ID}
		err = models.DB.Create(&ua1)
		if err != nil {
			panic(err)
		}
		ua2 := models.UsersAccount{UserID: user2.ID, AccountID: premium.ID}
		err = models.DB.Create(&ua2)
		if err != nil {
			panic(err)
		}

		// Parse date strings
		basilDatePlanted, _ := time.Parse("2006-01-02", "2024-05-20")
		tomatoDatePlanted, _ := time.Parse("2006-01-02", "2024-04-20")
		tomatoDateGerminated, _ := time.Parse("2006-01-02", "2024-05-01")

		//Seed gardens
		salsaGarden := models.Garden{Name: "Salsa Garden", Description: "This garden is for growing salsa ingredients", AccountID: premium.ID}
		err = models.DB.Create(&salsaGarden)
		if err != nil {
			panic(err)
		}
		herbGarden := models.Garden{Name: "Herb Garden", Description: "This garden is for growing herbs", AccountID: free.ID}
		err = models.DB.Create(&herbGarden)
		if err != nil {
			panic(err)
		}
		veggieGarden := models.Garden{Name: "Veggie Garden", Description: "This garden is for growing vegetables", AccountID: premium.ID}
		err = models.DB.Create(&veggieGarden)
		if err != nil {
			panic(err)
		}

		//Seed plants
		basil := models.Plant{Name: "Basil", Germinated: true, DaysToHarvest: 30, PlantCount: 3, DatePlanted: basilDatePlanted, GardenID: herbGarden.ID, AccountID: free.ID}
		err = models.DB.Create(&basil)
		if err != nil {
			panic(err)
		}
		oregano := models.Plant{Name: "Oregano", Germinated: false, DaysToHarvest: 30, GardenID: herbGarden.ID, AccountID: free.ID}
		err = models.DB.Create(&oregano)
		if err != nil {
			panic(err)
		}
		tomato := models.Plant{Name: "Tomato", Germinated: true, DaysToHarvest: 90, PlantCount: 20, DatePlanted: tomatoDatePlanted, DateGerminated: tomatoDateGerminated, GardenID: salsaGarden.ID, AccountID: premium.ID}
		err = models.DB.Create(&tomato)
		if err != nil {
			panic(err)
		}
		jalapeno := models.Plant{Name: "Jalapeno", Germinated: true, DaysToHarvest: 90, PlantCount: 16, GardenID: salsaGarden.ID, AccountID: premium.ID}
		err = models.DB.Create(&jalapeno)
		if err != nil {
			panic(err)
		}
		cucumber := models.Plant{Name: "Cucumber", Germinated: true, DaysToHarvest: 60, GardenID: veggieGarden.ID, AccountID: premium.ID}
		err = models.DB.Create(&cucumber)
		if err != nil {
			panic(err)
		}
		carrot := models.Plant{Name: "Carrot", Germinated: false, DaysToHarvest: 60, GardenID: veggieGarden.ID, AccountID: premium.ID}
		err = models.DB.Create(&carrot)
		if err != nil {
			panic(err)
		}

		//Seed tags
		herbTag := models.Tag{Name: "Herb", AccountID: free.ID}
		err = models.DB.Create(&herbTag)
		if err != nil {
			panic(err)
		}
		perinnialTag := models.Tag{Name: "Perinnial", AccountID: free.ID}
		err = models.DB.Create(&perinnialTag)
		if err != nil {
			panic(err)
		}
		annualTag := models.Tag{Name: "Annual", AccountID: premium.ID}
		err = models.DB.Create(&annualTag)
		if err != nil {
			panic(err)
		}
		herbTag2 := models.Tag{Name: "Herb", AccountID: premium.ID}
		err = models.DB.Create(&herbTag2)
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
