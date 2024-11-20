package models

import (
	"encoding/json"
	"time"

	"github.com/gobuffalo/pop/v6"
	"github.com/gobuffalo/validate/v3"
	"github.com/gobuffalo/validate/v3/validators"
	"github.com/gofrs/uuid"
)

type Method string

const (
	Drip      Method = "Drip"
	Hand      Method = "Hand watering"
	Sprinkler Method = "Sprinkler"
	Soaker    Method = "Soaker hose"
)

// WaterSchedule is used by pop to map your water_schedules database table to your go code.
type WaterSchedule struct {
	ID        uuid.UUID `json:"id" db:"id"`
	Monday    bool      `json:"monday" db:"monday"`
	Tuesday   bool      `json:"tuesday" db:"tuesday"`
	Wednesday bool      `json:"wednesday" db:"wednesday"`
	Thursday  bool      `json:"thursday" db:"thursday"`
	Friday    bool      `json:"friday" db:"friday"`
	Saturday  bool      `json:"saturday" db:"saturday"`
	Sunday    bool      `json:"sunday" db:"sunday"`
	Method    Method    `json:"method" db:"method"`
	Notes     string    `json:"notes" db:"notes"`
	PlantID   uuid.UUID `json:"plant_id" db:"plant_id"`
	Plant     *Plant    `json:"Plant,omitempty" belongs_to:"plant"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}

// String is not required by pop and may be deleted
func (w WaterSchedule) String() string {
	jw, _ := json.Marshal(w)
	return string(jw)
}

func (c Method) MethodStr() string {
	return string(c)
}

// watch this ticket https://github.com/gobuffalo/fizz/issues/65, fizz does not support enums yet
func IsValidMethod(method string) bool {
	validMethod := []Method{Drip, Hand, Sprinkler, Soaker}

	for _, v := range validMethod {
		if string(v) == method {
			return true
		}
	}
	return false
}

// WaterSchedules is not required by pop and may be deleted
type WaterSchedules []WaterSchedule

// String is not required by pop and may be deleted
func (w WaterSchedules) String() string {
	jw, _ := json.Marshal(w)
	return string(jw)
}

// Validate gets run every time you call a "pop.Validate*" (pop.ValidateAndSave, pop.ValidateAndCreate, pop.ValidateAndUpdate) method.
// This method is not required and may be deleted.
func (w *WaterSchedule) Validate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.Validate(
		&validators.StringIsPresent{Field: w.Method.MethodStr(), Name: "Method"},
		&validators.StringIsPresent{Field: w.Notes, Name: "Notes"},
	), nil
}

// ValidateCreate gets run every time you call "pop.ValidateAndCreate" method.
// This method is not required and may be deleted.
func (w *WaterSchedule) ValidateCreate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}

// ValidateUpdate gets run every time you call "pop.ValidateAndUpdate" method.
// This method is not required and may be deleted.
func (w *WaterSchedule) ValidateUpdate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}
