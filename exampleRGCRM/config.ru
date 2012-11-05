require 'bundler'
require 'faker'

Bundler.require

# Rack::CoreData requires a Sequel connection to a database
DB = Sequel.connect(ENV['DATABASE_URL'] || "postgres://localhost:5432/core_data_clients")

run Rack::CoreData('./RGCRM.xcdatamodel')

def wipe_db
	Rack::CoreData::Models::Client.each do |client|
		puts client
		client.delete
	end

	Rack::CoreData::Models::Contact.each do |contact|
		puts contact
		contact.delete
	end
end


wipe_db


if Rack::CoreData::Models::Client.count < 100

	(0..5).each do
		name    = Faker::Company.name
		country = Faker::Address.country
		client = Rack::CoreData::Models::Client.create(name: name,  country: country)

		(0..3).each do
			first_name = Faker::Name.first_name
			last_name = Faker::Name.last_name
			phone = Faker::PhoneNumber.phone_number
			contact = Rack::CoreData::Models::Contact.create(firstName:first_name, lastName:last_name, phone: phone, clients: client) 
		end

		
		
	end
end
