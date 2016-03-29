# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'electric_eye/version'

Gem::Specification.new do |spec|
  spec.name          = "electric_eye"
  spec.version       = ElectricEye::VERSION
  spec.authors       = ["Michael Pope"]
  spec.email         = ["michael@dtcorp.com.au"]
  spec.summary       = %q{Network Video Recorder}
  spec.description   = %q{A network video recorder for multiple IP cameras which uses VLC to record and organises the files according to date and camera name.}
  spec.homepage      = "https://github.com/map7/electric_eye"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "construct"
  spec.add_runtime_dependency "table_print"
  spec.add_runtime_dependency "open4"
  spec.add_runtime_dependency "filewatcher"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency('rdoc')
  spec.add_development_dependency('aruba')
  spec.add_development_dependency('timecop')
  spec.add_development_dependency('fakefs')
  spec.add_development_dependency('gem-man')
  spec.add_development_dependency('ronn')
  spec.add_dependency('methadone', '~> 1.9.0')
  spec.add_development_dependency('rspec', '~> 2.99')
end
