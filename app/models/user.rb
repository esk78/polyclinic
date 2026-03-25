# frozen_string_literal: true

class User < ApplicationRecord
  ROLE_ADMIN = 0
  ROLE_DOCTOR = 1
  ROLE_PATIENT = 2

  ROLES = %i[admin doctor patient].freeze

  after_create :create_user_profiles
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :doctor, dependent: :destroy
  has_one :patient, dependent: :destroy

  validates :phone, uniqueness: true, format: { with: /\A(?:\+?\d{1,3}\s*-?)?\(?(?:\d{2,3})?\)?[- ]?\d{3}[- ]?\d{4}\z/,

                                                message: 'Wrong phone number format' }

  def email_required?
    false
  end

  def email_changed?
    false
  end

  def create_user_profiles
    case role
    when ROLE_ADMIN
      # Admin
    when ROLE_DOCTOR
      Doctor.create!(user_id: id, doctor_category_id: 1)
      # redirect_to root_path
    when ROLE_PATIENT
      Patient.create!(user_id: id)
    else
      # Exception
      raise StandardError, 'Error Role'
    end
  end
end
