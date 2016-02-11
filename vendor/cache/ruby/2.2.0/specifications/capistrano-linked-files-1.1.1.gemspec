# -*- encoding: utf-8 -*-
# stub: capistrano-linked-files 1.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "capistrano-linked-files"
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Runar Skaare Tveiten"]
  s.date = "2015-05-14"
  s.description = "Adds tasks to upload your linked files and directories. "
  s.email = ["runar@tveiten.io"]
  s.homepage = "https://github.com/runar/capistrano-linked-files"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.5"
  s.summary = "Upload linked files and directories."

  s.installed_by_version = "2.4.5" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<capistrano>, ["~> 3.1"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<capistrano>, ["~> 3.1"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<capistrano>, ["~> 3.1"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
