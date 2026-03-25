# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { FactoryBot.build(:user) }

    it { should validate_presence_of(:password) }
    it { should validate_uniqueness_of(:phone).case_insensitive }

    context 'phone format' do
      it { should allow_value('0501111111').for(:phone) }
      it { should allow_value('+380501111111').for(:phone) }
      it { should_not allow_value('invalid').for(:phone) }
    end
  end

  describe 'associations' do
    it { should have_one(:doctor).dependent(:destroy) }
    it { should have_one(:patient).dependent(:destroy) }
  end

  describe 'callbacks' do
    describe '#create_user_profiles' do
      it 'creates a doctor profile when role is doctor' do
        user = FactoryBot.create(:user, :doctor)
        expect(Doctor.exists?(user_id: user.id)).to be true
      end

      it 'creates a patient profile when role is patient' do
        user = FactoryBot.create(:user, :patient)
        expect(Patient.exists?(user_id: user.id)).to be true
      end

      it 'does not create profiles for admin' do
        user = FactoryBot.create(:user, :admin)
        expect(Doctor.exists?(user_id: user.id)).to be false
        expect(Patient.exists?(user_id: user.id)).to be false
      end
    end
  end
end
