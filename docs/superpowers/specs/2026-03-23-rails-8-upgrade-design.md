# Design Spec: Polyclinic Upgrade to Rails 8 and Ruby 3.3

## 1. Objective
Upgrade the `polyclinic` project from Rails 6.1/Ruby 3.0 to Rails 8.0/Ruby 3.3, transition from Webpacker to Importmaps/Propshaft, and implement the "Solid Stack" (Solid Queue, Cache, Cable) while dockerizing the entire environment.

## 2. Architecture & Infrastructure
### Dockerization
- **Base Image:** `ruby:3.3-slim` for a lightweight and secure environment.
- **Services:**
  - `app`: Rails application running on Puma.
  - `db`: PostgreSQL 16+ as the primary data store.
- **Orchestration:** `docker-compose.yml` for local development.
- **Storage:** Managed volumes for PostgreSQL data.

### Solid Stack (No-Redis Architecture)
- **Background Jobs:** Move from default async/inline to `solid_queue`.
- **Caching:** Transition to `solid_cache` using PostgreSQL.
- **Action Cable:** Transition to `solid_cable` using PostgreSQL.
- **Benefit:** Simplifies infrastructure by removing Redis dependency.

## 3. Rails Upgrade Path
### Phase 1: Rails 6.1 to 7.1
- Update `Gemfile` to Rails 7.1.
- Run `rails app:update` to handle configuration changes.
- Address deprecations and breaking changes in core gems (Devise, CanCanCan, Administrate).
- Verify existing RSpec and system tests.

### Phase 2: Rails 7.1 to 8.0
- Update `Gemfile` to Rails 8.0.
- Run `rails app:update`.
- Enable new Rails 8 defaults (Solid Stack, enhanced security headers, etc.).

## 4. Frontend Migration
- **Current State:** Webpacker 5.4.3 using `app/frontend`.
- **Target State:** `importmap-rails` + `propshaft`.
- **Migration Steps:**
  1. Remove `webpacker`, `node_modules`, `yarn.lock`, and `package.json`.
  2. Install and configure `importmap-rails` and `propshaft-rails`.
  3. Move JS assets from `app/frontend/packs` to `app/javascript`.
  4. Update application layout to use `javascript_importmap_tags`.
  5. Pin required JS libraries (Turbo, Stimulus) via `bin/importmap`.

## 5. Data Flow & Components
- **Persistence:** PostgreSQL handles all relational data + Queue/Cache/Cable state.
- **Authentication:** Devise (verified for Rails 8 compatibility).
- **Authorization:** CanCanCan.
- **Admin UI:** Administrate.

## 6. Testing & Validation Strategy
- **Automated Tests:** Run existing RSpec suite (`bundle exec rspec`) at each major version hop.
- **System Verification:**
  - Patient/Doctor login and dashboard access.
  - Appointment creation and status updates.
  - Admin panel functionality via Administrate.
- **Docker Validation:** Ensure `docker-compose up` results in a fully functional environment with seed data.

## 7. Success Criteria
- Rails version is 8.0.x.
- Ruby version is 3.3.x.
- Application runs inside Docker without local dependencies.
- No Node.js/Yarn dependencies remain.
- All tests pass.
