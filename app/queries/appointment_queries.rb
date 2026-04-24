# frozen_string_literal: true

class AppointmentQueries
  def self.for_patient(patient_id)
    Appointment.select(
      'users.name as doctor_name',
      'doctor_categories.name as category_name',
      'appointments.appointment_date',
      'appointment_statuses.name as status_name',
      'appointments.recomendations'
    )
    .joins(doctor: [{ user: :doctor_category }, :appointment_status])
    .where(patient_id: patient_id)
  end

  def self.for_doctor(doctor_id)
    Appointment.select(
      'users.name as patient_name',
      'appointment_statuses.name as status_name',
      'appointments.appointment_date',
      'appointments.recomendations'
    )
    .joins(patient: [{ user: :appointment_status }])
    .where(doctor_id: doctor_id)
  end
end