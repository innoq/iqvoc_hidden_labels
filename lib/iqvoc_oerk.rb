require 'iqvoc/oerk/version'

module IqvocOeRK

  unless Iqvoc.const_defined?(:OeRK) && Iqvoc::OeRK.const_defined?(:Application)
    require File.join(File.dirname(__FILE__), '../config/engine')
  end

  ActiveSupport.on_load(:after_iqvoc_config) do
    require 'iqvoc'
  end

end
