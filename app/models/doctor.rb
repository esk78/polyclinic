class Doctor < ApplicationRecord

  has_many :appointments
  has_many :patients, through: :appointments
  belongs_to :user
  belongs_to :doctor_category

end
