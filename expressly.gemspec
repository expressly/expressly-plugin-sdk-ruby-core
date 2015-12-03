# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "expressly/version"

Gem::Specification.new do |s|
  s.name = "expressly"
  s.version = Expressly::Version::STRING
  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marc G. Smith"]
  s.date = "2015-12-01"
  s.description = "Expressly sdk to help with implementing the expressly e-commerce plug-in / module API"
  s.email = "marc@buyexpressly.com"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files         = `git ls-files`.split("\n")

  s.homepage = "http://developer.buyexpressly.com"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.2"
  s.summary = "Expressly plug-in sdk"

  s.add_development_dependency(%q<bundler>, ["~> 0"])
  s.add_development_dependency(%q<guard-rspec>, ["~> 0"])
  s.add_development_dependency(%q<guard>, ["~> 0"])
  s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
end
