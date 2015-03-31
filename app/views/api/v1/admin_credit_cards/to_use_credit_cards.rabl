collection @credit_cards, :object_root => false
attributes :id, :expiration_month, :amount, :expiration_year, :bank_id, :credit_card_id, :quotes, :agency_id, :reason_id, :use_datas, :date_limit, :clarification
child(:bank) { attributes :name }
child(:reason) { attributes :name }
child(:credit_card) { attributes :name }
node(:expiration_text) { |cc| cc.expiration_text }
node(:cant_use_amount) { |cc| cc.cant_use_amount }
node(:agency_name) { |cc| cc.agency_name }