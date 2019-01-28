Introduction
When creating a rules engine for dealing with large amounts of numeric data (like clinical data e.g. laboratory and flowsheet values), it can advantageous to abstract away the rules rather than to hard-code them. Mongo queries offer a clear, compact syntax that can encode complex rules and be stored as JSON. This gem offers a simple way to compare values against criteria written in a Mongo-inspired syntax.
 

Examples
## Basic Comparisons
```
> MongoInspiredCompare.compare( 5, 5 )
=> true

> MongoInspiredCompare.compare( 5, 6 )
=> false
```

## Basic Operators
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

## Nesting
```
> MongoInspiredCompare.compare( 5, {"$in"=>[{"$lt"=>5}, {"$gte"=>5}]} )
=> true
```

## And/or Operators
```
> MongoInspiredCompare.compare( 5, {"$or"=>[{"$lt"=>5}, {"$gte"=>5}]} )
=> true

> MongoInspiredCompare.compare( 5, {"$and"=>[{"$lt"=>5}, {"$gte"=>5}]} )
=> false
```

## Invariance
```
> MongoInspiredCompare.compare( "5", {"$gte"=>5} )
=> true

> MongoInspiredCompare.compare( "5x", {"$gte"=>5} )
=> false
```