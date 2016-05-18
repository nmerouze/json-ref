# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'json_ref/version'

Gem::Specification.new do |spec|
  spec.name          = "json-ref"
  spec.version       = JSONRef::VERSION
  spec.authors       = ["Nicolas Mérouze"]
  spec.email         = ["nicolas@merouze.me"]
  spec.description   = %q{An implementation of JSON Ref.}
  spec.summary       = %q{An implementation of JSON Ref.}
  spec.homepage      = "https://github.com/nmerouze/json-ref"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_dependency "hana"
end
