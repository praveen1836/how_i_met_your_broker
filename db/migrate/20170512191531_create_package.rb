class CreatePackage < ActiveRecord::Migration
  def change
    create_table :packages do |t|
      t.string :name, null: false
      t.string :price
      t.string :duration
    end
  end
end
