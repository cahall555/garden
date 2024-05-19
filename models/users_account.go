package models

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/gobuffalo/pop/v6"
	"github.com/gobuffalo/validate/v3"
	"github.com/gofrs/uuid"
)

// UsersAccount is used by pop to map your plants_tags database table to your go code.
type UsersAccount struct {
	ID        uuid.UUID `json:"id" db:"id"`
	UserID    uuid.UUID `json:"user_id" db:"user_id"`
	User      *User     `json:"User,omitempty" belongs_to:"users"`
	AccountID uuid.UUID `json:"account_id" db:"account_id"`
	Account   *Account  `json:"Account,omitempty" belongs_to:"accounts"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}

func (ua *UsersAccount) ListUserAccounts(tx *pop.Connection) ([]string, error) {
	var names []string

	var user User
	err := tx.Where("id = ?", ua.UserID).First(&user)
	if err != nil {
		return nil, fmt.Errorf("error fetching user by id: %w", err)
	}
	names = append(names, user.FirstName)

	var account Account
	err = tx.Where("id = ?", ua.AccountID).First(&account)
	if err != nil {
		return nil, fmt.Errorf("error fetching account by id: %w", err)
	}

	names = append(names, account.Plan.PlanStr())

	return names, nil
}

// String is not required by pop and may be deleted
func (u UsersAccount) String() string {
	ju, _ := json.Marshal(u)
	return string(ju)
}

// PlantsTags is not required by pop and may be deleted
type UsersAccounts []UsersAccount

// String is not required by pop and may be deleted
func (u UsersAccounts) String() string {
	ju, _ := json.Marshal(u)
	return string(ju)
}

// Validate gets run every time you call a "pop.Validate*" (pop.ValidateAndSave, pop.ValidateAndCreate, pop.ValidateAndUpdate) method.
// This method is not required and may be deleted.
func (u *UsersAccount) Validate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}

// ValidateCreate gets run every time you call "pop.ValidateAndCreate" method.
// This method is not required and may be deleted.
func (u *UsersAccount) ValidateCreate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}

// ValidateUpdate gets run every time you call "pop.ValidateAndUpdate" method.
// This method is not required and may be deleted.
func (u *UsersAccount) ValidateUpdate(tx *pop.Connection) (*validate.Errors, error) {
	return validate.NewErrors(), nil
}
