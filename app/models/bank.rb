class Bank
  include Mongoid::Document
  include Mongoid::Timestamps
  #store_in collection: "banks", database: "promotions_development", session: "promotions"
  store_in session: "promotions"
  
  field :name, type: String

  attr_readonly :name, :type

  #has_many :to_use_credit_cards

end
