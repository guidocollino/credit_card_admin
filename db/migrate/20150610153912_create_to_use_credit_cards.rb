class CreateToUseCreditCards < ActiveRecord::Migration
  def change
    create_table :to_use_credit_cards do |t|
      t.string :number
      t.string :expiration_month
      t.string :expiration_year
      t.string :security_code
      t.string :holder
      t.float :amount
      t.integer :quotes
      t.integer :load_file
      t.date :date_limit
      t.boolean :allows_partial_use , default: false
      t.string :clarification
      t.string :email
      t.string :authorization_code
      t.boolean :blocked , default: false
      t.boolean :partial_used, default: false
      t.boolean :used , default: false
      t.boolean :disabled , default: false
      t.integer :creator_id
      t.string :creator_name
      t.integer :taker_id
      t.integer :agency_id
      t.string :consumer
      t.integer :bank_id
      t.string  :bank_mongodb_id
      t.integer :credit_card_id
      t.string  :card_mongodb_id
      t.integer :reason_id
      t.string :mongo_id

      t.timestamps
    end
  end
end
 