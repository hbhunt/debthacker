FactoryGirl.define do
	factory :user do
		name									"Brad Hunt"
		email 								"brad@example.com"
		password							"foobar"
		password_confirmation "foobar"
	end
end