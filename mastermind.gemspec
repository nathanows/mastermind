# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mastermind/version'

Gem::Specification.new do |spec|
  spec.name          = "mastermind-nowsiany"
  spec.version       = Mastermind::VERSION
  spec.authors       = ["Nathan Owsiany"]
  spec.email         = ["nowsiany@gmail.com"]
  spec.summary       = %q{Command Line Mastermind}
  spec.description   = %q{Play Mastermind through your command line... with multiplayer support.}
  spec.homepage      = "https://github.com/ndwhtlssthr/mastermind"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "colorize", "~> 0.7"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "guard", "~> 2.8"
  spec.add_development_dependency "guard-rspec", "~> 4.3"
end
