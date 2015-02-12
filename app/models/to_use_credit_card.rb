class ToUseCreditCard
  include Mongoid::Document
  include Mongoid::Timestamps

  field :number, type: String
  field :expiration_month, type: String
  field :expiration_year, type: String
  field :security_code, type: String
  field :holder, type: String
  field :amount, type: BigDecimal
  field :load_file, type: Integer
  field :blocked, type: Boolean

  #To can use  rails g bootstrap:themed ToUseCreditCards
  def self.columns
  	self.fields.collect{|c| c[1]}
  end
end
