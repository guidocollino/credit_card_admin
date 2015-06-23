require 'csv'
namespace :mysql_import do
  task :reason => :environment do
    error=[]
    file = "db/reason.csv"
    CSV.foreach(file , :headers => true) do |row|
      if ! ReasonOfUse.create(row.to_h).valid?
        error << row.to_h['mongo_id']
      end
    end
    if error.empty?
      p 'Los datos se ingresaron correctamente'
    else
      p "Se produjeron los siguienes errores #{error} " 
    end
  end

  task :to_use_credit_card => :environment do
    file = "db/to_use_credit_card.csv"
    error=[]
    CSV.foreach(file , :headers => true) do |row|
      reason=ReasonOfUse.find_by(mongo_id: row.to_h["reason_id"])
      to_use_credit_card=row.to_h
      to_use_credit_card["reason_id"]=reason.id
      if ! ToUseCreditCard.create(to_use_credit_card).valid?
        error << row.to_h["mongo_id"]
      end
    end
    if error.empty?
      p "Los datos se ingresaron correctamente"
    else
      p "Se produjeron errores en los siguientes mongo_id #{error}"
    end
  end

  task :use_data => :environment do
    file = "db/use_data.csv"
    error=[]
    CSV.foreach(file , :headers => true) do |row|
      to_use_credit_card=ToUseCreditCard.find_by(mongo_id: row.to_h["credit_card_mongodb_id"])
      use_data=row.to_h
      if to_use_credit_card.nil?
        error << row.to_h["credit_card_mongodb_id"]
      else
        use_data["to_use_credit_card_id"]=to_use_credit_card.id
        UseData.create(use_data)
      end
      
    end
    if error.empty?
      p "Los datos se ingresaron correctamente"
    else
      p "Se produjeron errores en los siguientes mongo_id #{error}"
    end
  end

  task :update_bank_mongodb_id => :environment do  
    banks=Bank.all
    ToUseCreditCard.all.each do |to_use_credit_card|
      to_use_credit_card.bank_id = banks.detect { |bank| bank.mongodb_id == to_use_credit_card.bank_mongodb_id  }.id
      to_use_credit_card.save
    end
  end

  task :update_card_mongodb_id => :environment do  
    error=[]
    cards=CreditCard.all
    ToUseCreditCard.all.each do |to_use_credit_card|
      card= cards.detect { |card| card.mongodb_id == to_use_credit_card.card_mongodb_id  }
      if card.nil?
        to_use_credit_card.credit_card_id = ""
      else
        to_use_credit_card.credit_card_id= card.id
      end
      to_use_credit_card.save   
    end
  end


end