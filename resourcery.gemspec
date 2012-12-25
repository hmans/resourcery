$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "resourcery/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "resourcery"
  s.version     = Resourcery::VERSION
  s.authors     = ["Hendrik Mans"]
  s.email       = ["hendrik@mans.de"]
  s.homepage    = "http://github.com/hmans/resourcery"
  s.summary     = "Simple serving of RESTful resources."
  s.description = "Simple serving of RESTful resources."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.1"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails', '>= 2.8.0'
  s.add_development_dependency 'factory_girl_rails'
end
