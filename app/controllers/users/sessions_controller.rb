# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    def after_sign_in_path_for(resource)
      stored_location_for(resource) || current_user_dashboard
    end
  end
end
