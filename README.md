# TODO app

####Dependencies: docker

## How to run the app?
    - docker-compose build
    - docker-compose up
    
## How to migrate the app?

- bundle exec rake db:migrate RAILS_ENV=test
- bundle exec rake db:migrate RAILS_ENV=development