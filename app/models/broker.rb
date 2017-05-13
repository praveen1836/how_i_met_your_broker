class Broker < ActiveRecord::Base
require 'csv'
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

  validates_presence_of :phone_number
  validates_uniqueness_of :phone_number


  def handle_unsubscription
    self.is_subscribed = false
    self.unsubscribed_at = Time.now
  end

  def handle_subscription
    self.is_subscribed = true
    self.subscribed_at = Time.now
  end

  def self.analytics
    q = "select count(*) as group_count, packages.name, #{filter_city} as city_name " 
    q += "from brokers  inner join packages on packages.id = (brokers.package_id)::int group by "
    q += " #{filter_city}, packages.name"
    results = Broker.connection.execute(q).as_json
  end

  def self.filter_city
    q = " case when city LIKE '%Mumbai%'  then 'Mumbai' "
    q += " when city LIKE '%Mira%'  then 'Mumbai' "
    q += " when city LIKE '%Bangalore%'  then 'Bangalore' "
    q += " when city LIKE '%Chennai%'  then 'Chennai' "
    q += " when city LIKE '%Kolkata%'  then 'Kolkata' "
    q += " when city LIKE '%Hyderabad%'  then 'Hyderabad' end "
    return q
  end

  def city_name
    if city =~ /Mumbai/
      "Mumbai"
    elsif city =~ /Mira/
      "Mumbai"
    elsif city =~ /Bangalore/
      "Bangalore"
    elsif city =~ /Chennai/
      "Chennai"
    elsif city =~ /Kolkata/
      "Kolkata"
    elsif city =~ /Hyderabad/
      "Hyderabad"
    end 
  end

  def self.export_csv
    CSV.open("#{Rails.root}/99acres_broker_details.csv", "w") do |csv|
      Broker.all.each do |b|
        csv << [b.phone_number.sub("91-","").split(",").first,  b.name, b.city_name, b.locality, Package.find(b.package_id).name]
      end
    end
    
  end


end
