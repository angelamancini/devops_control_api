FROM ruby:2.3-slim

MAINTAINER Angela Mancini <angela.mancini@sage.com>

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
      build-essential nodejs libpq-dev git libcurl4-openssl-dev

ENV INSTALL_PATH /api

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile.lock ./

RUN bundle install --binstubs

COPY . .

VOLUME ["$INSTALL_PATH/public"]

CMD bundle exec unicorn -c config/unicorn.rb
