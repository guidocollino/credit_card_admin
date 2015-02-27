class CreditCard
  include Mongoid::Document
  include Mongoid::Timestamps
  #store_in collection: "credit_cards", database: "promotions_development", session: "promotions"
  store_in session: "promotions"
  
  field :name, type: String
  field :quantity_digits, type: Integer
  field :bin_start, type: Integer
  field :quantity_code_security, type: Integer

  attr_readonly :name, :quantity_digits, :bin_start, :quantity_code_security

end
