# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_format/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_format"
  spec.version       = SimpleFormat::VERSION
  spec.authors       = ["Howl王"]
  spec.email         = ["howl.wong@gmail.com"]
  spec.summary       = %q{Returns text transformed into HTML using simple formatting rules.}
  spec.homepage      = "https://github.com/mimosa/simple_format/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "multi_json"
  spec.add_dependency "sanitize"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
