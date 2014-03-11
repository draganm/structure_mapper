require 'json'
require 'simplecov'
SimpleCov.start
require 'structure_mapper'
if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
end
