require 'iqvoc/environments/development'

if Iqvoc::OeRK.const_defined?(:Application)
  Iqvoc::OeRK::Application.configure do
    Iqvoc::Environments.setup_production(config)
  end
end