class Champion
    include Mongoid::Document
    store_in collection: "champs"
    field :key, type: String
    field :name, type: String
    
    def self.testo
        client = Taric.client(region: :lan)
        #user_id =client.summoners_by_names(summoner_names: user).body.first[1]["id"]
        blabla= client.champion_mastery_all(summoner_id: 164906)
        resultados = []
        master =[]
        puts blabla.body
        blabla.body.each do |d|
            puts d["championId"].body 
            puts d["championLevel"]
            puts d["championPoints"]
            recom = Recommendation.new(:id=> d["championId"], :performance=> d["championLevel"] , :points=> d["championPoints"])
            master<< recom
        end
        puts master[0]
    end
end