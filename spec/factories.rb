FactoryGirl.define do
	factory :user do
		name									"Brad Hunt"
		email 								"user@example.com"
		password							"foobar"
		password_confirmation "foobar"
	end
end