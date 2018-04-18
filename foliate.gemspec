$:.push File.expand_path("../lib", __FILE__)

require "foliate/version"

Gem::Specification.new do |s|
  s.name        = "foliate"
  s.version     = Foliate::VERSION
  s.authors     = ["Jonathan Hefner"]
  s.email       = ["jonathan.hefner@gmail.com"]
  s.homepage    = "https://github.com/jonathanhefner/foliate"
  s.summary     = %q{Rails pagination}
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "yard", "~> 0.9"
end
