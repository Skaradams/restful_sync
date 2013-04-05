$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "glysellin_parent_api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "glysellin_parent_api"
  s.version     = GlysellinParentApi::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of GlysellinParentApi."
  s.description = "TODO: Description of GlysellinParentApi."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.0"
  s.add_dependency "nestful"

  s.add_development_dependency "sqlite3"
end
