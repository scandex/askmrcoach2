class Recommendation
    include Mongoid::Document
    field :performance, type: Float
    field :points, type: Float
end