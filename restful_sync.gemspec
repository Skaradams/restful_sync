$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "restful_sync/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "restful_sync"
  s.version     = RestfulSync::VERSION
  s.authors     = ["Valentin Ballestrino", "Damien Corticchiato"]
  s.email       = ["vala@glyph.fr", "damien@glyph.fr"]
  s.homepage    = "http://www.glyph.fr"
  s.summary     = "Two-sided Restful API"
  s.description = "Restful API with observers that call a mirror API"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.0"
  s.add_dependency "nestful", ">= 1.0.0.rc2"
  s.add_dependency 'draper', '~> 1.0'

  s.add_development_dependency "sqlite3"
end
