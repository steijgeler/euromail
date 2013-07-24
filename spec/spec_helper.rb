require 'euromail'
require 'simplecov'
require 'simplecov-rcov'

SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter

if ENV["COVERAGE"]
  SimpleCov.start do
    add_filter "/spec/"
  end
end