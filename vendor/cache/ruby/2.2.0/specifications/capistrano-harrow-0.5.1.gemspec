# -*- encoding: utf-8 -*-
# stub: capistrano-harrow 0.5.1 ruby lib

Gem::Specification.new do |s|
  s.name = "capistrano-harrow"
  s.version = "0.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Lee Hambley", "Dario Hamidi"]
  s.bindir = "exe"
  s.date = "2016-05-06"
  s.description = "Hooks to allow people experiencing problems with Capistrano to register with a service to get help and have a smoother workflow."
  s.email = ["leehambley@harrow.io", "dariohamidi@harrow.io"]
  s.homepage = "https://github.com/harrowio/capistrano-harrow"
  s.post_install_message = "\n     ___   _   ___ ___ ___ _____ ___    _   _  _  ___\n    / __| /_\\ | _ \\_ _/ __|_   _| _ \\  /_\\ | \\| |/ _ \\\n   | (__ / _ \\|  _/| |\\__ \\ | | |   / / _ \\| .` | (_) |\n    \\___/_/ \\_\\_| |___|___/ |_| |_|_\\/_/ \\_\\_|\\_|\\___/\n\n    Learn about our web-based collaboration and\n    automation platform for Capistrano: hrw.io/auto-cap\n\n"
  s.rubygems_version = "2.4.5"
  s.summary = "A plugin to improve the user experience for users of Capistrano and Harrow"

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.11"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<minitest>, ["~> 5.0"])
      s.add_development_dependency(%q<pry>, ["= 0.10.3"])
      s.add_development_dependency(%q<json>, ["= 1.8.3"])
      s.add_development_dependency(%q<byebug>, ["= 8.2.4"])
      s.add_development_dependency(%q<sinatra>, ["= 1.4.7"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.11"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<minitest>, ["~> 5.0"])
      s.add_dependency(%q<pry>, ["= 0.10.3"])
      s.add_dependency(%q<json>, ["= 1.8.3"])
      s.add_dependency(%q<byebug>, ["= 8.2.4"])
      s.add_dependency(%q<sinatra>, ["= 1.4.7"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.11"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<minitest>, ["~> 5.0"])
    s.add_dependency(%q<pry>, ["= 0.10.3"])
    s.add_dependency(%q<json>, ["= 1.8.3"])
    s.add_dependency(%q<byebug>, ["= 8.2.4"])
    s.add_dependency(%q<sinatra>, ["= 1.4.7"])
  end
end
