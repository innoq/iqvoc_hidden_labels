require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Iqvoc::OeRK
  class Application < Rails::Application
    require 'iqvoc_oerk'

    config.time_zone = 'Berlin'
    config.encoding = 'utf-8'
    config.assets.version = '1.0'

    config.active_record.raise_in_transactional_callbacks = true
  end
end
