# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin Workflow', type: :system do
  let(:admin_user) { FactoryBot.create(:user, :admin, name: 'Admin User') }

  before do
    driven_by(:rack_test)
    login_as(admin_user, scope: :user)
  end

  it 'allows an admin to create a new doctor category' do
    visit admin_root_path

    click_link 'Doctor Categories'
    click_link 'New doctor category'

    fill_in 'Name', with: 'Surgeon'
    click_button 'Create Doctor category'

    expect(page).to have_content 'Doctor category was successfully created.'
    expect(page).to have_content 'Surgeon'
  end
end
