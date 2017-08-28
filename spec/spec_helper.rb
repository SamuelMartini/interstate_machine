require 'simplecov'
SimpleCov.start
require 'bundler/setup'
require 'byebug'
require 'active_record'
require 'interstate_machine'

Dir[File.dirname(__FILE__) + '/models/**/*.rb'].sort.each { |f| require File.expand_path(f) }

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: ':memory:'

load File.dirname(__FILE__) + '/schema.rb'
