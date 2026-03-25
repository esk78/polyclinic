# frozen_string_literal: true

class Doctor < ApplicationRecord
  has_many :appointments
  has_many :patients, through: :appointments
  belongs_to :user
  belongs_to :doctor_category

  delegate :phone, to: :user, prefix: false, allow_nil: true
  alias phone_number phone
end
