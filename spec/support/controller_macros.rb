module ControllerMacros
  def login_patient
    # Before each test, create and login the user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      patient = FactoryBot.create(:user)
      FactoryBot.create(:doctor_category)
      FactoryBot.create(:doctor)
      FactoryBot.create(:appointment_status)
      # user.confirm! # Or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
      sign_in patient
    end
  end


end
