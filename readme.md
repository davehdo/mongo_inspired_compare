# Introduction
When creating a rules engine for dealing with large amounts of numeric data (like clinical data e.g. laboratory and flowsheet values), it can advantageous to abstract away the rules rather than to hard-code them. Mongo queries offer a clear, compact syntax that can encode complex rules and be stored as JSON. This gem offers a simple way to compare values against criteria written in a Mongo-inspired syntax.
 

# Examples
## Compare Object
### Basic Comparisons
```
> MongoInspiredCompare.compare_object( {:name=>"Creatinine", :value=>2.2}, {:name=>"Creatinine", :value=>{"$gt"=>1.5}} )
=> true

> MongoInspiredCompare.compare_object( {:name=>"Creatinine", :value=>2.2}, {:name=>"Potassium", :value=>{"$lt"=>3}} )
=> false

> MongoInspiredCompare.compare_object( {:name=>"Creatinine", :value=>"INVALID"}, {:name=>"Creatinine", :value=>{"$in"=>["INVALID", {"$lt"=>3}]}} )
=> true
```


### And/Or Operators
```
> array_of_criteria = [{:name=>"Creatinine", :value=>{"$gt"=>1.5}}, {:name=>"Potassium", :value=>{"$lt"=>3}}]

> MongoInspiredCompare.compare_object( {:name=>"Creatinine", :value=>2.2}, {"$and"=>array_of_criteria} )
=> false

> MongoInspiredCompare.compare_object( {:name=>"Creatinine", :value=>2.2}, {"$or"=>array_of_criteria} )
=> true

> MongoInspiredCompare.compare_object( {:name=>"Creatinine", :value=>2.2, :drawn_by=>"Bob"}, {:name=>"Creatinine", "$or"=>[{:value=>{"$gt"=>2.5}}, {:drawn_by=>"Bob", :value=>{"$gt"=>2.0}}]} )
=> true
```

## Compare Value
### Basic Comparisons
```
> MongoInspiredCompare.compare( 5, 5 )
=> true

> MongoInspiredCompare.compare( 5, 6 )
=> false
```

### Basic Operators
```
> MongoInspiredCompare.compare( 5, {"$gte"=>5} )
=> true

> MongoInspiredCompare.compare( 5, {"$lt"=>5} )
=> false

> MongoInspiredCompare.compare( 5, {"$in"=>[1, 2, 3, 4, 5]} )
=> true

> MongoInspiredCompare.compare( 5, {"$nin"=>[1, 2, 3, 4, 5]} )
=> false
```

### Nesting
```
> MongoInspiredCompare.compare( 5, {"$in"=>[{"$lt"=>5}, {"$gte"=>5}]} )
=> true
```

### And/or operators do not exist when comparing a single value

#### Use $in when you want to match any one of the criteria
```
> MongoInspiredCompare.compare( 5, {"$in"=>[{"$lt"=>5}, {"$gte"=>5}]} )
=> true

> MongoInspiredCompare.compare( 5, {"$in"=>[{"$lt"=>3}, {"$gte"=>7}]} )
=> false
```

#### Use a single object if you want to match all of the criteria
```
> MongoInspiredCompare.compare( 5, {"$lt"=>5, "$gte"=>5} )
=> false

> MongoInspiredCompare.compare( 5, {"$lt"=>15, "$gte"=>3} )
=> true
```


### Invariance
```
> MongoInspiredCompare.compare( "5", {"$gte"=>5} )
=> true

> MongoInspiredCompare.compare( "5x", {"$gte"=>5} )
=> false
```