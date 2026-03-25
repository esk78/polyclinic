# frozen_string_literal: true

class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient
  belongs_to :appointment_status

  validates :appointment_date, presence: true
  validates :appointment_status_id, presence: true

  validate :allow_only_ten_appointments_per_doctor, on: :create
  before_save :close_appointment_if_recommendation_given

  private

  def close_appointment_if_recommendation_given
    return unless recomendations.present? && recomendations_changed?

    self.appointment_status_id = AppointmentStatus::CLOSED
  end

  def allow_only_ten_appointments_per_doctor
    return unless Appointment.where(doctor_id: doctor_id, appointment_status_id: AppointmentStatus::OPEN).count >= 10

    errors.add(:appointment, 'No more than 10 open appointments.')
  end
end
