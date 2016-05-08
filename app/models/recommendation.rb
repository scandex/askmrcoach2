class Recommendation
    include Mongoid::Document
    field :performance, type: Float
    
    def self.recommend
        tb=14
        jb=245
        mb=103
        ab=81
        sb=412
        tr=157
        jr=35
        mr=105
        ar=202
        sr=16
        db = Mongoid::Clients.default
        collection = db["comps"]
        col = collection.aggregate([
                {
                     "$match"=> {
      	                "$or"=> [ { "$or"=> [ { "tb"=> tb }, { "jb"=> jb },{ "mb"=> mb } ,{ "ab"=> ab },{ "sb"=> sb },{ "tr"=> tr }, { "jr"=> jr }, { "mr"=> mr }, { "ar"=> ar }, { "sr"=> sr }]}, 
      	                { "$or"=> [ { "tb"=> tr }, { "jb"=> jr }, { "mb"=> mr }, { "ab"=> ar }, { "sb"=> sr },{ "tr"=> tb }, { "jr"=> jb }, { "mr"=> mb }, { "ar"=> ab }, { "sr"=> sb } ] } ]	
                    }
                },
                {
                    "$project"=> {
      	                "team"=> {"$cond"=>[ {"$gt"=>[{"$add"=> [ {"$cond"=> [ {"$eq"=> [ "$tb", tb ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$jb", jb ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$mb", mb ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$ab", ab ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$sb", sb ]},1,0]}]},0]},0,1]},
                    	"wr" => 1,
                    	"wb" => 1,
                    	"tb" => 1,
                       	"jb" => 1,
                    	"mb" => 1,
                       	"ab" => 1,
                       	"sb" => 1,
                      	"tr" => 1,
                       	"jr" => 1,
                    	"mr" => 1,
                    	"ar" => 1,
                    	"sr" => 1
                    }
                },
                {
                    "$project"=> {
      	                "simi"=> {"$cond"=>[ {"$eq"=>["$team",0]},
      	                    { "$add"=> [ {"$cond"=> [ {"$eq"=> [ "$tb", tb ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$jb", jb ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$mb", mb ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$ab", ab ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$sb", sb ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$tr", tr ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$jr", jr ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$mr", mr ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$ar", ar ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$sr", sr ]},1,0]}]},
      	                    { "$add"=> [ {"$cond"=> [ {"$eq"=> [ "$tb", tr ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$jb", jr ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$mb", mr ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$ab", ar ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$sb", sr ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$tr", tb ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$jr", jb ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$mr", mb ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$ar", ab ]},1,0]},{"$cond"=> [ {"$eq"=> [ "$sr", sb ]},1,0]}]}
      	                    
      	                ]},
      	                "champ"=> {"$cond"=>[ {"$eq"=>["$team",0]},"$mb","$mr"]},
      	                "win"=> {"$cond"=>[ {"$eq"=>["$team",0]},{"$subtract"=> ["$wb","$wr"]},{"$subtract"=> ["$wr","$wb"]}]},
                    }
                },
                {
                    "$match"=> {
	                    "simi"=> {"$gte"=>5}
                    }
                },
                {
                    "$group"=> {
                        "_id"=>"$champ",  
                        "numerator"=> {"$sum"=> {"$multiply"=>["$simi" , "$win"]}},
                        "denominator"=> {"$sum"=> "$simi"} 
                    }
                },
                {
                    "$project"=> {
      	                "_id"=> 1,		
      	                "performance"=>{"$divide"=>[ "$numerator", "$denominator" ]}	
                    }
                },
                {
                    "$sort"=> {"performance"=>-1}
                }
            ]
        )
        results = col.map { |attrs| Recommendation.instantiate(attrs) }
        puts results.first.id
        puts results.first.performance
    end
end