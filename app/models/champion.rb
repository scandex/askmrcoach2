class Champion
    include Mongoid::Document
    store_in collection: "champs"
    field :key, type: String
    field :name, type: String
    
    def self.testo
        client = Taric.client(region: :lan)
        user_id =client.summoners_by_names(summoner_names: user).body.first[1]["id"]
        blabla= client.champion_mastery_all(summoner_id: user_id)
        puts blabla.body
    end
end