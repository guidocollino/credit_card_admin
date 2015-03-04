class ToUseCreditCard
  include Mongoid::Document
  include Mongoid::Timestamps

  field :number, type: String
  field :expiration_month, type: String
  field :expiration_year, type: String
  field :security_code, type: String
  field :holder, type: String
  field :amount, type: BigDecimal
  field :quotes, type: Integer
  field :load_file, type: Integer
  field :date_limit, type: Date
  field :allows_partial_use, type: Boolean, default: false


  field :blocked, type: Boolean, default: false
  field :partial_used, type: Boolean, default: false
  field :used, type: Boolean, default: false
  field :disabled, type: Boolean, default: false

  field :creator_id, type: Integer
  field :creator_name, type: String
  field :taker_id, type: Integer

  field :agency_id, type: Integer

  belongs_to :bank
  belongs_to :credit_card
  belongs_to :reason, class_name: "ReasonOfUse", foreign_key: "reason_id"
  embeds_many :use_datas

  validates_presence_of :number, :expiration_month, :expiration_year,:security_code, :load_file, :holder, :amount,
                         :bank, :credit_card, :quotes, :agency_id, :reason
  validates_numericality_of :number, :security_code, :load_file, only_integer: true
  validates_length_of :load_file, minimum: 6, maximum: 6

  scope :takeds, -> (taker_id) { enableds.not_used.where(blocked: true,taker_id: taker_id) }
  scope :to_use, -> {enableds.not_taked.not_used}
  scope :useds, -> { where(used: true) }
  scope :not_used, -> {where(used: false)}
  scope :partial_useds, -> {any_of({partial_used: true}, {used: true})}
  scope :not_taked, -> {where(blocked: false)}
  scope :enableds, -> {where(disabled: false)}
  scope :disableds, -> {where(disabled: true)}

  #SINO MONGOID NO CARGA EL VALOR Y NO ANDAN BIEN LOS SCOPE
  after_create :initialize_flags

  def initialize_flags
    self.blocked = false
    self.used = false
    self.disabled = false
    self.partial_used = false
  end 

  def print_errors
    errors.full_messages.join(", ")
  end

  def self.all_uses
    result = self.partial_useds.inject([]) { |uses, tc| uses.concat(tc.use_datas.valids.entries) }
    #result.nil? ? [] : result
  end

  #To can use  rails g bootstrap:themed ToUseCreditCards
  def self.columns
  	self.fields.collect{|c| c[1]}
  end

  def complete_number_text
    "#{number}/#{security_code}"
  end

  def expiration_text
    "0#{expiration_month}/#{expiration_year.last(2)}"
  end

  def overcome?
    result = false
    unless date_limit.blank?
      week_after = Date.today + 7.days
      result = date_limit <= week_after 
    end
    return result
  end

  def used_amount
    total = 0
    self.use_datas.valids.each { |ud| total += ud.amount }
    return total
  end

  def cant_use_amount
    amount - used_amount
  end

  #Validaciones

  def valid_use(file,amount_to_use)
    valid = true
    if amount_to_use.blank? || file.blank? then
      errors.add(:base, "El file y el monto son obligatorios")
      valid = false
    else
      valid_amount = cant_use_amount
      if amount_to_use.to_f > valid_amount then
        errors.add(:base, "El monto debe ser menor al que tiene para usar #{valid_amount}")
        valid = false
      end
    end
    return valid
  end

  #Eventos

  def take(user)
    update_attributes(blocked: true, taker_id: user.id)
  end

  def free
    update_attributes(blocked: false, taker_id: nil)
  end

  def use(file, amount_to_use, user_data, date = Date.today)
    self.use_datas << UseData.new(amount: amount_to_use, used_file: file, user_id: user_data.id, user_name: user_data.name_and_surname)
    self.save
    unless used_amount < self.amount
      update_attributes(used: true)
    else
      update_attributes(partial_used: true)
    end
  end

  def reuse(data_use_id)
    use = (self.use_datas.valids).find(data_use_id)
    unless use.nil?
      use.update_attributes(cancel: true)
      self.update_attributes(used: false, partial_used: (self.use_datas.valids.size > 0)) 
      return true
    end
    return false
  end

  def disable
    update_attributes(used: false, disabled: true)
  end

  def enable(user)
    update_attributes(disabled: false, taker_id: user.id)
  end

  ##################
  ## Agency Stuff ##
  ##################
  def agency
    ::AeroAPI::Agency.find(agency_id) unless agency_id.blank?
  end

  def agency_name
    ::AeroAPI::Agency.exists?(agency_id) ? agency.name.chomp.strip : 'No Agency'
  end
end
