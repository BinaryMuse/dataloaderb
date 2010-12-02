# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "salesforce/data_loader/version"

Gem::Specification.new do |s|
  s.name        = "dataloaderb"
  s.version     = Salesforce::DataLoader::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brandon Tilley"]
  s.email       = ["brandon.tilley@fresno.edu"]
  s.homepage    = ""
  s.summary     = %Q{dataloaderb v#{Salesforce::DataLoader::Version::STRING}}
  s.description = %q{Easily create and run Apex Data Loader processes via Ruby}

  #s.rubyforge_project = "dataloaderb"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
