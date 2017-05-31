require "simplecov"
SimpleCov.start
require 'bundler/setup'
require 'interstate'
require_relative '../examples/vehicle/vehicle.rb'

Dir[File.join(File.dirname(__FILE__), '/examples/**/*.rb')].each { |f| require f }
