# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(_resource)
    current_user_dashboard
  end

  def after_sign_up_path_for(_resource)
    current_user_dashboard
  end

  protected

  def configure_permitted_parameters
    added_attrs = %i[phone name email password password_confirmation remember_me role]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
