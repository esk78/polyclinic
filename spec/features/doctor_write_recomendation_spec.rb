require 'rails_helper'

RSpec.describe "add recomendation", type: :feature do
  before :each do
    patient = FactoryBot.create(:user, role: 1)
    FactoryBot.create(:patient)
    FactoryBot.create(:appointment_status)
    login_as(patient, :scope => :user)
  end

  it "Add recomendation" do
    visit '/patients/1'
    click_button 'Doctors'
    # print page.body
    # find(:xpath, "/html/body/div[1]/div/div[2]/div[2]/div[2]/div[2]/div/small/form/input").click
    click_button 'Appointment'
    fill_in "appointment_appointment_date", with: "19.05.2022, 22:00"
    click_button 'Appointment'
    expect(page).to have_content 'Appointment was successfully created.'
  end
end
