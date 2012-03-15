# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "letra/version"

Gem::Specification.new do |s|
  s.name        = "letra"
  s.version     = Letra::VERSION
  s.authors     = ["Josef Šimánek"]
  s.email       = ["retro@ballgag.cz"]
  s.homepage    = ""
  s.summary     = %q{Simple Fontforge Python wrapper for Ruby}
  s.description = %q{Just few operations yet}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_runtime_dependency "rubypython"
  s.add_runtime_dependency "reot"
  s.add_development_dependency "guard-minitest"
  s.add_development_dependency "guard-ctags-bundler"
end
