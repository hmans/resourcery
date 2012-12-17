$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "resourcery/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "resourcery"
  s.version     = Resourcery::VERSION
  s.authors     = ["Hendrik Mans"]
  s.email       = ["hendrik@mans.de"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Resourcery."
  s.description = "TODO: Description of Resourcery."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.1"

  # s.add_development_dependency "sqlite3"
end
