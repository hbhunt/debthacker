FactoryGirl.define do
	factory :user do
		sequence(:name)				{ |n| "Person #{n}"}
		sequence(:email)			{ |n| "person_#{n}@example.com"}
		password					"foobar"
		password_confirmation 		"foobar"
		institution_type			"public"
		has_graduated				true
		has_full_time_employment 	true

		factory :admin do
			admin true
		end

		trait :red do
			institution_type 			"for-profit"
			has_graduated 	 			false
			has_full_time_employment	false
		end

		trait :yellow do
			has_full_time_employment 	false			
		end

		factory :red_user, traits: [:red]
		factory :yellow_user, traits: [:yellow]

	end

	factory :micropost do
		content "Lorem ipsum"
		user
	end
end