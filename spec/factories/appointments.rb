# frozen_string_literal: true

FactoryBot.define do
  factory :appointment do
    appointment_date { Time.current + 1.day }
    association :doctor
    association :patient
    appointment_status { AppointmentStatus.find_by(id: 1) || association(:appointment_status) }
  end
end
