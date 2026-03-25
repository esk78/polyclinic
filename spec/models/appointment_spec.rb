# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Appointment, type: :model do
  describe 'associations' do
    it { should belong_to(:doctor) }
    it { should belong_to(:patient) }
    it { should belong_to(:appointment_status) }
  end

  describe 'validations' do
    it { should validate_presence_of(:appointment_date) }
    it { should validate_presence_of(:appointment_status_id) }
  end

  describe 'custom validations' do
    describe '#allow_only_ten_appointments_per_doctor' do
      let(:doctor) { FactoryBot.create(:doctor) }

      before do
        # Ensure default status exists
        AppointmentStatus.find_or_create_by!(id: 1) { |s| s.name = 'Opened' }
      end

      it 'allows creating an appointment if doctor has less than 10' do
        appointment = FactoryBot.build(:appointment, doctor: doctor)
        expect(appointment).to be_valid
      end

      it 'does not allow creating more than 10 appointments for a doctor' do
        10.times do
          FactoryBot.create(:appointment, doctor: doctor)
        end

        extra_appointment = FactoryBot.build(:appointment, doctor: doctor)
        expect(extra_appointment).not_to be_valid
        expect(extra_appointment.errors[:appointment]).to include('No more than 10 open appointments.')
      end
    end
  end
end
