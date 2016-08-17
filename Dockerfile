FROM centos:14.04
FROM ruby: 2.0.0

EXPOSE 3000
ENV RUBY_MAJOR 2.2
ENV RUBY_VERSION 2.3.1
ENV RUBY_DOWNLOAD_SHA256 4a7c5f52f205203ea0328ca8e1963a7a88cf1f7f0e246f857d595b209eac0a4d
ENV RUBYGEMS_VERSION 2.6.6

# skip installing gem documentation
RUN echo 'install: --no-document\nupdate: --no-document' >> "$HOME/.gemrc"
# some of ruby's build scripts are written in ruby
# we purge this later to make sure our final image uses what we just built
RUN yum update \
  && yum install -y bison libgdbm-devl ruby \
  && mkdir -p /usr/src/ruby \
  && curl -fSL -o ruby.tar.gz "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz" \
  && echo "$RUBY_DOWNLOAD_SHA256 *ruby.tar.gz" | sha256sum -c - \
  && tar -xzf ruby.tar.gz -C /usr/src/ruby --strip-components=1 \
  && rm ruby.tar.gz \
  && cd /usr/src/ruby \
  && autoconf \
  && ./configure --disable-install-doc \
  && make -j"$(nproc)" \
  && make install \
  && yum remove -y --auto-remove bison libgdbm-dev ruby \
  && gem update --system $RUBYGEMS_VERSION \
  && rm -r /usr/src/ruby

  # install things globally, for great justice
  ENV GEM_HOME /usr/local/bundle
  ENV PATH $GEM_HOME/bin:$PATH
  ENV BUNDLER_VERSION 1.10.6
  RUN gem install bundler --version "$BUNDLER_VERSION" \
    && bundle config --global path "$GEM_HOME" \
    && bundle config --global bin "$GEM_HOME/bin"
  # don't create ".bundle" in all our apps
  ENV BUNDLE_APP_CONFIG $GEM_HOME
  RUN mkdir -p /usr/src/app
  COPY . /usr/src/app
  WORKDIR /usr/src/app
  RUN gem install bundler && bundle install --jobs 20 --retry 5
  CMD ["bin/bundle", "exec", "puma", "-p", "3000"]
