require 'csv'
namespace :mongo_export_csv do
  task :export_reason => :environment do
    headers = ['mongo_id', 'name', 'priority', 'description'] 
    CSV.open('db/reason.csv', 'wb') do |csv|
      csv <<  headers
      ReasonOfUse.all.each{|reason| csv << [reason.id, reason.name, reason.priority, reason.description] }
    end
  end

  task :to_use_credit_card => :environment do
    headers = ['mongo_id', 'number', 'expiration_month', 'expiration_year' , 'security_code', 'holder' , 'amount' , 'quotes' , 'load_file' , 'date_limit', 'allows_partial_use', 'clarification', 'email', 'authorization_code', 'blocked', 'partial_used', 'used' , 'disabled', 'creator_id', 'creator_name', 'taker_id', 'agency_id', 'consumer' , 'bank_mongodb_id' , 'card_mongodb_id', 'bank_id','credit_card_id','reason_id', 'created_at' , 'updated_at'] 
    CSV.open('db/to_use_credit_card.csv', 'wb') do |csv|
      csv <<  headers
      ToUseCreditCard.all.each do |card| 
        csv << [card.id, card.number, card.expiration_month, card.expiration_year , card.security_code, card.holder , card.amount , card.quotes, card.load_file , card.date_limit, card.allows_partial_use, card.clarification , card.email, card.authorization_code, card.blocked, card.partial_used, card.used , card.disabled, card.creator_id , card.creator_name, card.taker_id, card.agency_id, card.consumer , card.bank_id , card.credit_card_id , 0, 0, card.reason_id , card.created_at , card.updated_at] 
      end
    end
  end

  task :use_data => :environment do
    headers = ['mongo_id', 'to_use_credit_card_id', 'amount', 'user_id' , 'user_name', 'used_file' , 'used_date' , 'es_sale_id' , 'cancel' , 'created_at' , 'updated_at'] 
    CSV.open('db/use_data.csv', 'wb') do |csv|
      csv <<  headers
      ToUseCreditCard.all.each do |card|
        card.use_datas.each do |use| 
          csv << [use.id, card.id, use.amount, use.user_id , use.user_name, use.used_file , use.used_date , use.es_sale_id, use.cancel , use.created_at, use.updated_at ] 
        end
      end
    end
  end  

end 
