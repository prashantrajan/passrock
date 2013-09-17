require 'passrock'
require 'benchmark'
require 'dotenv'

Dotenv.load

PROJECT_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../'))

passrock_db = Passrock::PasswordDb.new(:password_db => ENV['PASSROCK_PASSWORD_DB'], :private_key => ENV['PASSROCK_PRIVATE_KEY'])

Benchmark.bm do |x|
  x.report("#find_by_binary_search\n") { puts "Password secure? #{passrock_db.secure?('password')}" }
end
