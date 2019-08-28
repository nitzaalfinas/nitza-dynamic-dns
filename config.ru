require 'rubygems'
require 'bundler'
require_relative "_env"

Bundler.require

require './main'

run Sinatra::Application
