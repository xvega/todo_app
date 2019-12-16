# TODO APP

# Dependencies: 
[docker](https://docs.docker.com/docker-for-mac/install/) - Docker is a full development platform to build, run, and share containerized applications.

## How to run the app?

You only have to run this single command, a script will take care of the db creation for test and dev environments and the migrations.
    
```sh
$ docker-compose run app
```

## How to run the test suite?

```sh
$ docker-compose run app bundle exec rspec test/
```

## Gems I'm using and what for

For the test environment: 

- rspec: Behaviour Driven Development for Ruby
- database_cleaner: is a set of gems containing strategies for cleaning your database in Ruby.
- factory_bot: a fixtures replacement gem.

For the dev environment:

- activerecord: To build a persistent domain model by mapping database tables to Ruby classes.
- standalone_migrations: Rails migrations in non-Rails projects.
- sqlite3: To interface with the SQLite3 database engine

### In case you need to create the db or migrate the app

#### How to create the db?

```sh
$ bundle exec rake db:create
```

#### How to migrate the app?

```sh
$ bundle exec rake db:migrate RAILS_ENV=test
$ bundle exec rake db:migrate RAILS_ENV=development
```

