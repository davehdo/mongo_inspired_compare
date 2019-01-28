Gem::Specification.new do |s|
  s.name        = 'mongo_inspired_compare'
  s.version     = '0.0.2'
  s.date        = '2019-01-28'
  s.summary     = "When creating a rules engine for dealing with large amounts of numeric data (like clinical data e.g. laboratory and flowsheet values), it can advantageous to abstract away the rules rather than to hard-code them. Mongo queries offer a clear, compact syntax that can encode complex rules and be stored as JSON. This gem offers a simple way to compare values against criteria written in a Mongo-inspired syntax."
  s.description = "A simple library for comparing values against criteria written in a Mongo-inspired syntax"
  s.authors     = ["David Do"]
  s.files       = ["lib/mongo_inspired_compare.rb", "test_mongo_inspired_compare.rb"]
  s.license       = 'MIT'
end