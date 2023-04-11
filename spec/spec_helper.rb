require 'bundler/setup'
require 'dried_interaction'
require 'dried_interaction/error'

require "#{File.dirname(__FILE__)}/support/test_strict_interactor.rb"
require "#{File.dirname(__FILE__)}/support/test_soft_interactor.rb"
require "#{File.dirname(__FILE__)}/support/custom_schema_interactor.rb"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
