require 'active_model/railtie'
require 'passrock'
require 'dotenv'

Dotenv.load

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../'))

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end



# Helpers

def passrock_password_db
  ENV['PASSROCK_PASSWORD_DB']
end

def passrock_private_key
  ENV['PASSROCK_PRIVATE_KEY']
end
