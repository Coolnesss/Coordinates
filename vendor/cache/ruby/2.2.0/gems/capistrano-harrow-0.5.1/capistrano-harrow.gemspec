# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/harrow/version'
require 'capistrano/harrow/banner'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-harrow"
  spec.version       = Capistrano::Harrow::VERSION
  spec.authors       = ["Lee Hambley", "Dario Hamidi"]
  spec.email         = ["leehambley@harrow.io", "dariohamidi@harrow.io"]

  spec.summary       = %q{A plugin to improve the user experience for users of Capistrano and Harrow}
  spec.description   = %q{Hooks to allow people experiencing problems with Capistrano to register with a service to get help and have a smoother workflow.}
  spec.homepage      = "https://github.com/harrowio/capistrano-harrow"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.post_install_message = Capistrano::Harrow::Banner.new.to_s

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "pry", "0.10.3"
  spec.add_development_dependency "json", "1.8.3"
  spec.add_development_dependency "byebug", "8.2.4"
  spec.add_development_dependency "sinatra", "1.4.7"
end
