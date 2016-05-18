FROM ruby:2.3.0
WORKDIR /usr/src/app
ADD . /usr/src/app
ENV BUNDLE_PATH /bundle
RUN bundle install
