FactoryGirl.define do
	factory :user do
		sequence(:name) { |n| "Person#{n}" }
		sequence(:email) { |n| "Person#{n}@sampleapp.com" }
		sequence(:username) { |n| "Ps#{n}" }
		password "charusat"
		password_confirmation "charusat"
	end
end