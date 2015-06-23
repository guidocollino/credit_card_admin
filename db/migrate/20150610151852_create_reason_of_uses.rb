class CreateReasonOfUses < ActiveRecord::Migration
  def change
    create_table :reason_of_uses do |t|
      t.string :name
      t.integer :priority
      t.string :description
      t.string :mongo_id

      t.timestamps
    end
  end
end
