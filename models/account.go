package models

import (
	"encoding/json"
	"time"

	"github.com/gobuffalo/pop/v6"
	"github.com/gobuffalo/validate/v3"
	"github.com/gobuffalo/validate/v3/validators"
	"github.com/gofrs/uuid"
)

type Plan string

const (
	Free    Plan = "Free"
	Premium Plan = "Premium"
	Basic   Plan = "Basic"
)

// Account is used by pop to map your Account database table to your go code.
type Account struct {
	ID        uuid.UUID `json:"id" db:"id"`
	Plan      Plan      `json:"plan" db:"plan"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}

// String is not required by pop and may be deleted
func (a Account) String() string {
	ja, _ := json.Marshal(a)
	return string(ja)
}
func (c Plan) PlanStr() string {
	return string(c)
}

// watch this ticket https://github.com/gobuffalo/fizz/issues/65, fizz does not support enums yet
func IsValidPlan(plan string) bool {
	validPlan := []Plan{Free, Premium, Basic}

	for _, v := range validPlan {
		if string(v) == plan {
			return true
		}
	}
	return false
}

// Accounts is not required by pop and may be deleted
type Accounts []Account

// String is not required by pop and may be deleted
func (a Accounts) String() string {
	ja, _ := json.Marshal(a)
	return string(ja)
}

// Validate gets run every time you call a "pop.Validate*" (pop.ValidateAndSave, pop.ValidateAndCreate, pop.ValidateAndUpdate) method.
// This method is not required and may be deleted.
func (a *Account) Validate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.Validate(
		&validators.StringIsPresent{Field: a.Plan.PlanStr(), Name: "Plan"},
	), nil
}

// ValidateCreate gets run every time you call "pop.ValidateAndCreate" method.
// This method is not required and may be deleted.
func (a *Account) ValidateCreate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}

// ValidateUpdate gets run every time you call "pop.ValidateAndUpdate" method.
// This method is not required and may be deleted.
func (a *Account) ValidateUpdate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}
