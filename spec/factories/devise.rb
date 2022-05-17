FactoryBot.define do
  factory :user do
    id {1}
    # email {"test@user.com"}
    phone {"0501111111"}
    name {"Patient"}
    password {"qwerty"}
    role {2}
  end

  factory :patient do
    id {1}
    user_id {1}
  end

  factory :doctor do
    id {1}
    user_id {1}
    doctor_category_id {100}
  end

  factory :doctor_category do
    id {100}
    name {"Physician1"}
  end

  factory :appointment_status do
    id {1}
    name {"Opened"}
  end

end
