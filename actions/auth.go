package actions

import (
	"database/sql"
	"garden/models"
	"log"
	"net/http"
	"strings"
	"time"
	"github.com/gofrs/uuid"
	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/envy"
	"github.com/gobuffalo/pop/v6"
	"github.com/gobuffalo/validate"
	"github.com/golang-jwt/jwt/v5"
	"github.com/pkg/errors"
	"golang.org/x/crypto/bcrypt"
)

// AuthCreate attempts to log the user in with an existing account
func AuthCreate(c buffalo.Context) error {
	c.Logger().Info("***************AuthCreate start *************** ")
	tx, ok := c.Value("tx").(*pop.Connection)
	if !ok {
		return c.Error(500, errors.New("no transaction found"))
	}

	u := &models.User{}
	if err := c.Bind(u); err != nil {
		return err
	}

	err := c.Request().ParseForm()
	if err != nil {
		return err
	}

	log.Println("***************AuthCreate: ", u.Email, u.Password)

	err = tx.Where("email = ?", strings.ToLower(strings.TrimSpace(u.Email))).First(u)

	bad := func() error {
		verrs := validate.NewErrors()
		verrs.Add("email", "invalid entry")

		c.Set("errors", verrs)
		c.Set("user", u)
		c.Logger().Info("***************AuthCreate: bad attempt", verrs.Errors)
		return c.Render(http.StatusUnauthorized, r.JSON(u))
	}

	if err != nil {
		if errors.Cause(err) == sql.ErrNoRows {
			c.Logger().Info("***************AuthCreate: could not find email address: ", err)
			return bad()
		}
		return err
	}

	err = bcrypt.CompareHashAndPassword([]byte(u.PasswordHash), []byte(u.Password))
	if err != nil {
		c.Logger().Info("***************AuthCreate: bad password", err)
		return bad()
	}
	c.Session().Set("current_user_id", u.ID)
	c.Logger().Info("***************AuthCreate: login successful")

	userID := u.ID
	accessToken, refreshToken, err := GenerateTokens(userID)
	if err != nil {
		return c.Error(500, err)
	}

	refreshTokenRecord := &models.RefreshToken{
        UserID:    userID,
        Token:     refreshToken,
        ExpiresAt: time.Now().Add(30 * 24 * time.Hour),
    	}

    	err = tx.Create(refreshTokenRecord)
    	if err != nil {
        	return c.Error(500, errors.Wrap(err, "failed to store refresh token"))
    	}

	return c.Render(http.StatusOK, r.JSON(map[string]interface{}{
		"user": map[string]interface{}{
			"id":         u.ID,
			"email":      u.Email,
			"first_name": u.FirstName,
			"last_name":  u.LastName,
		},
		"access_token":  accessToken,
		"refresh_token": refreshToken,
	}))
}

var jwtSecretKey = []byte(envy.Get("JWT_SECRET_KEY", ""))

func GenerateTokens(userID uuid.UUID) (string, string, error) {

	accessTokenClaims := jwt.MapClaims{
		"user_id": userID,
		"exp":     time.Now().Add(15 * time.Minute).Unix(),
	}
	accessToken := jwt.NewWithClaims(jwt.SigningMethodHS256, accessTokenClaims)
	accessTokenString, err := accessToken.SignedString(jwtSecretKey)
	if err != nil {
		return "", "", err
	}

	refreshTokenClaims := jwt.MapClaims{
		"user_id": userID,
		"exp":     time.Now().Add(30 * 24 * time.Hour).Unix(),
	}
	refreshToken := jwt.NewWithClaims(jwt.SigningMethodHS256, refreshTokenClaims)
	refreshTokenString, err := refreshToken.SignedString(jwtSecretKey)
	if err != nil {
		return "", "", err
	}

	return accessTokenString, refreshTokenString, nil
}

func RefreshToken(c buffalo.Context) error {
	refreshToken := c.Param("refresh_token")
	if refreshToken == "" {
		return c.Error(http.StatusBadRequest, errors.New("refresh token is required"))
	}

	tx, ok := c.Value("tx").(*pop.Connection)
	if !ok {
		return c.Error(500, errors.New("no transaction found"))
	}

	refreshTokenRecord := &models.RefreshToken{}
	err := tx.Where("token = ? AND expires_at > ?", refreshToken, time.Now()).First(refreshTokenRecord)
	if err != nil {
		if errors.Cause(err) == sql.ErrNoRows {
			return c.Error(http.StatusUnauthorized, errors.New("invalid or expired refresh token"))
		}
		return c.Error(500, err)
	}

	token, err := jwt.Parse(refreshToken, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, errors.New("unexpected signing method")
		}
		return jwtSecretKey, nil
	})

	if err != nil || !token.Valid {
		return c.Error(http.StatusUnauthorized, err)
	}

	claims, ok := token.Claims.(jwt.MapClaims)
	if !ok || claims["user_id"] == nil {
		return c.Error(http.StatusUnauthorized, errors.New("invalid claims"))
	}

	userIDStr, ok := claims["user_id"].(string)
	if !ok {
		return c.Error(http.StatusUnauthorized, errors.New("user_id is not a string"))
	}

	userID, err := uuid.FromString(userIDStr)
	if err != nil {
		return c.Error(http.StatusUnauthorized, errors.New("invalid user_id format"))
	}

	accessToken, newRefreshToken, err := GenerateTokens(userID)
	if err != nil {
		return c.Error(http.StatusInternalServerError, err)
	}

	refreshTokenRecord.Token = newRefreshToken
	refreshTokenRecord.ExpiresAt = time.Now().Add(30 * 24 * time.Hour)
	err = tx.Update(refreshTokenRecord)
	if err != nil {
		return c.Error(500, errors.Wrap(err, "failed to update refresh token"))
	}

	return c.Render(http.StatusOK, r.JSON(map[string]string{
		"access_token":  accessToken,
		"refresh_token": newRefreshToken,
	}))

}

// AuthDestroy clears the session and logs a user out
func AuthDelete(c buffalo.Context) error {
	tx, ok := c.Value("tx").(*pop.Connection)
	if !ok {
		return c.Error(500, errors.New("no transaction found"))
	}

	userID := c.Session().Get("current_user_id")
	if userID == nil {
		return c.Error(http.StatusUnauthorized, errors.New("unauthorized"))
	}

	err := tx.RawQuery("DELETE FROM refresh_tokens WHERE user_id = ?", userID).Exec()
	if err != nil {
		return c.Error(500, errors.Wrap(err, "failed to delete refresh token"))
	}
	c.Session().Clear()
	return c.Render(http.StatusOK, r.JSON("Logged out successfully"))
}
