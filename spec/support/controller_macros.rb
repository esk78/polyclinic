# frozen_string_literal: true

module ControllerMacros
  def login_admin
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      admin = FactoryBot.create(:user, :admin)
      sign_in admin
    end
  end

  def login_doctor
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      # Ensure doctor category exists for the callback
      FactoryBot.create(:doctor_category, id: 1) unless DoctorCategory.exists?(1)
      user = FactoryBot.create(:user, :doctor)
      sign_in user
    end
  end

  def login_patient
    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:user]
      user = FactoryBot.create(:user, :patient)
      sign_in user
    end
  end
end
