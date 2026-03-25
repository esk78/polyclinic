# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Doctor Recommendations', type: :feature do
  let(:doctor_user) { FactoryBot.create(:user, :doctor) }
  let(:doctor) { doctor_user.doctor }
  let(:patient_user) { FactoryBot.create(:user, :patient) }
  let(:patient) { patient_user.patient }
  let!(:appointment) { FactoryBot.create(:appointment, doctor: doctor, patient: patient) }

  scenario 'Doctor leaves a recommendation and appointment closes' do
    login_as(doctor_user, scope: :user)

    visit doctor_path(doctor)

    click_button 'Appointments'
    expect(page).to have_content("Appointment to #{patient_user.name}")

    click_button 'Add recomendation'

    fill_in 'Recomendations', with: 'Take vitamin C'
    click_button 'Change'

    expect(page).to have_content('Appointment was successfully updated.')
    expect(page).to have_content('Take vitamin C')
    expect(page).to have_content('Appointments status: Closed') # Assuming seed data or constant name
  end
end
