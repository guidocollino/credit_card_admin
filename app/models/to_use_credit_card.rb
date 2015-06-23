class ToUseCreditCard < ActiveRecord::Base
 # belongs_to :bank
 # belongs_to :credit_card
 belongs_to :reason, class_name: "ReasonOfUse", foreign_key: "reason_id"
 has_many :use_datas

 validates :number, :expiration_month, :expiration_year,:security_code, :load_file, :holder, :amount,
 :bank_id,  :quotes, :agency_id, :reason, :date_limit,  presence: true
 validates :number, :security_code, :load_file, numericality: { only_integer: true }
 validates :load_file, length: { minimum: 3  , maximum: 6}
 validates :amount , numericality: { message: "debe ser un numero, utilizar el punto para separar la parte entera de la decimal   " }

 scope :takeds, -> (taker_id) { enableds.not_used.where(blocked: true,taker_id: taker_id) }
 scope :to_use, -> {enableds.not_taked.not_used}
 scope :useds, -> { where(used: true) }
 scope :not_used, -> {where(used: false)}
 # scope :partial_useds, -> {any_of({partial_used: true}, {used: true})}
 scope :partial_useds, -> {where("partial_used = true  or used = true " )}
 scope :not_taked, -> {where(blocked: false)}
 scope :enableds, -> {where(disabled: false)}
 scope :disableds, -> {where(disabled: true)}

  #SINO MONGOID NO CARGA EL VALOR Y NO ANDAN BIEN LOS SCOPE
  after_create :initialize_flags

  #Quita los espacios del numero de tarjeta
  before_validation :delete_blank

  # def as_json(options={})
  #   super(
  #     {:include => [{ :bank => {:only => :name} , :reason => {:only => :name}}],
  #     :methods => [:expiration_text, :cant_use_amount]}
  #   )
  # end
  

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
  # def self.columns
  #   self.fields.collect{|c| c[1]}
  #   self.columns.collect{|c| c[1]}
  # end

  def complete_number_text
    "#{number}/#{security_code}"
  end

  #Metodos para usar la API de bank
  def bank
    @bank ||= Bank.find self.bank_id unless self.bank_id.blank?
  end

  def credit_card
    @credit_card ||= CreditCard.find self.credit_card_id unless self.credit_card_id.blank?
  end

  #MM/YY
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

  #monto usado
  def used_amount
    total = 0
    self.use_datas.valids.each { |ud| total += ud.amount }
    return total
  end

  def cant_use_amount
    amount.to_f - used_amount.to_f
  end
#Validaciones

def valid_use(file,amount_to_use)
  valid = true
  if used? then
   errors.add(:base, "La tarjeta ya fue usada")
   valid = false
 else
  if amount_to_use.blank? then
    errors.add(:base, "El monto es obligatorio")
    valid = false
  else
    valid_amount = cant_use_amount
    if amount_to_use.to_f > valid_amount then
      errors.add(:base, "El monto debe ser menor al que tiene para usar #{valid_amount}")
      valid = false
    end
  end
end
return valid
end
  #Elimina los espacios del numero de tarjeta
  def delete_blank
    self.number=self.number.delete(' ')
  end

  #Eventos

  def take(user)
    update(blocked: true, taker_id: user.id)
  end

  def free
    update(blocked: false, taker_id: nil)
  end

  def use(amount_to_use, user_data, es_sale_id = nil, file = nil, date = Date.today)
    use = UseData.new(amount: amount_to_use, 
      used_file: file, 
      user_id: user_data.id, 
      user_name: user_data.name_and_surname,
      es_sale_id: es_sale_id)
    self.use_datas << use
    self.save

    unless used_amount < self.amount
      update(used: true)
    else
      update(partial_used:  true)
    end

    #Enviar notificacion si tiene mail/s cargado/s
    NotificationUses.notify_use(use).deliver unless self.email.blank?
  end

  def reuse(data_use_id)
    use = (self.use_datas.valids).find(data_use_id)
    unless use.nil?
      use.update(cancel: true)
      self.update(blocked: false,used: false, partial_used: (self.use_datas.valids.size > 0)) 
      return true
    end
    return false
  end

  def disable
    update(used: false, disabled: true)
  end

  def enable(user)
    update(disabled: false, taker_id: user.id)
  end

  def bank_name
    return bank.nil? ? "" : bank.name
  end

  def credit_card_name
    return credit_card.nil? ? "" : credit_card.name
  end

  def authorized?
    !self.authorization_code.blank?
  end

  #PARA LA API(no funciona bien con el ?)
  def authorized
    !self.authorization_code.blank?
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
