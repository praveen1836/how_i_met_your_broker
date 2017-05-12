class Package < ActiveRecord::Base

  # t.string :name, null: false
  # t.string :price
  # t.string :duration
  
  has_many :brokers, :foreign_key => :package_id, dependent: :destroy, :class_name => "Broker"
end
