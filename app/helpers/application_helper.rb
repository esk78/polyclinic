module ApplicationHelper
  def current_user_dashboard
    if user_signed_in?
      case current_user.role
      when 0
        admin_root_path
      when 1
        doctor = current_user.doctor
        doctor ? doctor_path(doctor) : root_path
      when 2
        patient = current_user.patient
        patient ? patient_path(patient) : root_path
      else
        root_path
      end
    else
      new_user_session_path
    end
  end
end
