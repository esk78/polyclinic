# frozen_string_literal: true

class AppointmentQueries
  def self.for_patient(patient_id)
    Appointment.select(
      'users.name as d_name',
      'doctor_categories.name as dc_name',
      'appointments.appointment_date',
      'appointment_statuses.name as aps_name',
      'appointments.recomendations'
    )
    .joins(:doctor, :appointment_status)
    .joins('INNER JOIN users ON doctors.user_id = users.id')
    .joins('INNER JOIN doctor_categories ON doctors.doctor_category_id = doctor_categories.id')
    .where(patient_id: patient_id)
  end

  def self.for_doctor(doctor_id)
    Appointment.select(
      'users.name as p_name',
      'appointment_statuses.name as aps_name',
      'appointments.appointment_date',
      'appointments.recomendations',
      'appointments.id as id'
    )
    .joins(:patient, :appointment_status)
    .joins('INNER JOIN users ON patients.user_id = users.id')
    .where(doctor_id: doctor_id)
  end
end