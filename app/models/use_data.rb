class UseData
  include Mongoid::Document
  include Mongoid::Timestamps
  include ActionView::Helpers::NumberHelper

  field :amount, type: BigDecimal
  field :user_id, type: Integer
  field :user_name, type: String
  field :used_file, type: Integer
  field :used_date, type: Date

  field :cancel, type: Boolean, default: false

  scope :valids, -> {where(cancel: false)}
  scope :canceled, -> {where(cancel: true)}

  embedded_in :to_use_credit_card

  delegate :agency_name, :complete_number_text, :expiration_text, :holder, :bank, :credit_card, to: :to_use_credit_card, allow_nil: true

  #SINO MONGOID NO CARGA EL VALOR Y NO ANDAN BIEN LOS SCOPE
  after_create :initialize_flags

  def initialize_flags
    self.cancel = false
  end 

  def descriptive_amount
  	des_amount = number_with_precision(amount, precision: 2, separator: ',', strip_insignificant_zeros: true, delimiter: '.')
  	if amount == self.to_use_credit_card.amount then
  		return des_amount
  	else
  		total_des_amount = number_with_precision(self.to_use_credit_card.amount, precision: 2, separator: ',', strip_insignificant_zeros: true, delimiter: '.')
  		return "#{des_amount} de #{total_des_amount}"
    end
  end
  
end
