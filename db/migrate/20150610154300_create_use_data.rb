class CreateUseData < ActiveRecord::Migration
  def change
    create_table :use_data do |t|
      t.references :to_use_credit_card, index: true
      t.float :amount
      t.integer :user_id
      t.string :user_name
      t.integer :used_file
      t.date :used_date
      t.integer :es_sale_id
      t.boolean :cancel , default: false
      t.string :mongo_id
      t.string :credit_card_mongodb_id
    
      t.timestamps
    end
  end
end
