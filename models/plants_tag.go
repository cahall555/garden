package models

import (
	"encoding/json"
	"time"

	"github.com/gobuffalo/pop/v6"
	"github.com/gobuffalo/validate/v3"
	"github.com/gofrs/uuid"
)

// PlantsTag is used by pop to map your plants_tags database table to your go code.
type PlantsTag struct {
	ID        uuid.UUID `json:"id" db:"id"`
	PlantID   uuid.UUID `db:"plant_id"`
	Plant     *Plant    `belongs_to:"plants"`
	TagID     uuid.UUID `db:"tag_id"`
	Tag       *Tag      `belongs_to:"tags"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}

// String is not required by pop and may be deleted
func (p PlantsTag) String() string {
	jp, _ := json.Marshal(p)
	return string(jp)
}

// PlantsTags is not required by pop and may be deleted
type PlantsTags []PlantsTag

// String is not required by pop and may be deleted
func (p PlantsTags) String() string {
	jp, _ := json.Marshal(p)
	return string(jp)
}

// Validate gets run every time you call a "pop.Validate*" (pop.ValidateAndSave, pop.ValidateAndCreate, pop.ValidateAndUpdate) method.
// This method is not required and may be deleted.
func (p *PlantsTag) Validate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}

// ValidateCreate gets run every time you call "pop.ValidateAndCreate" method.
// This method is not required and may be deleted.
func (p *PlantsTag) ValidateCreate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}

// ValidateUpdate gets run every time you call "pop.ValidateAndUpdate" method.
// This method is not required and may be deleted.
func (p *PlantsTag) ValidateUpdate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}
