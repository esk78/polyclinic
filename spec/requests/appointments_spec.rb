# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Appointments', type: :request do
  let(:patient_user) { FactoryBot.create(:user, :patient) }
  let(:doctor_user) { FactoryBot.create(:user, :doctor) }
  let(:doctor) { doctor_user.doctor }
  let(:patient) { patient_user.patient }

  before do
    # Ensure default status exists globally for these tests
    AppointmentStatus.find_or_create_by!(id: 1) { |s| s.name = 'Opened' }
  end

  describe 'As a Patient' do
    before { sign_in patient_user }

    it 'can access new appointment page' do
      get "/appointments/new/#{doctor.id}"
      expect(response).to have_http_status(:success)
    end

    it 'can create an appointment' do
      expect do
        post '/appointments', params: {
          appointment: {
            doctor_id: doctor.id,
            patient_id: patient.id,
            appointment_date: Time.current + 1.day,
            appointment_status_id: 1
          }
        }
      end.to change(Appointment, :count).by(1)
      expect(response).to redirect_to("/patients/#{patient.id}")
    end
  end

  describe 'As a Doctor' do
    before { sign_in doctor_user }
    let(:appointment) { FactoryBot.create(:appointment, doctor: doctor, patient: patient) }

    it 'can access edit appointment page' do
      get edit_appointment_path(appointment)
      expect(response).to have_http_status(:success)
    end

    it 'can update an appointment with recommendations' do
      patch appointment_path(appointment), params: {
        appointment: {
          recomendations: 'Drink more water',
          appointment_status_id: appointment.appointment_status_id # Ensure it's passed
        }
      }

      expect(response).to redirect_to(doctor_path(doctor))
      expect(appointment.reload.recomendations).to eq('Drink more water')
    end
  end

  describe 'Unauthorized access' do
    it 'redirects to login for new appointment' do
      get '/appointments/new/1'
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
