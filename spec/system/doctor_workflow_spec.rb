# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Doctor Workflow', type: :system do
  let(:doctor_user) { FactoryBot.create(:user, :doctor, name: 'Dr. Strange') }
  let(:patient_user) { FactoryBot.create(:user, :patient, name: 'Tony Stark') }

  before do
    driven_by(:rack_test)
    # Ensure status 1 exists
    AppointmentStatus.find_or_create_by!(id: 1) { |s| s.name = 'Opened' }
    login_as(doctor_user, scope: :user)

    # Create an appointment for this doctor
    FactoryBot.create(:appointment, doctor: doctor_user.doctor, patient: patient_user.patient)
  end

  it 'allows a doctor to see appointments and add recommendations' do
    # Go to doctor dashboard
    doctor = doctor_user.doctor
    visit doctor_path(doctor)

    expect(page).to have_content 'Appointment to Tony Stark'

    click_button 'Add recomendation'

    fill_in 'Recomendations', with: 'Take some rest and save the world.'
    click_button 'Change'

    expect(page).to have_content 'Appointment was successfully updated.'
    expect(page).to have_content 'Take some rest and save the world.'
  end
end
