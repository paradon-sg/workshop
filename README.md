# Workshop

A Rails 8.1 app for managing users (create, view, edit, delete), with HTML and JSON endpoints.

## Stack

- Ruby 4.0.7 (`.ruby-version`), Rails 8.1
- Node 26.8.1 (`.node-version`) and Yarn
- SQLite for all databases
- Hotwire (Turbo + Stimulus), bundled with esbuild
- Tailwind CSS 4
- Solid Cache, Solid Queue, Solid Cable
- Kamal for deployment

## Getting started

```sh
bin/setup
```

This installs gems and JS packages, prepares the database, and starts the dev server.

- `bin/setup --skip-server` sets up without starting the server.
- `bin/setup --reset` also resets the database.

To start the server later:

```sh
bin/dev
```

This runs Rails, the JS build, and the CSS build together (see `Procfile.dev`). Open http://localhost:3000/users.

## Database

SQLite files live in `storage/`:

| Environment | File |
| --- | --- |
| development | `storage/development.sqlite3` |
| test | `storage/test.sqlite3` |
| production | `storage/production.sqlite3` (plus separate cache, queue, and cable databases) |

```sh
bin/rails db:prepare   # create and migrate
bin/rails db:seed      # load seed data
```

## Routes

| Path | Description |
| --- | --- |
| `/users` | User CRUD (`resources :users`); add `.json` for JSON |
| `/up` | Health check; returns 200 when the app boots |

A `User` has `email`, `first_name`, `last_name`, and `phone`.

## Tests and checks

```sh
bin/rails test   # run the test suite
bin/ci           # full CI: setup, RuboCop, security audits, tests, seeds
```

GitHub Actions (`.github/workflows/ci.yml`) runs RuboCop and the test suite on every pull request and on pushes to `main`.

Individual checks:

```sh
bin/rubocop
bin/brakeman
bin/bundler-audit
yarn audit
```

## Deployment

Deployed with [Kamal](https://kamal-deploy.org). Configuration is in `config/deploy.yml`; update the server IP and registry before the first deploy.

```sh
bin/kamal setup    # first deploy
bin/kamal deploy   # later deploys
```

`RAILS_MASTER_KEY` is read through `.kamal/secrets`. Load it from an environment variable or a password manager. Never commit `config/master.key` or put secret values directly in the repo.

Useful aliases: `bin/kamal console`, `bin/kamal logs`, `bin/kamal shell`, `bin/kamal dbc`.
