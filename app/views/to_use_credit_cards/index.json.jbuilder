json.array!(@to_use_credit_cards) do |to_use_credit_card|
  json.extract! to_use_credit_card, :id, :number, :expiration_month, :expiration_year, :security_code, :holder, :amount, :load_file, :blocked
  json.url to_use_credit_card_url(to_use_credit_card, format: :json)
end
