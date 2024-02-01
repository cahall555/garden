package models

import (
	"encoding/json"
	"time"

	"github.com/gobuffalo/pop/v6"
	"github.com/gobuffalo/validate/v3"
	"github.com/gobuffalo/validate/v3/validators"
	"github.com/gofrs/uuid"
)

// Plant is used by pop to map your plants database table to your go code.
type Plant struct {
	ID            uuid.UUID `json:"id" db:"id"`
	Name          string    `json:"name" db:"name"`
	Germinated    bool      `json:"germinated" db:"germinated"`
	DaysToHarvest int       `json:"days_to_harvest" db:"days_to_harvest"`
	GardenID      uuid.UUID `json:"-" db:"garden_id"`
	Garden        *Garden   `json:"Garden,omitempty" belongs_to:"garden"`
	CreatedAt     time.Time `json:"created_at" db:"created_at"`
	UpdatedAt     time.Time `json:"updated_at" db:"updated_at"`
}

func (p Plant) PlantName() string {
	return p.Name
}

// String is not required by pop and may be deleted
func (p Plant) String() string {
	jp, _ := json.Marshal(p)
	return string(jp)
}

// Plants is not required by pop and may be deleted
type Plants []Plant

// String is not required by pop and may be deleted
func (p Plants) String() string {
	jp, _ := json.Marshal(p)
	return string(jp)
}

// Validate gets run every time you call a "pop.Validate*" (pop.ValidateAndSave, pop.ValidateAndCreate, pop.ValidateAndUpdate) method.
// This method is not required and may be deleted.
func (p *Plant) Validate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.Validate(
		&validators.StringIsPresent{Field: p.Name, Name: "Name"},
		&validators.IntIsPresent{Field: p.DaysToHarvest, Name: "DaysToHarvest"},
	), nil
}

// ValidateCreate gets run every time you call "pop.ValidateAndCreate" method.
// This method is not required and may be deleted.
func (p *Plant) ValidateCreate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}

// ValidateUpdate gets run every time you call "pop.ValidateAndUpdate" method.
// This method is not required and may be deleted.
func (p *Plant) ValidateUpdate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}
