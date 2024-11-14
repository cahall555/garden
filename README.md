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
