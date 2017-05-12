class Property < ActiveRecord::Base

  # t.string :property_id, null: false
  # t.integer :broker_id, null: false, index: true

  belongs_to :broker, :foreign_key => :broker_id, :class_name => "Broker"

  validates_uniqueness_of :property_id, :scope => :broker_id
end
