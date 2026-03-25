# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Access', type: :request do
  let(:admin_user) { FactoryBot.create(:user, :admin) }
  let(:patient_user) { FactoryBot.create(:user, :patient) }

  it 'allows admin to access admin dashboard' do
    sign_in admin_user
    get admin_root_path
    expect(response).to have_http_status(:success)
  end

  it 'denies patient access to admin dashboard' do
    sign_in patient_user
    # In request specs, CanCan might raise error directly if not handled in a way rack-test sees
    expect { get admin_root_path }.to raise_error(CanCan::AccessDenied)
  end
end
