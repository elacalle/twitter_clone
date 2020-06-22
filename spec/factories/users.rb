FactoryBot.define do
  factory :user do
    name { 'Name' }
    email { 'example@example.com' }
    password { '12345678' }
    password_confirmation { '12345678' }
    activated { true }
  end

  trait :lana do
    name { 'Lana' }
    email { 'lana@example.com' }
  end

  trait :archer do
    name { 'Archer' }
    email { 'archer@example.com' }
  end

  trait :michael do
    name { 'Michael' }
    email { 'michael@example.com' }
  end
end
