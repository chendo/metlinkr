# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "metlinkr/version"

Gem::Specification.new do |s|
  s.name        = "metlinkr"
  s.version     = Metlinkr::VERSION
  s.authors     = ["Jack Chen (chendo)"]
  s.email       = []
  s.homepage    = ""
  s.summary     = %q{Web-scrapin' the Metlink journey planner}
  s.description = %q{A gem to operate the Metlink journey planner}

  s.rubyforge_project = "metlinkr"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_runtime_dependency "capybara-mechanize"
  s.add_runtime_dependency "nokogiri"

end
