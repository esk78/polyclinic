# Controller Refactor Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Refactor controllers to follow SOLID, DRY, and KISS principles by extracting SQL to query objects and fixing security issues.

**Architecture:** 
- Create Query Objects for complex appointment queries currently embedded in PatientsController and DoctorsController
- Add model scopes for simple data access
- Fix security vulnerabilities in params handling
- Controllers become thin orchestration layers

**Tech Stack:** Rails, RSpec, Rubocop

---

## Task 1: Create Appointment Query Object

**Files:**
- Create: `app/queries/appointment_queries.rb`
- Test: `spec/queries/appointment_queries_spec.rb`

- [ ] **Step 1: Create query object**

```ruby
# app/queries/appointment_queries.rb
# frozen_string_literal: true

class AppointmentQueries
  def self.for_patient(patient_id)
    Appointment.select(
      'users.name as doctor_name',
      'doctor_categories.name as category_name',
      'appointments.appointment_date',
      'appointment_statuses.name as status_name',
      'appointments.recomendations'
    )
    .joins(doctor: [{ user: :doctor_category }, :appointment_status])
    .where(patient_id: patient_id)
  end

  def self.for_doctor(doctor_id)
    Appointment.select(
      'users.name as patient_name',
      'appointment_statuses.name as status_name',
      'appointments.appointment_date',
      'appointments.recomendations'
    )
    .joins(patient: [{ user: :appointment_status }])
    .where(doctor_id: doctor_id)
  end
end
```

- [ ] **Step 2: Run syntax check**

Run: `docker-compose run --rm app ruby -c app/queries/appointment_queries.rb`

- [ ] **Step 3: Commit**

```bash
git add app/queries/appointment_queries.rb
git commit -m "feat: add appointment queries object"
```

---

## Task 2: Add Model Scopes

**Files:**
- Modify: `app/models/patient.rb`
- Modify: `app/models/doctor.rb`

- [ ] **Step 1: Add scopes to Patient**

```ruby
# app/models/patient.rb (add after line 6)
  scope :with_user, -> { includes(:user) }
  scope :with_doctor_category, -> { joins(doctor: :doctor_category) }
```

- [ ] **Step 2: Add scopes to Doctor**

```ruby
# app/models/doctor.rb (add after line 10)
  scope :with_user, -> { includes(:user) }
  scope :with_category, -> { includes(:doctor_category) }
```

- [ ] **Step 3: Commit**

```bash
git add app/models/patient.rb app/models/doctor.rb
git commit -m "feat: add model scopes"
```

---

## Task 3: Fix Security Issue in PatientsController

**Files:**
- Modify: `app/controllers/patients_controller.rb:96-98`

- [ ] **Step 1: Fix patient_params security vulnerability**

Current (insecure):
```ruby
def patient_params
  params.fetch(:patient, {})  # permits ALL attributes
end
```

Replace with:
```ruby
def patient_params
  params.require(:patient).permit(:user_id, :address)
end
```

- [ ] **Step 2: Verify file exists and line numbers**

Run: `grep -n "def patient_params" app/controllers/patients_controller.rb`

- [ ] **Step 3: Commit**

```bash
git add app/controllers/patients_controller.rb
git commit -m "fix: secure patient_params whitelist"
```

---

## Task 4: Refactor PatientsController

**Files:**
- Modify: `app/controllers/patients_controller.rb:13-24, 27-40`

- [ ] **Step 1: Update show action to use query object**

Replace lines 13-24:
```ruby
def show
  @doctor_categories = DoctorCategory.all
  @doctors_by_category = Doctor.select('users.name as u_name, doctor_categories.name as dc_name, doctors.id as d_id').joins(
    :doctor_category, :user
  ).all
  @appointments = AppointmentQueries.for_patient(@patient.id)
end
```

- [ ] **Step 2: Update doctors_search action**

Replace lines 27-40:
```ruby
def doctors_search
  if params[:doctor_category_id].present?
    @doctors_by_category = Doctor.with_user.with_category.where(
      doctor_category_id: params[:doctor_category_id]
    )
  else
    @doctors_by_category = Doctor.with_user.with_category.all
  end
  respond_to do |format|
    format.js { render layout: false }
  end
end
```

- [ ] **Step 3: Run linter check**

Run: `docker-compose run tests bundle exec rubocop app/controllers/patients_controller.rb`

- [ ] **Step 4: Commit**

```bash
git add app/controllers/patients_controller.rb
git commit -m "refactor: use query objects in PatientsController"
```

---

## Task 5: Refactor DoctorsController

**Files:**
- Modify: `app/controllers/doctors_controller.rb:13-21`

- [ ] **Step 1: Update show action to use query object**

Replace lines 13-21:
```ruby
def show
  @doctor_categories = DoctorCategory.all
  @current_category = DoctorCategory.find(@doctor.doctor_category_id)
  @appointments = AppointmentQueries.for_doctor(@doctor.id)
end
```

- [ ] **Step 2: Run linter check**

Run: `docker-compose run tests bundle exec rubocop app/controllers/doctors_controller.rb`

- [ ] **Step 3: Commit**

```bash
git add app/controllers/doctors_controller.rb
git commit -m "refactor: use query objects in DoctorsController"
```

---

## Task 6: Fix AppointmentsController

**Files:**
- Modify: `app/controllers/appointments_controller.rb:63-68`

- [ ] **Step 1: Fix appointment_params**

Current (insecure):
```ruby
def appointment_params
  params.fetch(:appointment, {}).permit(...)
end
```

Replace with:
```ruby
def appointment_params
  params.require(:appointment).permit(:appointment_date, :doctor_id, :patient_id, :appointment_status_id, :recomendations)
end
```

Note: `id` should not be permitted for create/update - Rails handles it automatically.

- [ ] **Step 2: Remove redundant with_defaults**

The `with_defaults(appointment_status_id: 1)` should be moved to model-level default, not controller. Remove it and set default in migration or model.

- [ ] **Step 3: Run linter check**

Run: `docker-compose run tests bundle exec rubocop app/controllers/appointments_controller.rb`

- [ ] **Step 4: Commit**

```bash
git add app/controllers/appointments_controller.rb
git commit -m "fix: secure appointment_params"
```

---

## Task 7: Run Full Test Suite

**Files:**
- Run: `spec/`

- [ ] **Step 1: Run tests**

Run: `docker-compose run tests bundle exec rspec`

- [ ] **Step 2: Run linter**

Run: `docker-compose run tests bundle exec rubocop`

- [ ] **Step 3: Fix any failures**

If any failures, fix and re-run until all pass.

- [ ] **Step 4: Final commit**

```bash
git add -A
git commit -m "refactor: complete controller improvements"
```

---

## Completion Criteria Check

| Criteria | Status |
|----------|--------|
| No raw SQL in controllers | [ ] Verified |
| patient_params secure | [ ] Verified |
| DRY: no duplicate appointment queries | [ ] Verified |
| Controllers follow SRP | [ ] Verified |
| Tests pass | [ ] Verified |
| Rubocop passes | [ ] Verified |