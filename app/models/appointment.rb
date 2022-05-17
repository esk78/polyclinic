class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient
  belongs_to :appointment_status

  validates :appointment_date, presence: true
  validates :appointment_status_id, presence: true

  validate :allow_only_ten_appointments_per_doctor, on: :create


private

  def change_status
    if self.appointment_status_id?
      self.appointment_status_id = 2
    end
  end

  def allow_only_ten_appointments_per_doctor
    errors.add(:appointment, "No more than 10 appointments.") if Appointment.where( "doctor_id = ?", self.doctor_id ).count > 10
    puts Appointment.where( "doctor_id = ?", self.doctor_id ).count
  end

end
