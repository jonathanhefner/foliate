$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "foliate/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "foliate"
  s.version     = Foliate::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Foliate."
  s.description = "TODO: Description of Foliate."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.4"

  s.add_development_dependency "sqlite3"
end
