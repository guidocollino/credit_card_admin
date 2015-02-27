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

  field :blocked, type: Boolean, default: false
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
                         :bank, :credit_card, :quotes
  validates_numericality_of :number, :security_code, :load_file, only_integer: true
  validates_length_of :load_file, minimum: 6, maximum: 6

  scope :takeds, -> (taker_id) { enableds.not_used.where(blocked: true,taker_id: taker_id) }
  scope :to_use, -> {enableds.not_taked.not_used}
  scope :useds, -> { where(used: true) }
  scope :not_used, -> {where(used: false)}
  scope :not_taked, -> {where(blocked: false)}
  scope :enableds, -> {where(disabled: false)}
  scope :disableds, -> {where(disabled: true)}

  #SINO MONGOID NO CARGA EL VALOR Y NO ANDAN BIEN LOS SCOPE
  after_create :initialize_flags

  def initialize_flags
    self.blocked = false
    self.used = false
    self.disabled = false
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

  def used_amount
    puts "tc: #{self.id}"
    total = 0
    puts "total: #{total}"
    self.use_datas.each { |ud| total += ud.amount }
    puts "total despues de sumar: #{total}"
    return total
  end

  def cant_use_amount
    amount - used_amount
  end

  #Eventos

  def take(user)
    update_attributes(blocked: true, taker_id: user.id)
  end

  def free
    update_attributes(blocked: false, taker_id: nil)
  end

  def use(file, amount_to_use, date = Date.today)
    self.use_datas << UseData.new(amount: amount_to_use, used_file: file)
    self.save
    unless used_amount < self.amount
      update_attributes(used: true)
    end
  end

  def reuse
    update_attributes(used: false)
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
