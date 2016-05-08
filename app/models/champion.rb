class Champion
    def self.testo
        db = Mongoid::Clients.default
        collection = db["comps"]
        col = collection.aggregate(
            #{
            #     "$match"=> {
      	    #      "$or" => [ { "$or"=> [ { tb: 39 }, { jb: 121 },{ mb: 121 } ,{ ab: 121 },{ sb: 121 } ] }, { "$or"=> [ { tr: 39 }, { jr: 121 }, { mr: 121 }, { ar: 121 }, { sr: 121 } ] } ],	
            #    }
            #}
            [
            { 
                "$sort" => { matches: -1 }  
            }
           ]
            
        )
        results = col.map { |attrs| Recommendation.instantiate(attrs) }
        puts results.first.id
    end
end