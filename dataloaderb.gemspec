# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "dataloaderb/version"

Gem::Specification.new do |s|
  s.name         = "dataloaderb"
  s.version      = Dataloaderb::Version::STRING
  s.platform     = Gem::Platform::RUBY
  s.license      = 'MIT'
  s.authors      = ["Brandon Tilley"]
  s.email        = ["brandon.tilley@fresno.edu"]
  s.homepage     = "https://github.com/FPU/dataloaderb"
  s.summary      = %q{Easily create, run, and extend Apex Data Loader processes on Windows via Ruby}
  s.description  = %q{Easily create, run, and extend Apex Data Loader processes on Windows via Ruby}
  s.requirements << 'Ruby on Windows (since this is the only supported platform for the Apex Data Loader)'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
