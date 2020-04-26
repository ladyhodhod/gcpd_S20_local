require 'simplecov'
SimpleCov.start 'rails' do
  add_filter "lib/tasks/"
  add_filter "lib/helpers/"
  add_filter "lib/exceptions.rb"
  add_filter "lib/app_helpers.rb"
  add_filter "app/channels/application_cable/"
  add_filter "app/jobs/"
  add_filter "app/mailers/"
end
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest"
require 'minitest/rails'
require 'minitest/reporters'
require 'minitest_extensions'
require 'contexts'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # Commented out b/c screwing with reporter
  # parallelize(workers: :number_of_processors)

  # Add more helper methods to be used by all tests here...
  include Contexts

  # Add the infamous deny method...
  def deny(condition, msg="")
    # a simple transformation to increase readability IMO
    assert !condition, msg
  end

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
        with.test_framework :minitest
        with.library :rails
    end
  end



   # Methods to login in an officer of different ranks to start things off
   def login_commish
    @hq = FactoryBot.create(:unit, name: "Headquarters")
    @jgordon = FactoryBot.create(:officer, unit: @hq, first_name: "Jim", last_name: "Gordon", username: "jgordon", role: "commish")
    get login_path
    post sessions_path, params: { username: "jgordon", password: "secret" }
  end

  def login_chief
    @homicide = FactoryBot.create(:unit, name: "Homicide")
    @msawyer  = FactoryBot.create(:officer, unit: @homicide, first_name: "Maggie", last_name: "Sawyer", username: "msawyer", role: "chief")
    get login_path
    post sessions_path, params: { username: "msawyer", password: "secret" }
  end

  def login_officer
    @homicide = FactoryBot.create(:unit, name: "Homicide")
    @jblake   = FactoryBot.create(:officer, unit: @homicide, first_name: "John", last_name: "Blake", username: "jblake", role: "officer")
    get login_path
    post sessions_path, params: { username: "jblake", password: "secret" }
  end
  # Spruce up minitest results...
  Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

end
