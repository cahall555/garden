# Welcome to Buffalo

Thank you for choosing Buffalo for your web development needs.

## Database Setup

It looks like you chose to set up your application using a database! Fantastic!

The first thing you need to do is open up the "database.yml" file and edit it to use the correct usernames, passwords, hosts, etc... that are appropriate for your environment.

You will also need to make sure that **you** start/install the database of your choice. Buffalo **won't** install and start it for you.

### Create Your Databases

Ok, so you've edited the "database.yml" file and started your database, now Buffalo can create the databases in that file for you:

```console
buffalo pop create -a
```

## Starting the Application

Buffalo ships with a command that will watch your application and automatically rebuild the Go binary and any assets for you. To do that run the "buffalo dev" command:

```console
buffalo dev
```

If you point your browser to [http://127.0.0.1:3000](http://127.0.0.1:3000) you should see a "Welcome to Buffalo!" page.

**Congratulations!** You now have your Buffalo application up and running.

## What Next?

We recommend you heading over to [http://gobuffalo.io](http://gobuffalo.io) and reviewing all of the great documentation there.

Good luck!

[Powered by Buffalo](http://gobuffalo.io)


# Notes

Start docker postgres `docker run --name garden_development -e POSTGRES_PASSWORD=postgres -p 5432:5432 -d postgres`
create database `buffalo pop create -a`
create tables `buffalo pop migrate` 
seed database `buffalo task db:seed`


docker container: docker exec -it [ID] bash
database: psql -h localhost -U postgres

### Dart(frontend) Testing
`flutter test` or `flutter test test/[file]_test.dart`
Note: When creating tests always create a mock by running `dart run build_runner build`.

### Dart(frontend) Test Coverage
`flutter test --coverage`
`genhtml coverage/lcov.info -o coverage/html`
`open coverage/html/index.html`
