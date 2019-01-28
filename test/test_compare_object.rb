require "./lib/mongo_inspired_compare.rb"

def expect( val, criterion, to_return )
  
  puts "> MongoInspiredCompare.compare_object( #{ val.inspect }, #{ criterion} )"
  puts "=> #{ actually_returned = MongoInspiredCompare.compare_object( val, criterion) }\n\n"
  
  puts "===================== expected #{ to_return }" unless to_return == actually_returned
end


puts "\n## Basic Comparisons"
expect( {name: "Creatinine", value: 2.2 }, {name: "Creatinine", value: {"$gt" => 1.5}}, true)

expect( {name: "Creatinine", value: 2.2 }, {name: "Potassium", value: {"$lt" => 3}}, false)

expect( {name: "Creatinine", value: "INVALID" }, {name: "Creatinine", value: {"$in" => ["INVALID", {"$lt" => 3}]}}, true)
