# AGENTS.md

## Dev Environment
- **Docker is required** - all commands run through `docker-compose`
- Use `docker-compose up` to start db + app services

## Commands

| Task | Command |
|------|---------|
| Run server | `docker-compose run --rm app bundle exec rails s -p 3000 -b '0.0.0.0'` |
| Run single test | `docker-compose run tests bundle exec rspec spec/path/to_spec.rb` |
| Run all tests | `docker-compose run tests bundle exec rspec` |
| Run linter | `docker-compose run tests bundle exec rubocop` |
| Auto-fix lint | `docker-compose run tests bundle exec rubocop -a` |
| Rails console | `docker-compose run tests bundle exec rails c` |
| Migrations | `docker-compose run --rm app bundle exec rails db:migrate` |
| Reset DB | `docker-compose run tests bundle exec rails db:reset` |

## Key Files
- `config/ability.rb` - CanCanCan authorization rules
- `config/routes.rb` - routing
- `spec/` - RSpec tests

## Notes
- Test service runs with `RAILS_ENV=test` (different from app service)
- DB runs on port 5438 (not default 5432)
- Admin panel at `/admin`