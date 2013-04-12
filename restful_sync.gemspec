$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "restful_sync/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "restful_sync"
  s.version     = RestfulSync::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of RestfulSync."
  s.description = "TODO: Description of RestfulSync."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.0"
  s.add_dependency "nestful", ">= 1.0.0.rc2"
  s.add_dependency 'draper', '~> 1.0'

  s.add_development_dependency "sqlite3"
end
