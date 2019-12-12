FROM ruby:alpine

MAINTAINER Xavi Vega <xabi1309@gmail.com>

RUN apk add --no-cache build-base bash sqlite sqlite-dev sqlite-libs && \
    gem install bundler sqlite3 --no-document

WORKDIR /usr/src/todo_app

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN bundle install


EXPOSE 9292