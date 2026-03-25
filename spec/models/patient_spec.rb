# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Patient, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:appointments) }
    it { should have_many(:doctors).through(:appointments) }
  end
end
