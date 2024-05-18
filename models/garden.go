package models

import (
	"encoding/json"
	"time"

	"github.com/gobuffalo/pop/v6"
	"github.com/gobuffalo/validate/v3"
	"github.com/gobuffalo/validate/v3/validators"
	"github.com/gofrs/uuid"
)

// Garden is used by pop to map your gardens database table to your go code.
type Garden struct {
	ID          uuid.UUID `json:"id" db:"id"`
	Name        string    `json:"name" db:"name"`
	Description string    `json:"description" db:"description"`
	Plants      []Plant   `json:"plants,omitempty" has_many:"plants"`
	AccountID   uuid.UUID `json:"account_id" db:"account_id"`
	Account     *Account  `json:"Account,omitempty" belongs_to:"account"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
	UpdatedAt   time.Time `json:"updated_at" db:"updated_at"`
}

func (g Garden) GardenDescription() string {
	return g.Name + " description " + g.Description
}

func (g Garden) GetPlants(tx *pop.Connection) error {
	var plants []Plant
	err := tx.Where("garden_id = ?", g.ID).All(&plants)
	if err != nil {
		return err
	}

	g.Plants = plants
	return nil
}

func (g Garden) SelectLabel() string {
	return g.Name
}

func (g Garden) SelectValue() interface{} {
	return g.ID
}

// String is not required by pop and may be deleted
func (g Garden) String() string {
	jg, _ := json.Marshal(g)
	return string(jg)
}

// Gardens is not required by pop and may be deleted
type Gardens []Garden

// String is not required by pop and may be deleted
func (g Gardens) String() string {
	jg, _ := json.Marshal(g)
	return string(jg)
}

// Validate gets run every time you call a "pop.Validate*" (pop.ValidateAndSave, pop.ValidateAndCreate, pop.ValidateAndUpdate) method.
// This method is not required and may be deleted.
func (g *Garden) Validate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.Validate(
		&validators.StringIsPresent{Field: g.Name, Name: "Name"},
		&validators.StringIsPresent{Field: g.Description, Name: "Description"},
	), nil
}

// ValidateCreate gets run every time you call "pop.ValidateAndCreate" method.
// This method is not required and may be deleted.
func (g *Garden) ValidateCreate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}

// ValidateUpdate gets run every time you call "pop.ValidateAndUpdate" method.
// This method is not required and may be deleted.
func (g *Garden) ValidateUpdate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}
