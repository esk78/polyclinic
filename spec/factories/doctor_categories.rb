# frozen_string_literal: true

FactoryBot.define do
  factory :doctor_category do
    sequence(:name) { |n| "Category #{n}" }
  end
end
