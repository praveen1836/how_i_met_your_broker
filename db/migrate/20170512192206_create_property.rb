class CreateProperty < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :property_id, null: false
      t.integer :broker_id, null: false, index: true
    end
  end
end
