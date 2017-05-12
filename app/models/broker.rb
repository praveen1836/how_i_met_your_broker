class Broker < ActiveRecord::Base

  # t.string :phone_number, null: false, index: true
  # t.string :name, null: false
  # t.string :company_name
  # t.string :city
  # t.string :locality
  # t.string :package_id
  # t.boolean :is_subscribed
  # t.datetime :subscribed_at
  # t.datetime :unsubscribed_at
  # t.timestamps null: false

  has_many :properties, :foreign_key => :broker_id, dependent: :destroy, :class_name => "Property"
  belongs_to :package, :foreign_key => :package_id, :class_name => "Package"

  validates_uniqueness_of :phone_number
end
