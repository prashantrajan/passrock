module Passrock
  class Railtie < ::Rails::Railtie

    # Add load paths straight to I18n so engines and application can overwrite it.
    require 'active_support/i18n'
    I18n.load_path << File.join(File.dirname(__FILE__), '..', '..', 'locales', 'en.yml')

  end
end

