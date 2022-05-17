class AddDefaultValueToAppointmentStatuses < ActiveRecord::Migration[6.1]
  def change
    change_column_default :appointments, :appointment_status_id, from: nil, to: 1
  end
end
