require 'euromail'
require 'sftp_mock'
require 'simplecov'
require 'simplecov-rcov'

SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter

if ENV["COVERAGE"]
  SimpleCov.start do
    add_filter "/spec/"
  end
end

RSpec::Mocks.configuration.allow_message_expectations_on_nil = true