FROM ruby:alpine

MAINTAINER Xavi Vega <xabi1309@gmail.com>

RUN apk add --no-cache build-base bash sqlite sqlite-dev sqlite-libs && \
    gem install bundler --no-document

WORKDIR /usr/src/todo_app

COPY Gemfile .
COPY Gemfile.lock .

RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 9292
