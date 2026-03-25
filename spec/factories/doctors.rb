# frozen_string_literal: true

FactoryBot.define do
  factory :doctor do
    association :user, factory: %i[user doctor]
    doctor_category { DoctorCategory.find_by(id: 1) || association(:doctor_category) }

    # Ensure the doctor record's ID matches the User profile expectation if any
    # But more importantly, ensure associations are clean
  end
end
