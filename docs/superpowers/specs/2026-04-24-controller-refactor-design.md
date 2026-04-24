# Controller Refactor Design

## Overview

Refactor Rails controllers to follow SOLID, DRY, and KISS principles. Extract business logic (SQL queries) from controllers into dedicated query objects, fix security issues, and remove code duplication.

## Architecture

### Before
- Controllers contain business logic, SQL queries, and params handling
- Duplicated code between PatientsController and DoctorsController

### After
- Controllers are thin orchestration layers
- Query objects handle complex SQL
- Model scopes handle simple data access
- Concerns reduce controller boilerplate

## File Changes

### New Files

| File | Purpose |
|------|---------|
| `app/queries/appointment_queries.rb` | Centralized appointment queries |
| `app/controllers/concerns/crud_actions.rb` | Reusable CRUD controller actions |

### Modified Files

| File | Changes |
|------|---------|
| `app/controllers/patients_controller.rb` | Use query objects, fix patient_params |
| `app/controllers/doctors_controller.rb` | Use query objects |
| `app/controllers/appointments_controller.rb` | Fix appointment_params |
| `app/models/patient.rb` | Add scopes |
| `app/models/doctor.rb` | Add scopes |

## Public APIs

### Query Objects

```ruby
# app/queries/appointment_queries.rb
AppointmentQueries.for_patient(patient_id)
AppointmentQueries.for_doctor(doctor_id)
```

### Model Scopes

```ruby
Patient.with_user_doctor_category
Doctor.with_user_category
```

### Controller Concern

```ruby
class PatientsController < ApplicationController
  include CrudActions

  model_scope :patient
  resource_variable :@patient
end
```

## Security

### Fix: patient_params

**Before (insecure):**
```ruby
def patient_params
  params.fetch(:patient, {})  # permits ALL attributes
end
```

**After (secure):**
```ruby
def patient_params
  params.require(:patient).permit(:user_id, :address)
end
```

### Fix: appointment_params

**Before:**
```ruby
def appointment_params
  params.fetch(:appointment, {}).permit(...)
end
```

**After:**
```ruby
def appointment_params
  params.require(:appointment).permit(...)
end
```

## Error Handling

| Scenario | Response |
|----------|----------|
| Query fails | Render :show with error flash message |
| Invalid params | Return 400 with validation errors |
| Record not found | 404 (default Rails behavior) |
| Authorization denied | Handled by CanCan (existing) |

## Acceptance Criteria

1. No raw SQL in controllers (queries now in query objects or model scopes)
2. patient_params explicitly permits only safe attributes
3. DRY: No duplicated appointment queries between patients and doctors controllers
4. Controllers follow single responsibility principle
5. All tests pass after refactoring
6. Rubocop passes with no new violations