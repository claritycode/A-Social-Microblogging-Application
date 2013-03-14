namespace :db do 
	desc "Fill in the database with sampel users"
	task populate: :environment do
	admin = User.create!(name: "Example user",
				email: "example@sampleapp.com",
				username: "us",
				password: "project",
				password_confirmation: "project")
	
	admin.toggle!(:admin)

		99.times do |n|
			name = Faker::Name.name
	      	email = "example-#{n+1}@sampleapp.com"
	      	username = "us#{n+1}"
	      	password  = "password"
	      	User.create!(name: name,
	                   	email: email,
	                   	username: username,
	                   	password: password,
	                   	password_confirmation: password)
		end
	end
end