# RestoHUB

RestoHUB is a food delivery and restaurant discovery platform designed to make the journey from choosing a restaurant to receiving an order as simple and transparent as possible. The product concept focuses on minimal steps, a clear UX, and real-time order tracking.

## Product overview

RestoHUB aims to unify restaurants, couriers, and customers into a single ecosystem and provide:
- fast restaurant discovery (search / filters / top picks),
- a convenient cart and checkout flow,
- order lifecycle tracking (accepted → cooking → on the way → delivered).

## Core features

- **Authentication & Profiles**
  - User authentication via Devise
  - Profile management
  - Addresses management
  - Payment methods management

- **Restaurants & Menu**
  - Restaurants list and restaurant details
  - Dishes per restaurant

- **Cart & Orders**
  - Add/update cart items
  - Checkout and order creation
  - Orders list and order details

- **Order tracking**
  - Order statuses and delivery entity (ETA planned/actual in the data model)

- **Admin panel**
  - ActiveAdmin + ArcticAdmin theme
  - Role management via Rolify

- **Internationalization**
  - Locale scoped routes (`/en`, `/ru`, etc.) via `rails-i18n`

## Tech stack

- **Ruby:** 3.3.4  
- **Rails:** ~> 7.2.2  
- **Database:** PostgreSQL  
- **Auth:** Devise  
- **Roles:** Rolify  
- **Admin:** ActiveAdmin + ArcticAdmin  
- **Search:** Elasticsearch (`elasticsearch-model`, `elasticsearch-rails`)  
- **Pagination:** Kaminari  
- **Assets/CSS:** `cssbundling-rails` + Sass (see `package.json` scripts)
- **Uploads:** ActiveStorage (+ validations) and image processing (MiniMagick)

### Tooling & quality
- RSpec (+ Capybara / Selenium)
- RuboCop
- Brakeman
- dotenv-rails

## Routes (high level)

- `GET /` — Home (`home#index`)
- Devise routes for users (with custom controllers)
- `GET /restaurants` / `GET /restaurants/:id`
- Cart:
  - `GET /cart`
  - `POST /cart/add_item`
  - `PATCH /cart/update_item`
  - `DELETE /cart/clear_for_restaurant`
- `GET /profile`, `GET /profile/edit`, `PATCH /profile`
- Orders:
  - `GET /orders`, `GET /orders/:id`, `GET /orders/new`, `POST /orders`
- Addresses CRUD + `DELETE /addresses/destroy_all`
- Payment methods CRUD + `DELETE /payment_methods/destroy_all`
- Admin panel: ActiveAdmin routes (typically `/admin`)

All primary user-facing routes are available under optional locale scope:
`/(:locale)/...` (e.g. `/en/restaurants`, `/ru/restaurants`).

## Data model (main entities)

- `users` (Devise)
- `roles`, `users_roles` (Rolify)
- `restaurants`
- `dishes` (belongs to restaurant)
- `carts`, `cart_items`
- `orders`, `order_items`
- `addresses`
- `payment_methods`
- `payments`
- `deliveries`
- ActiveStorage tables + ActiveAdmin comments

## Getting started (Local)

### Prerequisites
- Ruby **3.3.4**
- PostgreSQL
- Node.js (for CSS build tooling) + package manager (npm/yarn)
- (Optional) Elasticsearch (if search features are enabled/required in your setup)

### 1) Install dependencies

```bash
bundle install
```

Frontend/CSS dependencies (choose one):
```bash
yarn install
# or
npm install
```

### 2) Environment variables

The app expects database configuration via ENV (see `config/database.yml`).

Create a `.env` file (recommended) and set:

```bash
DATABASE_USERNAME=postgres
DATABASE_PASSWORD=postgres
DATABASE_HOST=localhost
DATABASE_PORT=5432
```

Production-only variables (if deploying):
```bash
RESTOHUB_DATABASE_USERNAME=...
RESTOHUB_DATABASE_PASSWORD=...
```

> Tip: you can commit a `.env.example` to the repo and keep `.env` ignored.

### 3) Database setup

```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

### 4) Run the app

If you use the Rails standard dev runner:

```bash
bin/dev
```

If you prefer running separately:

Terminal 1:
```bash
bin/rails s
```

Terminal 2 (CSS build):
```bash
yarn build:css
# or watch
yarn watch:css
```

Then open: http://localhost:3000

## Admin panel

ActiveAdmin is enabled. Typical path:
- `GET /admin`

To access it you usually need an admin user/role. How exactly an admin is created depends on your seeds / role setup.

## Elasticsearch (optional)

The project includes Elasticsearch gems and can support indexed search.
If your local setup requires it:
1) Run Elasticsearch (locally or via Docker).
2) Create/reindex as defined by the project tasks (look for tasks under `lib/tasks/`).

## Testing

Run test suite:
```bash
bundle exec rspec
```

## Linting & security checks

RuboCop:
```bash
bundle exec rubocop
```

Brakeman:
```bash
bundle exec brakeman
```

## Docker

The repository contains a `Dockerfile` and `docker-compose.yml`, but they currently describe a Node-based container flow (assets build) rather than a full Rails + PostgreSQL runtime. If you want a complete Docker setup for Rails (web + db + optional Elasticsearch), it should be extended accordingly.

## Product goals

RestoHUB focuses on:
- **Minimal steps** from discovery to checkout
- **Clear UX** without extra friction
- **Transparency** via understandable statuses and tracking

---

### Authors / Team
See the project presentation for the team and product concept.
