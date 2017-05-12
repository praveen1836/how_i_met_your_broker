class CreateBrokers < ActiveRecord::Migration
  def change
    create_table :brokers do |t|
      t.string :phone_number
      t.string :name
      t.string :company_name
      t.string :city_name
      t.string :locality
      t.string :package_type
      t.string :product_id
      t.timestamps null: false
    end
  end
end
