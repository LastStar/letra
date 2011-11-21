# Encoding: UTF-8

Gem::Specification.new do |s|
  s.platform          = Gem::Platform::RUBY
  s.name              = %q{letra}
  s.version           = '0.2'
  s.description       = %q{Convert fonts}
  s.summary           = %q{Built for easy webfonts converting}
  s.email             = %q{retro@ballgag.cz}
  s.homepage          = %q{http://github.com/simi/letra}
  s.authors           = ['Josef Šimánek']
  s.license           = %q{MIT}
  s.require_paths     = %w(lib)
  
  s.files             = `git ls-files -- lib/*`.split("\n")
  
  s.add_dependency    'bundler',                    '~> 1.0'
end
