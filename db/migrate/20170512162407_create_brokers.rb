class CreateBrokers < ActiveRecord::Migration
  def change
    create_table :brokers do |t|
      t.string :phone_number, null: false, index: true
      t.string :name, null: false
      t.string :company_name
      t.string :city
      t.string :locality
      t.string :package_id
      t.boolean :is_subscribed
      t.datetime :subscribed_at
      t.datetime :unsubscribed_at
      t.timestamps null: false
    end
  end
end
