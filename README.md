[![Build Status](https://travis-ci.org/draganm/structure_mapper.png?branch=master)](https://travis-ci.org/draganm/structure_mapper) 
[![Gem Version](https://badge.fury.io/rb/structure_mapper.png)](http://badge.fury.io/rb/structure_mapper)
[![Code Climate](https://codeclimate.com/github/draganm/structure_mapper.png)](https://codeclimate.com/github/draganm/structure_mapper)
[![Coverage Status](https://coveralls.io/repos/draganm/structure_mapper/badge.png)](https://coveralls.io/r/draganm/structure_mapper)

# StructureMapper

Structure mapper is a generic mapper of nested data structures (Hash, Array, ...) to ruby objects using very simple but powerful syntax. Unlike other mappers that are tightly coupled with persistence (ActiceRecord, Mongomapper), StructureMapper does only one thing, but does it well.

## Installation

Add this line to your application's Gemfile:

    gem 'structure_mapper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install structure_mapper

## Usage

    require 'structure_mapper'

    class MappedObject
      
      include StructureMapper::Hash

      attribute test: String
    end

    mapped=MappedObject.from_structure({'test' => 'some value'})
    mapped.test       # 'some value'
    mapped.to_structure  # {'test' => 'some value'}

## Example for Parsing JSON and Mapping to Objects

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

    info=RubyGemInfo.from_structure(JSON.parse data)



## Contributing

1. Fork it ( http://github.com/<my-github-username>/structure_mapper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
