require "./lib/mongo_inspired_compare.rb"

def expect( val, criterion, to_return )
  
  puts "> MongoInspiredCompare.compare( #{ val.inspect }, #{ criterion} )"
  puts "=> #{ actually_returned = MongoInspiredCompare.compare( val, criterion) }\n\n"
  
  puts "===================== expected #{ to_return }" unless to_return == actually_returned
end


puts "\n## Basic Comparisons"
expect( 5, 5, true)

expect( 5, 6, false)


puts "\n## Basic Operators"
expect( 5, {"$gte" => 5}, true)

expect( 5, {"$lt" => 5}, false)

expect( 5, {"$in" => [1, 2, 3, 4, 5]}, true)

expect( 5, {"$nin" => [1, 2, 3, 4, 5]}, false)

puts "\n## Nesting"

expect( 5, {"$in" => [{"$lt" => 5}, {"$gte" => 5}]}, true)

puts "\n## And/or Operators do not exist when comparing a single value"
puts "\n### Use $in when you want to match any one of the criteria"
expect( 5, {"$in" => [{"$lt" => 5}, {"$gte" => 5}]}, true)

expect( 5, {"$in" => [{"$lt" => 3}, {"$gte" => 7}]}, false)

puts "\n### Use a single object if you want to match all of the criteria"
expect( 5, {"$lt" => 5, "$gte" => 5}, false)

expect( 5, {"$lt" => 15, "$gte" => 3}, true)


puts "\n## Invariance"
expect( "5", {"$gte" => 5}, true)

expect( "5x", {"$gte" => 5}, false)


