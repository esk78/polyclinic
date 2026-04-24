# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Development with Docker

```bash
# Start all services (db, app)
docker-compose up

# Run Rails server
docker-compose run --rm app bundle exec rails s -p 3000 -b '0.0.0.0'

# Run a single test
docker-compose run tests bundle exec rspec spec/models/user_spec.rb

# Run all tests
docker-compose run tests bundle exec rspec

# Run Rubocop linter
docker-compose run tests bundle exec rubocop

# Run Rubocop auto-fix
docker-compose run tests bundle exec rubocop -a

# Run Rails console
docker-compose run tests bundle exec rails c

# Run migrations
docker-compose run --rm app bundle exec rails db:migrate

# Reset database
docker-compose run tests bundle exec rails db:reset
```

## Architecture

### Domain Model

- **User** - system users (admins, doctors, patients)
- **Patient** - patients
- **Doctor** - doctors (belong to categories)
- **Appointment** - appointments (doctor-patient relationship)
- **DoctorCategory** - doctor categories (specializations)
- **AppointmentStatus** - appointment statuses

### Authentication & Authorization

- **Devise** - user authentication
- **CanCanCan** - authorization (config/ability.rb)

### Routes

- Public: `/`, `/patients`, `/doctors`, `/appointments`
- Admin panel: `/admin` (uses Administrate)
- Authenticated: `root to: "home#index"`

### Key Files

- `config/routes.rb` - routing
- `config/ability.rb` - permissions (CanCanCan)
- `app/models/*.rb` - models
- `app/controllers/*.rb` - controllers
- `spec/` - RSpec tests

### Tech Stack

- Rails 8.0, Ruby 3.3, PostgreSQL 16
- Bootstrap 5.3 (propshaft, dartsass-rails)
- Solid Queue/Cache/Cable
- RSpec + Factory Bot + Capybara
- Docker for development