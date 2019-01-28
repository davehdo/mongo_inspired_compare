class MongoInspiredCompare

  ## 
  # Takes a value and a comparitor and returns true or false
  #
  # === Basic Comparisons
  # > MongoInspiredCompare.compare( 5, 5 )
  # => true
  #
  # > MongoInspiredCompare.compare( 5, 6 )
  # => false
  #
  #
  # === Basic Operators
  # > MongoInspiredCompare.compare( 5, {"$gte"=>5} )
  # => true
  #
  # > MongoInspiredCompare.compare( 5, {"$lt"=>5} )
  # => false
  #
  # > MongoInspiredCompare.compare( 5, {"$in"=>[1, 2, 3, 4, 5]} )
  # /Users/daviddo/Documents/mongo_inspired_compare/lib/mongo_inspired_compare.rb:13: warning: constant ::Fixnum is deprecated
  # => true
  #
  # > MongoInspiredCompare.compare( 5, {"$nin"=>[1, 2, 3, 4, 5]} )
  # => false
  #
  #
  # === Nesting
  # > MongoInspiredCompare.compare( 5, {"$in"=>[{"$lt"=>5}, {"$gte"=>5}]} )
  # => true
  #
  #
  # === And/or Operators
  # > MongoInspiredCompare.compare( 5, {"$or"=>[{"$lt"=>5}, {"$gte"=>5}]} )
  # => true
  #
  # > MongoInspiredCompare.compare( 5, {"$and"=>[{"$lt"=>5}, {"$gte"=>5}]} )
  # => false
  #
  #
  # === Invariance
  # > MongoInspiredCompare.compare( "5", {"$gte"=>5} )
  # => true
  #
  # > MongoInspiredCompare.compare( "5x", {"$gte"=>5} )
  # => false

  def self.compare( val, criterion ) 
    if criterion.class != Hash
      val == criterion
    else
      # v might look like { "$gte" => 12, "$lt" => 1 }
      criterion.all? do |oper,v2|
        if (v2.class == Float or v2.class == Integer or v2.class == Fixnum) and val.class == String
          num_val = numerical(val)
        else
          num_val = val
        end
      
        if oper == "$in" # "$in" => [">4000", {"$gt" => -100 }]
          v2.any? {|v3| compare( val, v3)}
        elsif oper == "$nin" # "$in" => [">4000", {"$gt" => -100 }]
          !v2.any? {|v3| compare( val, v3)}
        elsif oper == "$or"
          v2.any? {|v3| compare( val, v3)}
        elsif oper == "$and"
          v2.all? {|v3| compare( val, v3)}
        elsif num_val == nil
          false
        elsif oper == "$gte"
          num_val >= v2
        elsif oper == "$gt"
          num_val > v2
        elsif oper == "$lte"
          num_val <= v2
        elsif oper == "$lt"
          num_val < v2
        else
          raise "Error: unknown operator #{ oper }"
        end
      end
    end
  end
  
  
  def self.compare_object( obj, filter )
    filter.all? {|k,v| MongoInspiredCompare.compare( obj[k], v)}
  end
  
  private
  def self.numerical( str )
    (str and str.strip =~ /^[\-\d\.]+$/) ? str.to_f : nil
  end
end