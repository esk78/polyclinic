require 'rails_helper'

RSpec.describe AppointmentsController, type: :controller do

    login_patient

    let(:valid_attributes) {
        {:appointment_date => "2022-05-26 15:55:00", :doctor_id => Doctor.first.id, :patient_id => Patient.first.id, :appointment_status_id => AppointmentStatus.first.id, :recomendations => ""}
    }

    let(:valid_session) { {} }

    describe "Create appointment" do
        it "returns a success response" do
            Appointment.create! valid_attributes
            expect(response).to be_successful # be_successful expects a HTTP Status code of 200
        end
    end
end
