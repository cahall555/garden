package actions

import (
	"net/http"
	"sync"

	"garden/locales"
	"garden/models"
	"garden/public"
	"log"

	"github.com/gobuffalo/buffalo"
	"github.com/gobuffalo/buffalo-pop/v3/pop/popmw"
	"github.com/gobuffalo/envy"

	//"github.com/gobuffalo/middleware/csrf" TODO: Is there a way to leave csrf active and use when needed?
	"github.com/gobuffalo/middleware/forcessl"
	"github.com/gobuffalo/middleware/i18n"
	"github.com/gobuffalo/middleware/paramlogger"
	"github.com/unrolled/secure"
	// "github.com/gorilla/sessions"
)

// ENV is used to help switch settings based on where the
// application is being run. Default is "development".
var ENV = envy.Get("GO_ENV", "development")

var (
	app     *buffalo.App
	appOnce sync.Once
	T       *i18n.Translator
)

// App is where all routes and middleware for buffalo
// should be defined. This is the nerve center of your
// application.
//
// Routing, middleware, groups, etc... are declared TOP -> DOWN.
// This means if you add a middleware to `app` *after* declaring a
// group, that group will NOT have that new middleware. The same
// is true of resource declarations as well.
//
// It also means that routes are checked in the order they are declared.
// `ServeFiles` is a CATCH-ALL route, so it should always be
// placed last in the route declarations, as it will prevent routes
// declared after it to never be called.
func App() *buffalo.App {
	appOnce.Do(func() {
		app = buffalo.New(buffalo.Options{
			Env:         ENV,
			SessionName: "_garden_session",
		})

		/*	store := sessions.NewCookieStore([]byte("your-secret-key")) // TODO: change this to a secret key
			store.Options = &sessions.Options{
			    Path:     "/",
			    MaxAge:   86400 * 30,
			    HttpOnly: true,
			    Secure:   ENV == "production",
			}*/

		app.Use(func(next buffalo.Handler) buffalo.Handler {
			return func(c buffalo.Context) error {
				log.Println("Request received for:", c.Request().URL.Path)
				return next(c)
			}
		})

		// Automatically redirect to SSL
		app.Use(forceSSL())

		// Log request parameters (filters apply).
		app.Use(paramlogger.ParameterLogger)

		// Protect against CSRF attacks. https://www.owasp.org/index.php/Cross-Site_Request_Forgery_(CSRF)
		// Remove to disable this.
		//	app.Use(csrf.New) *** See todo on line 14

		// Wraps each request in a transaction.
		//   c.Value("tx").(*pop.Connection)
		// Remove to disable this.
		app.Use(popmw.Transaction(models.DB))
		// Setup and use translations:
		app.Use(translations())

		//		app.GET("/csrf", func(c buffalo.Context) error {
		//        		csrfToken := csrf.Token(c)
		//        		return c.Render(200, r.JSON(map[string]string{"csrf_token": csrfToken}))
		//    		})

		//	app.GET("/", GardensIndex) //replacing HomeHandler

		//AuthMiddleware
		//	app.Use(SetCurrentUser)
		//	app.Use(Authorize)
		app.POST("/auth", AuthCreate)
		app.DELETE("/auth/delete", AuthDelete)
		app.GET("/users/new", UsersNew)
		app.POST("/users", UsersCreate)
		app.GET("/accounts", AccountsIndex)
		app.POST("/accounts", AccountsCreate)
		app.GET("/accounts/update/{id}", AccountsUpdate)
		app.GET("/accounts/{id}", AccountsShow)
		app.GET("/accounts/new", AccountsNew)
		app.PUT("/accounts/", AccountsEdit)
		app.DELETE("/accounts/{id}", AccountsDelete)
		app.GET("/usersaccount", UsersAccountShow)
		app.GET("/useraccounts", UserAccountsIndex)
		app.POST("/usersaccount", UsersAccountCreate)
		app.DELETE("/usersaccount/{id}", UsersAccountDelete)

		app.GET("/csrf", CsrfToken)
		app.GET("/gardens/create", GardensCreate)
		app.GET("/gardens/update/{id}", GardensUpdate)
		app.GET("/gardens/{id}", GardensShow)
		app.GET("/gardens", GardensIndex)
		app.POST("/gardens", GardensNew)
		app.PUT("/gardens/", GardensEdit)
		app.DELETE("/gardens/{id}", GardensDelete)
		app.GET("/plants/create", PlantsCreate)
		app.GET("/plants/update/{id}", PlantsUpdate)
		app.GET("/plants/{id}", PlantsShow)
		app.GET("/plants", PlantsIndex)
		app.POST("/plants", PlantsNew)
		app.PUT("/plants/", PlantsEdit)
		app.DELETE("/plants/{id}", PlantsDelete)
		app.GET("/tags/create", TagsCreate)
		app.GET("/tags/update/{id}", TagsUpdate)
		app.GET("/tags/{id}", TagsShow)
		app.GET("/tag/{name}", TagNameShow)
		app.GET("/tags", TagsIndex)
		app.POST("/tags", TagsNew)
		app.PUT("/tags/", TagsEdit)
		app.DELETE("/tags/{id}", TagsDelete)
		app.GET("/journals/create", JournalsCreate)
		app.GET("/journals/update/{id}", JournalsUpdate)
		app.GET("/journals/{id}", JournalsShow)
		app.GET("/journals", JournalsIndex)
		app.GET("/plant_journals", PlantJournals)
		app.POST("/journals", JournalsNew)
		app.PUT("/journals/", JournalsEdit)
		app.DELETE("/journals/{id}", JournalsDelete)
		app.GET("/water_schedules/create", WaterSchedulesCreate)
		app.GET("/water_schedules/update/{id}", WaterSchedulesUpdate)
		app.GET("/water_schedules/{id}", WaterSchedulesShow)
		app.GET("/water_schedules", WaterSchedulesIndex)
		app.POST("/water_schedules", WaterSchedulesNew)
		app.PUT("/water_schedules/", WaterSchedulesEdit)
		app.DELETE("/water_schedules/{id}", WaterSchedulesDelete)
		app.GET("/plantstag", PlantTagIndex)
		app.POST("/plantstag", PlantTagCreate)
		app.DELETE("/plantstag/{tagid}/{plantid}", PlantTagDelete)
		app.ServeFiles("/", http.FS(public.FS())) // serve files from the public directory
	})

	return app
}

// translations will load locale files, set up the translator `actions.T`,
// and will return a middleware to use to load the correct locale for each
// request.
// for more information: https://gobuffalo.io/en/docs/localization
func translations() buffalo.MiddlewareFunc {
	var err error
	if T, err = i18n.New(locales.FS(), "en-US"); err != nil {
		app.Stop(err)
	}
	return T.Middleware()
}

// forceSSL will return a middleware that will redirect an incoming request
// if it is not HTTPS. "http://example.com" => "https://example.com".
// This middleware does **not** enable SSL. for your application. To do that
// we recommend using a proxy: https://gobuffalo.io/en/docs/proxy
// for more information: https://github.com/unrolled/secure/
func forceSSL() buffalo.MiddlewareFunc {
	return forcessl.Middleware(secure.Options{
		SSLRedirect:     ENV == "production",
		SSLProxyHeaders: map[string]string{"X-Forwarded-Proto": "https"},
	})
}
