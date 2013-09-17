require 'passrock/version'
require 'passrock/exceptions'
require 'passrock/configuration'
require 'passrock/password_db_finder'
require 'passrock/password_db'

require 'passrock/railtie' if defined?(::Rails::Railtie)
require 'active_model/validations/passrock_secure_validator' if defined?(::ActiveModel)

module Passrock

  class << self

    def configuration
      @configuration ||= Configuration.new
    end

    def configure(&block)
      yield(configuration)
      configuration
    end

    def reset_configuration!
      @configuration = nil
    end

  end

end
