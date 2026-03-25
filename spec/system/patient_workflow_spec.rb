# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Patient Workflow', type: :system do
  before do
    driven_by(:rack_test)
    # Ensure default data exists
    DoctorCategory.find_or_create_by!(id: 1) { |c| c.name = 'General' }
    AppointmentStatus.find_or_create_by!(id: 1) { |s| s.name = 'Opened' }
  end

  it 'allows a patient to sign up and book an appointment' do
    visit new_user_registration_path

    fill_in 'Phone', with: '0509998877'
    fill_in 'Name', with: 'New Patient'
    fill_in 'Password', with: 'password123'
    fill_in 'Password confirmation', with: 'password123'
    select 'Patient', from: 'user_role'

    click_button 'Sign up'

    # We should be on patient dashboard now
    expect(page).to have_content 'New Patient'

    # Create a doctor to book with
    doctor_user = FactoryBot.create(:user, :doctor, name: 'Dr. House')

    # Click Doctors tab (v-pills-doctors-tab is the ID)
    # Since it's rack-test, clicking tabs might not "work" if they are purely JS
    # But let's try to click the link/button if it exists
    # If not, navigate directly to new appointment path

    visit "/appointments/new/#{doctor_user.doctor.id}"

    fill_in 'appointment_appointment_date', with: (Time.current + 1.day).strftime('%d.%m.%Y, %H:%M')
    click_button 'Appointment'

    expect(page).to have_content 'Appointment was successfully created.'

    # Now check Appointments tab content
    expect(page).to have_content 'Appointment to Dr. House'
  end
end
