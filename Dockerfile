FROM ruby:2.5.8
RUN apt-get update -qq && apt-get install -y build-essential mariadb-client nodejs

RUN mkdir /myapp
WORKDIR /myapp
ADD src/Gemfile /myapp/Gemfile
ADD src/Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
ADD src /myapp
