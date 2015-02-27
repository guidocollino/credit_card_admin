class UseData
  include Mongoid::Document
  include Mongoid::Timestamps

  field :amount, type: BigDecimal
  field :user_id, type: Integer
  field :used_file, type: Integer
  field :used_date, type: Date

  embedded_in :to_use_credit_card
end
