# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:phone) { |n| "05011111#{n.to_s.rjust(2, '0')}" }
    sequence(:name) { |n| "User #{n}" }
    password { 'qwerty' }
    role { 2 } # default to patient

    trait :admin do
      role { 0 }
    end

    trait :doctor do
      role { 1 }
    end

    trait :patient do
      role { 2 }
    end
  end
end
