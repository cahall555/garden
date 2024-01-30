package models

import (
	"encoding/json"
	"time"
	"fmt"
	"github.com/gobuffalo/pop/v6"
	"github.com/gobuffalo/validate/v3"
	"github.com/gobuffalo/validate/v3/validators"
	"github.com/gofrs/uuid"
)

// Plant is used by pop to map your plants database table to your go code.
type Plant struct {
	ID          uuid.UUID `json:"id" db:"id"`
	Name        string    `json:"name" db:"name"`
	Germinated  bool      `json:"germinated" db:"germinated"`
	DaysHarvast int       `json:"days_harvast" db:"days_harvast"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
	UpdatedAt   time.Time `json:"updated_at" db:"updated_at"`
}

func (p Plant) Type() string {
	return fmt.Sprintf("%s", p.Name)
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
		&validators.IntIsPresent{Field: p.DaysHarvast, Name: "DaysHarvast"},
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
