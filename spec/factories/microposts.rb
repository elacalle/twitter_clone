FactoryBot.define do
  factory :micropost do
    content { Faker::Quote }

    trait :ants do
      content { 'Oh, is that what you want? Because that\'s how you get ants!' }
      created_at { 2.years.ago }
    end

    trait :zone do
      content { 'Danger zone.' }
      created_at { 3.days.ago }
    end

    trait :tone do
      content { 'I\'m sorry. Your words made sense, but your sarcastic tone did not.' }
      created_at { 10.minutes.ago }
    end

    trait :van do
      content { 'Dude, this van\'s, like, rolling probable cause.' }
      created_at { 4.hours.ago }
    end

    trait :orange do
      created_at { 10.minutes.ago }
    end

    trait :tau_manifesto do
      created_at { 3.years.ago }
    end

    trait :cat_video do
      created_at { 2.hours.ago }
    end

    trait :most_recent do
      created_at { Time.zone.now }
    end
  end
end
