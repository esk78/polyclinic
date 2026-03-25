# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AppointmentsController, type: :controller do
  # Ensure dependencies exist
  before do
    DoctorCategory.find_or_create_by!(id: 1) { |c| c.name = 'General' }
    AppointmentStatus.find_or_create_by!(id: 1) { |s| s.name = 'Opened' }
  end

  login_patient

  let(:valid_attributes) do
    {
      appointment_date: '2022-05-26 15:55:00',
      doctor_id: FactoryBot.create(:doctor).id,
      patient_id: FactoryBot.create(:patient).id,
      appointment_status_id: 1,
      recomendations: ''
    }
  end

  describe 'Create appointment' do
    it 'returns a redirect response' do
      post :create, params: { appointment: valid_attributes }
      expect(response).to have_http_status(:redirect)
    end
  end
end
