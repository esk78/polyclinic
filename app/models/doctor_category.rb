# frozen_string_literal: true

class DoctorCategory < ApplicationRecord
  has_many :doctors
  validates :name, uniqueness: true
end
