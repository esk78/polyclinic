# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DoctorCategory, type: :model do
  describe 'associations' do
    it { should have_many(:doctors) }
  end

  describe 'validations' do
    subject { FactoryBot.create(:doctor_category) }
    it { should validate_uniqueness_of(:name) }
  end
end
