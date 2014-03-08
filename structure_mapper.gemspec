# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'structure_mapper/version'

Gem::Specification.new do |spec|
  spec.name          = "structure_mapper"
  spec.version       = StructureMapper::VERSION
  spec.authors       = ["Dragan Milic"]
  spec.email         = ["dragan@netice9.com"]
  spec.summary       = %q{Mapper of data structures (Hash, Array, ... ) to ruby objects.}
  spec.description   = %q{Mapper of data structures (Hash, Array, ... ) to ruby objects.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14.1"
  spec.add_development_dependency "autotest", "~> 4.4.6"
  spec.add_development_dependency "simplecov"
end
