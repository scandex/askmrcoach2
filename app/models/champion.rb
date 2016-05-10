class Champion
    include Mongoid::Document
    store_in collection: "champs"
    field :key, type: String
    field :name, type: String
    
    def self.testo
        
        pos1=''
        pos2=''
        
        cont = 0
        tb=14
        jb=245
        mb=103
        ab=-1
        sb=412
        tr=157
        jr=35
        mr=105
        ar=202
        sr=16
        
        tb>0 ? cont=+ 1 : cont=+ 0
        jb>0 ? cont=+ 1 : cont=+ 0 
        mb>0 ? cont=+ 1 : cont=+ 0 
        ab>0 ? cont=+ 1 : cont=+ 0 
        sb>0 ? cont=+ 1 : cont=+ 0 
        tr>0 ? cont=+ 1 : cont=+ 0
        jr>0 ? cont=+ 1 : cont=+ 0 
        mr>0 ? cont=+ 1 : cont=+ 0 
        ar>0 ? cont=+ 1 : cont=+ 0 
        sr>0 ? cont=+ 1 : cont=+ 0
        cont = cont/2
        
        if tb<0
             pos1 = '$tb'
             pos2 = '$tr'
        end
        if jb<0
             pos1 = '$jb'
             pos2 = '$jr'
        end
        if mb<0
             pos1 = '$mb'
             pos2 = '$mr'
        end
        if ab<0
             pos1 = '$ab'
             pos2 = '$ar'
        end
        if sb<0
             pos1 = '$sb'
             pos2 = '$sr'
        end
        
        
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
      	                "champ"=> {"$cond"=>[ {"$eq"=>["$team",0]},pos1,pos2]},
      	                "win"=> {"$cond"=>[ {"$eq"=>["$team",0]},{"$subtract"=> ["$wb","$wr"]},{"$subtract"=> ["$wr","$wb"]}]},
                    }
                },
                {
                    "$match"=> {
	                    "simi"=> {"$gte"=>cont}
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
        client = Taric.client(region: :lan)
        blabla= client.champion_mastery_all(summoner_id: 164906)
        resultados = []
        master =[]
        blabla.body.each do |d|
            recom = Recommendation.new(:id=> d["championId"], :performance=> d["championLevel"],:points=>d["championPoints"])
            master<< recom
        end
        master.each do |d|
            results.each do |i|
                if d.id == i.id
                    tempor = Recommendation.new(:id=> d["championId"], :performance=> d.performance*i.performance, :points =>d.points)
                    resultados<< tempor
                    break
                end
            end
        end
        puts master.first.id
        resultados.sort_by! {|a| [a.performance, a.points]}
        resultados.reverse!
    end
end