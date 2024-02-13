package models

import (
	"encoding/json"
	"time"

	"github.com/gobuffalo/pop/v6"
	"github.com/gobuffalo/validate/v3"
	"github.com/gobuffalo/validate/v3/validators"
	"github.com/gofrs/uuid"
)

type Category string

const (
	Pests       Category = "Pests"
	Planting    Category = "Planting"
	Watering    Category = "Watering"
	Pruning     Category = "Pruning"
	Harvesting  Category = "Harvesting"
	Weather     Category = "Weather"
	Germination Category = "Germination"
)

// Journal is used by pop to map your journals database table to your go code.
type Journal struct {
	ID              uuid.UUID `json:"id" db:"id"`
	Title           string    `json:"title" db:"title"`
	Entry           string    `json:"entry" db:"entry"`
	DisplayOnGarden bool      `json:"display_on_garden" db:"display_on_garden"`
	Image           string    `json:"image" db:"image"`
	Category        Category  `json:"category" db:"category"`
	PlantID         uuid.UUID `json:"-" db:"plant_id"`
	Plant           *Plant    `json:"Plant,omitempty" belongs_to:"plant"`
	CreatedAt       time.Time `json:"created_at" db:"created_at"`
	UpdatedAt       time.Time `json:"updated_at" db:"updated_at"`
}

// String is not required by pop and may be deleted
func (j Journal) String() string {
	jj, _ := json.Marshal(j)
	return string(jj)
}

func (c Category) CatStr() string {
	return string(c)
}

// watch this ticket https://github.com/gobuffalo/fizz/issues/65, fizz does not support enums yet
func IsValidCategory(category string) bool {
	validCategories := []Category{Pests, Planting, Watering, Pruning, Harvesting, Weather, Germination}

	for _, v := range validCategories {
		if string(v) == category {
			return true
		}
	}
	return false
}

// Journals is not required by pop and may be deleted
type Journals []Journal

// String is not required by pop and may be deleted
func (j Journals) String() string {
	jj, _ := json.Marshal(j)
	return string(jj)
}

// Validate gets run every time you call a "pop.Validate*" (pop.ValidateAndSave, pop.ValidateAndCreate, pop.ValidateAndUpdate) method.
// This method is not required and may be deleted.
func (j *Journal) Validate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.Validate(
		&validators.StringIsPresent{Field: j.Title, Name: "Title"},
		&validators.StringIsPresent{Field: j.Entry, Name: "Entry"},
		&validators.StringIsPresent{Field: j.Category.CatStr(), Name: "Category"},
	), nil
}

// ValidateCreate gets run every time you call "pop.ValidateAndCreate" method.
// This method is not required and may be deleted.
func (j *Journal) ValidateCreate(tx *pop.Connection) (*validate.Errors, error) {
	if !IsValidCategory(string(j.Category)) {
		vErrs := validate.NewErrors()
		vErrs.Add("category", "invalid category")
		return vErrs, nil
	}
	return validate.NewErrors(), nil
}

// ValidateUpdate gets run every time you call "pop.ValidateAndUpdate" method.
// This method is not required and may be deleted.
func (j *Journal) ValidateUpdate(tx *pop.Connection) (*validate.Errors, error) {
	if !IsValidCategory(string(j.Category)) {
		vErrs := validate.NewErrors()
		vErrs.Add("category", "invalid category")
		return vErrs, nil
	}
	return validate.NewErrors(), nil
}
