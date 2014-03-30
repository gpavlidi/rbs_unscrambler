# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rbs_unscrambler/version'

Gem::Specification.new do |spec|
  spec.name          = "rbs_unscrambler"
  spec.version       = RbsUnscrambler::VERSION
  spec.authors       = ["Yanis Pavlidis"]
  spec.email         = ["pavlidis.yanis@gmail.com"]
  spec.description   = %q{Unscramble Sketchup .rbs files}
  spec.summary       = %q{Simple script to unscramble Sketchup encrypted .rbs files}
  spec.homepage      = "https://github.com/gpavlidi/rbs_unscrambler"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development "crypt19-rb"
end
