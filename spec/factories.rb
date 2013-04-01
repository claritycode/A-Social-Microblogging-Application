FactoryGirl.define do
	factory :user do
		sequence(:name) { |n| "Person#{n}" }
		sequence(:email) { |n| "Person#{n}@parthpatel.org" }
		sequence(:username) { |n| "Ps#{n}" }
		password "charusat"
		password_confirmation "charusat"

		factory :admin do
			admin true
		end
	end

	factory :micropost do
		content "Lorem ipsum"
		user
	end

	factory :favorite do
		user
		micropost
	end
end
