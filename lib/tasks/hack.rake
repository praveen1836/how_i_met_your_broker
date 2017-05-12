namespace :hack do

  require 'wombat'

  def get_product_ids
    a = Wombat.crawl do
      base_url "http://www.99acres.com/rent-property-in-powai-central-mumbai-suburbs-ffid?page_no=#{page_no}"
      path "/"
      product_ids "xpath=//*[@id='results']/div/div/@data-propid", :list
    end
    a["product_ids"]
  end

  def store_broker_details details, id 
    params = {}
    b_details = details["eCommTrackData"].first
    params[:locality] = b_details["locality"]
    params[:product_id] = id
    params[:package_type] = b_details["product_type"]
    params[:city_name] = b_details["city"]
    params[:company_name] =  "99acres"
    params[:name] = details["advertiserDetails"][0]["OwnerName"]
    params[:phone_number] = details["advertiserDetails"][0]["OwnerMobile"]
    broker = Broker.new(params)
    broker.save!
  end

  def get_product_details product_id
    url = "https://www.99acres.com/99api/v12/addeoi/733f5e4816a8ebb4e4d5d1c969420c1e2f8a375a2854e4a760d4cab00280317444378a608f2a2249950e54537b4e191eaebf5dede0a64d3dfb623d0ab83142af/?rtype=json?&prop_id=#{product_id}&phone=1-3526143845&SOURCE_L1=C2V&rtype=json&AppVersion=6.4.0&identityRadio=I&_vis_mail=&profileid=23890123&email=gvos@tralalajos.gq&GOOGLE_SEARCH_ID=570532684477724403&share_mobile_info=Y&clientId=570532684477724403&AppVersionCode=60&SOURCE_L2=PROPERTY&visitorid=570532684477724403&name=Prats&owner_profile_id=11594041"
    response = Net::HTTP.get_response(URI.parse(url))
    JSON.parse(response.body)
  end

  task :start => :environment do 

    page_no = 1
    broker_count = 0

    while(1) do 

      product_ids = get_product_ids
      product_ids.each do |id|
        #product type != "Free Listing"
        details = get_product_details(id)
        if details["eCommTrackData"][0]["product_type"] != "Free Listing"
          store_broker_details(details, id)
          puts "saved brokers #{broker_count += 1}"
        end
      end
      page_no += 1
      break if page_no > 10
    end
  end

end 
