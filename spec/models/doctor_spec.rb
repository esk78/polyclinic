# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Doctor, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:doctor_category) }
    it { should have_many(:appointments) }
    it { should have_many(:patients).through(:appointments) }
  end

  describe 'delegations' do
    it { should delegate_method(:phone).to(:user) }
  end

  describe '#phone_number' do
    let(:user) { create(:user, phone: '1234567890') }
    let(:doctor) { create(:doctor, user: user) }

    it 'returns the user phone number' do
      expect(doctor.phone_number).to eq('1234567890')
    end
  end
end
