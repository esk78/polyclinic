# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'as Admin' do
    let(:user) { FactoryBot.create(:user, :admin) }

    it { is_expected.to be_able_to(:manage, :all) }
  end

  describe 'as Doctor' do
    let(:user) { FactoryBot.create(:user, :doctor) }
    let(:doctor) { user.doctor || Doctor.find_by(user_id: user.id) }
    let(:other_doctor) { FactoryBot.create(:doctor) }

    let(:my_appointment) { FactoryBot.create(:appointment, doctor: doctor) }
    let(:other_appointment) { FactoryBot.create(:appointment, doctor: other_doctor) }

    it { is_expected.to be_able_to(:read, Appointment) }
    it { is_expected.to be_able_to(:update, my_appointment) }
    it { is_expected.not_to be_able_to(:update, other_appointment) }
    it { is_expected.not_to be_able_to(:manage, User) }
  end

  describe 'as Patient' do
    let(:user) { FactoryBot.create(:user, :patient) }
    let(:patient) { user.patient || Patient.find_by(user_id: user.id) }

    let(:my_appointment) { FactoryBot.create(:appointment, patient: patient) }
    let(:other_appointment) { FactoryBot.create(:appointment) }

    it { is_expected.to be_able_to(:create, Appointment) }
    it { is_expected.to be_able_to(:read, my_appointment) }
    it { is_expected.not_to be_able_to(:read, other_appointment) }
    it {
      is_expected.not_to be_able_to(:update, my_appointment)
    } # assuming patients cannot update appointments once created (e.g. for recommendations)
  end
end
