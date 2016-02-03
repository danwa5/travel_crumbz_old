== README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


# Install and run MongoDB

1. Update Homebrew’s package database: brew update
2. Install MongoDB: brew install mongodb
3. Create data directory: mkdir -p /data/db
4. Run mongodb: sudo mongod

NOTE: http://docs.mongodb.org/master/tutorial/install-mongodb-on-os-x/

To show current running services: brew services list
To start mongodb: brew services start mongodb
To stop mongodb if it's already running: brew services stop mongodb