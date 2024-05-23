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
	PlantCount    int       `json:"plant_count" db:"plant_count"`
	DatePlanted   time.Time `json:"date_planted" db:"date_planted"`
	DateGerminated time.Time `json:"date_germinated" db:"date_germinated"`
	GardenID      uuid.UUID `json:"garden_id" db:"garden_id"`
	Garden        *Garden   `json:"Garden,omitempty" belongs_to:"garden"`
	PlantTags     Tags      `json:"plant_tags,omitempty" many_to_many:"plants_tags"`
	Journals      []Journal `json:"journals,omitempty" has_many:"journals"`
	WaterSchedules WaterSchedule `has_one:"water_schedules"`
	AccountID     uuid.UUID `json:"account_id" db:"account_id"`
	Account       *Account  `json:"Account,omitempty" belongs_to:"accounts"`
	CreatedAt     time.Time `json:"created_at" db:"created_at"`
	UpdatedAt     time.Time `json:"updated_at" db:"updated_at"`
}

func (p Plant) PlantName() string {
	return p.Name
}

func (p Plant) GetJournals(tx *pop.Connection) error {
	var journals []Journal
	err := tx.Where("plant_id = ?", p.ID).All(&journals)
	if err != nil {
		return err
	}

	p.Journals = journals
	return nil
}

func (p Plant) SelectLabel() string {
	return p.Name
}

func (p Plant) SelectValue() interface{} {
	return p.ID
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
