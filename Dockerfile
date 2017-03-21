FROM ruby:2.3.3


### DEPENDENCIES ###

# RUN apt-get update && apt-get install -y \
#   less


### PREPARE ###

# Don't install doc for ruby gems
RUN echo 'gem: --no-rdoc --no-ri' > /etc/gemrc

RUN mkdir /app
WORKDIR /app

# copy over Gemfile and install bundle
ADD Gemfile .
ADD brreg_grunndata.gemspec .
ADD lib/brreg_grunndata/version.rb /app/lib/brreg_grunndata/version.rb

RUN bundle install --jobs 20 --retry 5

COPY . .