# Specification: Adding RSpec Tests to the Polyclinic Project

**Date:** 2026-03-24  
**Status:** Draft (Awaiting final approval)  
**Goal:** Ensure 100% coverage of critical business logic and user scenarios using RSpec.

---

## 1. Architecture and Testing Infrastructure

### 1.1. Factory Refactoring (FactoryBot)
*   **File Distribution**: Move all factories from `spec/factories/devise.rb` to their respective files:
    *   `spec/factories/users.rb`
    *   `spec/factories/doctors.rb`
    *   `spec/factories/patients.rb`
    *   `spec/factories/doctor_categories.rb`
    *   `spec/factories/appointment_statuses.rb`
    *   `spec/factories/appointments.rb`
*   **Dynamic Data**: Remove hardcoded `id { 1 }`. Use `sequence` for unique fields (`email`, `phone`, `name`).
*   **Trait System**: Add traits for user roles:
    ```ruby
    trait :admin { role { 0 } }
    trait :doctor { role { 1 } }
    trait :patient { role { 2 } }
    ```

### 1.2. Support Helpers
*   Update `spec/support/controller_macros.rb` to support Devise login for different roles in controller/request tests.

---

## 2. Model and Security Testing

### 2.1. Models (ActiveRecord)
*   **Validations**: Cover all `presence`, `uniqueness`, and formats (phone, email) using `shoulda-matchers`.
*   **Associations**: Verify `belongs_to`, `has_many` relationships for all models (`User`, `Doctor`, `Patient`, `Appointment`, etc.).
*   **Callbacks & Methods**: Explicitly test the `create_user_profiles` callback in `User.rb` and any other custom logic.

### 2.2. Permissions (CanCanCan)
*   Create `spec/models/ability_spec.rb`.
*   **Test Cases**:
    *   **Admin**: Access to everything (`manage :all`).
    *   **Doctor**: Access to their own patients, editing recommendations in their own appointments. Forbidden access to the user list.
    *   **Patient**: Viewing own appointments, creating new appointments. Forbidden from editing recommendations.

---

## 3. Interaction Testing (Controllers and System Tests)

### 3.1. Controllers (Request Specs)
*   **AppointmentsController**: Cover CRUD operations (index, show, create, update). Verify that a patient can create an appointment and a doctor can update it.
*   **Admin Area**: Verify that only admins have access to controllers within the `Admin::` namespace.
*   **Redirections**: Check redirection of unauthorized users to the login page.

### 3.2. System Tests (Capybara / System Specs)
*   **Patient Workflow**: Registration -> Login -> Doctor Selection -> Appointment Creation -> Verify appointment in the dashboard.
*   **Doctor Workflow**: Login -> View Patient List -> Select Appointment -> Add Diagnosis/Recommendations -> Save.
*   **Administration Workflow**: Creating a new doctor category via the admin panel.

---

## 4. Implementation Plan (Order of Operations)
1.  Refactor factories and set up infrastructure.
2.  Write tests for models and `Ability`.
3.  Cover controllers with Request specs.
4.  Create System specs for core business processes.
