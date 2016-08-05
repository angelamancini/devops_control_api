FROM centos:latest
MAINTAINER Angela Mancini

EXPOSE 3000

ADD Gemfile /app/
ADD Gemfile.lock /app/

RUN yum -y update && yum clean all
RUN yum -y install openssl openssl-devel libyaml-devel libxml2 limxml2-devel libxslt-devel gcc zlib-devel rpm-build curl curl-devel gcc-g++ gcc-c++ libstdc++-devel mysql-devel

# install ruby 2.3.1
ADD https://github.com/erumble/ruby-rpm/releases/download/2.3.1/ruby-2.3.1-1.el7.centos.x86_64.rpm /tmp

RUN rpm -i /tmp/ruby-2.3.1-1.el7.centos.x86_64.rpm

# bundle install
RUN gem install bundler && \
    cd /app ; bundle config build.nokogiri --use-system-libraries && bundle install --without development test

ADD . /app

ENV RAILS_ENV production
WORKDIR /app

CMD ["bundle", "exec", "rails", "s", "-p", "3000"]
