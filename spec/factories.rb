FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "foo#{n}@county.org" }
    password "password"
    password_confirmation "password"

    county
    job_classification

    factory :admin do
      admin true
    end
  end

  factory :survey do
    sequence(:name) { |n| "Example survey #{n}" }
  end

  factory :activity_log do
  	survey
  	user
    start_date 0.days.ago
  end

  factory :log_entry do
    activity_log
    sequence(:date) { |n| n.days.from_now }
  end

  factory :county do
    sequence(:name) { |n| "Example survey #{n}" }
  end

  factory :job_classification do
    sequence(:name) { |n| "Job #{n}" }
  end
end