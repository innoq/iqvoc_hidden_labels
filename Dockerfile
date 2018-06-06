FROM ruby:2.3

ENV RAILS_ENV production

RUN apt-get update -qq

RUN mkdir -p /iqvoc /iqvoc/gems /iqvoc/home /usr/sbin/.passenger /opt/nginx
RUN chown -R daemon /iqvoc /usr/sbin/.passenger /opt/nginx

WORKDIR /iqvoc
USER daemon

ENV BUNDLE_PATH /iqvoc/gems
ENV HOME /iqvoc/home
RUN gem install bundler && gem install passenger && exec passenger-install-nginx-module
COPY --chown=daemon Gemfile Gemfile.lock ./
RUN bundle install --without development test

COPY --chown=daemon . /iqvoc
#COPY --chown=daemon public/assets/. /iqvoc/public/assets

RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD bundle exec rake db:migrate && bin/delayed_job start && exec bundle exec passenger start --port 3000