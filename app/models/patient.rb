# frozen_string_literal: true

class Patient < ApplicationRecord
  has_many :appointments
  has_many :doctors, through: :appointments
  belongs_to :user

  scope :with_user, -> { includes(:user) }
  scope :with_doctor_category, -> { joins(doctor: :doctor_category) }
end
