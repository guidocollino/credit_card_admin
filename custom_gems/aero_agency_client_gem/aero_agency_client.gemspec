# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aero_agency_client/version'

Gem::Specification.new do |spec|
  spec.name          = "aero_agency_client"
  spec.version       = AeroAgencyClient::VERSION
  spec.authors       = ["Ivan Karl"]
  spec.email         = ["ivan6258@gmail.com"]
  spec.summary       = %q{API Client gem for aero Agency manager rest service}
  # spec.description   = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # Production dependencies
  spec.add_dependency 'activeresource', '~> 4.0.0'
  # Development dependencies
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
