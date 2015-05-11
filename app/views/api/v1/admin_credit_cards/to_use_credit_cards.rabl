collection @credit_cards, :object_root => false
attributes :id, :expiration_month, :amount, :expiration_year, :bank_id, :credit_card_id, :quotes, :agency_id, :reason_id, :use_datas, :date_limit, :clarification, :authorization_code
child(:reason) { attributes :name }
node(:bank) { |cc| cc.bank_name }
node(:expiration_text) { |cc| cc.expiration_text }
node(:credit_card) { |cc| cc.credit_card_name }
node(:cant_use_amount) { |cc| cc.cant_use_amount }
node(:agency_name) { |cc| cc.agency_name }
node(:authorized) { |cc| cc.authorized? }
