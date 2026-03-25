# frozen_string_literal: true

DoctorCategory.find_or_create_by!(id: 1) do |category|
  category.name = 'General'
end

AppointmentStatus.find_or_create_by!(id: 1) do |status|
  status.name = 'Opened'
end

AppointmentStatus.find_or_create_by!(id: 2) do |status|
  status.name = 'Closed'
end
