# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'interstate_machine/version'

Gem::Specification.new do |spec|
  spec.name          = "interstate_machine"
  spec.version       = InterstateMachine::VERSION
  spec.authors       = ["SamuelMartini"]
  spec.email         = ["samueljmartini@gmail.com"]

  spec.summary       = 'a state machine with interactor implementation'
  spec.description   = 'InterstateMachine is a simple state machine which use interactors to trigger transitions'
  spec.homepage      = 'https://github.com/SamuelMartini/interstate_machine'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "interactor", "~> 3.1"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.6"
  spec.add_development_dependency 'byebug', "~> 9.1"
  spec.add_development_dependency 'activerecord', "~> 5.1"
  spec.add_development_dependency "sqlite3", "~> 1.3"
  spec.add_development_dependency 'simplecov', "~> 0.15"
  spec.add_development_dependency 'simplecov-console', "~> 0.4.2"
end
