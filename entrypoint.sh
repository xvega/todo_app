#!/bin/bash
set -e

bundle exec rake db:create

bundle exec rake db:migrate RAILS_ENV=test
bundle exec rake db:migrate RAILS_ENV=development


exec "$@"