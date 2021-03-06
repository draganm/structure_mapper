#!/usr/bin/env ruby
require 'json'
require 'structure_mapper'
require 'pp'

data = '''
{
  "name": "rails",
  "downloads": 32904409,
  "version": "4.0.3",
  "version_downloads": 154351,
  "platform": "ruby",
  "authors": "David Heinemeier Hansson",
  "info": "Ruby on Rails is a full-stack web framework optimized for programmer happiness and sustainable productivity. It encourages beautiful code by favoring convention over configuration.",
  "licenses": [
    "MIT"
  ],
  "project_uri": "http://rubygems.org/gems/rails",
  "gem_uri": "http://rubygems.org/gems/rails-4.0.3.gem",
  "homepage_uri": "http://www.rubyonrails.org",
  "wiki_uri": "http://wiki.rubyonrails.org",
  "documentation_uri": "http://api.rubyonrails.org",
  "mailing_list_uri": "http://groups.google.com/group/rubyonrails-talk",
  "source_code_uri": "http://github.com/rails/rails",
  "bug_tracker_uri": "http://github.com/rails/rails/issues",
  "dependencies": {
    "development": [],
    "runtime": [
      {
        "name": "actionmailer",
        "requirements": "= 4.0.3"
      },
      {
        "name": "actionpack",
        "requirements": "= 4.0.3"
      },
      {
        "name": "activerecord",
        "requirements": "= 4.0.3"
      },
      {
        "name": "activesupport",
        "requirements": "= 4.0.3"
      },
      {
        "name": "bundler",
        "requirements": "< 2.0, >= 1.3.0"
      },
      {
        "name": "railties",
        "requirements": "= 4.0.3"
      },
      {
        "name": "sprockets-rails",
        "requirements": "~> 2.0.0"
      }
    ]
  }

}
'''

class Dependency
  include StructureMapper::Hash
  attribute name: String
  attribute requirements: String
end

class RubyGemInfo
  include StructureMapper::Hash
  attribute name: String
  attribute downloads: Fixnum
  attribute version: String
  attribute version_downloads: Fixnum
  attribute platform: String
  attribute authors: String
  attribute info: String
  attribute licenses: []
  attribute project_uri: String
  attribute gem_uri: String
  attribute homepage_uri: String
  attribute wiki_uri: String
  attribute documentation_uri: String
  attribute mailing_list_uri: String
  attribute source_code_uri: String
  attribute bug_tracker_uri: String
  attribute dependencies: {String => [Dependency]}
end

struct=JSON.parse data
info=RubyGemInfo.from_structure struct
from_info=info.to_structure

puts "structures are equal" if from_info == struct

