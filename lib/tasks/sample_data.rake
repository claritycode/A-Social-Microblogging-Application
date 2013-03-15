namespace :db do 
	desc "Fill in the database with sampel users"
	task populate: :environment do
	admin = User.create!(name: "Example user",
				email: "project@parthpatel.org",
				username: "us",
				password: "project8",
				password_confirmation: "project8")
	
	admin.toggle!(:admin)

		99.times do |n|
			name = Faker::Name.name
	      	email = "example-#{n+1}@parthpatel.org"
	      	username = "us#{n+1}"
	      	password  = "password"
	      	User.create!(name: name,
	                   	email: email,
	                   	username: username,
	                   	password: password,
	                   	password_confirmation: password)
		end

		users = User.all(limit: 6)
		50.times do 
			content = Faker::Lorem.sentence(5)
			users.each { |user| user.microposts.create!(content: content) }
		end
	end
end