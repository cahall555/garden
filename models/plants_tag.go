package models

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/gobuffalo/pop/v6"
	"github.com/gobuffalo/validate/v3"
	"github.com/gofrs/uuid"
)

// PlantsTag is used by pop to map your plants_tags database table to your go code.
type PlantsTag struct {
	ID        uuid.UUID `json:"id" db:"id"`
	PlantID   uuid.UUID `json:"plant_id" db:"plant_id"`
	Plant     *Plant    `json:"Plant,omitempty" belongs_to:"plants"`
	TagID     uuid.UUID `json:"tag_id" db:"tag_id"`
	Tag       *Tag      `json:"Tag,omitempty" belongs_to:"tags"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}

func (pt *PlantsTag) ListPlantTags(tx *pop.Connection) ([]string, error) {
	var names []string

	var plant Plant
	err := tx.Where("id = ?", pt.PlantID).First(&plant)
	if err != nil {
		return nil, fmt.Errorf("error fetching plant by id: %w", err)
	}
	names = append(names, plant.Name)

	var tag Tag
	err = tx.Where("id = ?", pt.TagID).First(&tag)
	if err != nil {
		return nil, fmt.Errorf("error fetching tag by id: %w", err)
	}

	names = append(names, tag.Name)

	return names, nil
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
