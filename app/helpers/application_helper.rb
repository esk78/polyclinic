module ApplicationHelper
  def current_user_dashboard
    if user_signed_in?
      case current_user.role
      when 0
        admin_root_path
      when 1
        @doctor = Doctor.find_by(user_id: current_user.id)
        doctor_path(@doctor)
      when 2
        @patient = Patient.find_by(user_id: current_user.id)
        patient_path(@patient.id)
      end
    else
      new_user_session_path
    end
  end
end
