namespace :db do 
	desc "Fill in the database with sampel users"
	task populate: :environment do
		make_users
		make_microposts
		make_relationships
		make_favorites		
	end
end

	def make_users
		admin = User.create!(name: "Example user",
				email: "project@parthpatel.org",
				username: "us",
				password: "project8",
				password_confirmation: "project8")
	
	admin.toggle!(:admin)
	admin.activate!

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
	end

	def make_microposts
		users = User.all(limit: 6)
		50.times do 
			content = Faker::Lorem.sentence(5)
			users.each { |user| user.microposts.create!(content: content) }
		end
	end

	def make_relationships
		users = User.all
		user = users.first
		followed_users = users[2..50]
		followers = users[3..40]
		followed_users.each { |followed| user.follow!(followed) }
  		followers.each      { |follower| follower.follow!(user) }
	end

	def make_favorites
		users = User.all(limit: 6)
		users.each do |user1|
			users.each do |user2|
				user1.favorite!(user2.microposts.first)
			end
		end
	end