# Tuniverse Database Schema

**Project:** Tuniverse — One Platform. Every Service.

**Schema version:** 1.0.0  
**Target:** MySQL 8.0+ / XAMPP  
**Storage engine:** InnoDB  
**Character set:** `utf8mb4`  
**Collation:** `utf8mb4_unicode_ci`  
**Default currency:** TND  
**Application timezone:** `Africa/Tunis`  

## 1. Purpose

This schema is the persistence layer for the Tuniverse modular monolith. It provides one identity system and shared infrastructure for Marketplace, Food Delivery, Transportation, Healthcare, Education, Jobs, News, Messaging, Wallet, Business Dashboard, and Administration.

The database is intentionally relational. Foreign keys enforce ownership and dependency relationships; module-specific workflow history tables provide auditability without coupling unrelated modules.

## 2. Installation

1. Start Apache and MySQL from XAMPP.
2. Open phpMyAdmin.
3. Import `database.sql`.
4. The script creates the `tuniverse` database automatically.
5. Verify that all tables use InnoDB and `utf8mb4`.
6. Create the first administrator through the application installation/bootstrap routine. **The SQL file never seeds a plaintext administrator password.**

The application should connect with PDO using UTF-8 and UTC database timestamps. User-facing formatting should convert timestamps to `Africa/Tunis` or the user's configured timezone.

## 3. Design Conventions

### IDs

Business entities use `BIGINT UNSIGNED AUTO_INCREMENT` primary keys. Junction tables use composite primary keys where appropriate.

### Money

All monetary amounts use `DECIMAL`, never floating point. TND is represented with three decimal places because the application is expected to operate in Tunisian dinars. Historical order/payment records copy the price actually charged rather than relying on a product/service's current price.

### Timestamps

Core mutable entities use `created_at` and `updated_at`. Workflow entities additionally keep event timestamps such as `published_at`, `completed_at`, or `cancelled_at`.

### Soft deletion

User-generated/business entities that may need historical retention use `deleted_at`. Financial records are not designed for physical deletion.

### Status fields

Statuses are stored as `VARCHAR` plus `CHECK` constraints rather than MySQL `ENUM`, allowing future workflow expansion with migrations. The application service layer remains responsible for legal state transitions.

### JSON

JSON is used only where flexible structured data is appropriate, such as addresses, payment provider payloads, resume sections, and extensible attributes. Core relationships remain normalized.

## 4. Table Catalogue

### Core / Identity / Security

| Table | Purpose | Primary relationship |
|---|---|---|
| `locales` | Supported languages and text direction | Referenced by user profiles and translations |
| `users` | Global identity/authentication account | Root entity |
| `user_profiles` | Profile information and preferences | 1:1 with users |
| `roles` | RBAC role definitions | Linked through `user_roles` |
| `permissions` | Fine-grained permissions | Linked through `role_permissions` |
| `user_roles` | User-to-role assignments | users ↔ roles |
| `role_permissions` | Role-to-permission assignments | roles ↔ permissions |
| `sessions` | Server-side session records | many-to-one users |
| `remember_tokens` | Persistent login tokens | many-to-one users |
| `password_reset_tokens` | Password reset tokens | many-to-one users |
| `user_addresses` | Reusable user addresses | many-to-one users |
| `media` | Validated uploaded-file metadata | many-to-one users |
| `notifications` | In-app notifications | many-to-one users |
| `notification_preferences` | Per-user notification channel settings | users |
| `reports` | Moderation/report queue | logical target + users |
| `reviews` | Shared rating/review model | logical target + users |
| `review_replies` | Responses to reviews | reviews + users |
| `audit_logs` | Security/admin audit trail | actor + logical target |
| `system_settings` | Global configuration | optional admin updater |

### Business platform

| Table | Purpose |
|---|---|
| `businesses` | Business accounts/entities |
| `business_members` | Staff/role membership for businesses |
| `business_categories` | Hierarchical business categories |
| `business_category_links` | Business ↔ category many-to-many link |
| `business_hours` | Weekly business opening schedule |
| `business_documents` | Verification/registration documents |
| `business_status_history` | Business approval/suspension history |

### Marketplace

| Table | Purpose |
|---|---|
| `marketplace_categories` | Hierarchical product categories |
| `products` | Sellable product master records |
| `product_variants` | Variant/SKU/attribute-specific pricing |
| `product_images` | Product media gallery |
| `inventories` | Available/reserved stock |
| `marketplace_carts` | User shopping carts |
| `marketplace_cart_items` | Cart lines |
| `marketplace_orders` | Marketplace order header |
| `marketplace_order_items` | Immutable purchased product snapshot |
| `shipping_addresses` | Immutable address captured for an order |
| `marketplace_order_status_history` | Marketplace workflow history |

### Food delivery

| Table | Purpose |
|---|---|
| `restaurants` | Restaurant profile and delivery settings |
| `restaurant_hours` | Restaurant schedule |
| `menu_categories` | Menu sections |
| `menu_items` | Food items and prices |
| `food_carts` | Restaurant-specific food cart |
| `food_cart_items` | Food cart lines |
| `food_orders` | Food order header |
| `food_order_items` | Immutable purchased item snapshot |
| `food_order_status_history` | Food workflow history |
| `food_delivery_assignments` | Driver assignment for food delivery |

### Transportation

| Table | Purpose |
|---|---|
| `vehicle_types` | Fare model and passenger capacity |
| `vehicles` | Driver vehicles |
| `driver_profiles` | Driver verification/availability |
| `driver_documents` | Driver identity/licence documents |
| `ride_requests` | Passenger ride request |
| `rides` | Matched/active/completed ride |
| `ride_fares` | Final calculated fare snapshot |
| `ride_status_history` | Ride lifecycle history |
| `driver_locations` | Historical driver GPS points |

### Healthcare

| Table | Purpose |
|---|---|
| `healthcare_providers` | Doctors/clinics/professionals |
| `healthcare_specialties` | Specialty catalogue |
| `provider_specialties` | Provider ↔ specialty many-to-many |
| `healthcare_services` | Bookable medical services |
| `provider_services` | Provider ↔ service many-to-many |
| `provider_availability` | Recurring provider schedule |
| `patient_profiles` | Patient-specific profile data |
| `appointments` | Appointment booking |
| `appointment_status_history` | Appointment lifecycle history |

### Education

| Table | Purpose |
|---|---|
| `education_institutions` | Schools/training providers |
| `institution_staff` | Staff/teacher assignments |
| `course_categories` | Course taxonomy |
| `courses` | Course master records |
| `course_sections` | Course modules/sections |
| `lessons` | Lesson content |
| `course_materials` | Lesson attachments |
| `enrollments` | Student/course relationship |
| `student_progress` | Per-lesson progress |

### Jobs

| Table | Purpose |
|---|---|
| `employer_profiles` | Employer representation for a business |
| `job_categories` | Job taxonomy |
| `jobs` | Job postings |
| `job_locations` | One or more job locations |
| `job_skills` | Skill catalogue |
| `job_skill_links` | Job ↔ skill many-to-many |
| `resumes` | User resumes/CV metadata |
| `job_applications` | Candidate application |
| `application_status_history` | Application lifecycle history |

### News

| Table | Purpose |
|---|---|
| `news_categories` | News taxonomy |
| `articles` | Language-independent article identity/workflow |
| `article_translations` | Arabic/French/English article bodies |
| `article_media` | Article media gallery |
| `article_comments` | Moderated comments and replies |
| `article_reactions` | User reactions |

### Messaging

| Table | Purpose |
|---|---|
| `conversations` | Conversation container |
| `conversation_participants` | User membership in conversation |
| `messages` | Message content/workflow |
| `message_attachments` | Message file attachments |
| `message_reads` | Per-user message read state |

### Payments / Wallet

| Table | Purpose |
|---|---|
| `payment_intents` | Payment attempt intent |
| `payments` | Provider payment result |
| `payment_refunds` | Refund records |
| `payment_events` | Raw/verified provider webhook events |
| `wallet_accounts` | User wallet per currency |
| `wallet_transactions` | Immutable wallet transaction headers |
| `wallet_transaction_entries` | Transaction ledger balance entries |
| `wallet_topups` | Wallet funding workflow |
| `wallet_withdrawals` | Wallet cash-out workflow |

## 5. Core Relationships

### Identity

```text
users 1 ─── 1 user_profiles
users 1 ─── N sessions
users 1 ─── N remember_tokens
users 1 ─── N password_reset_tokens
users N ─── N roles              via user_roles
roles N ─── N permissions       via role_permissions
users 1 ─── N user_addresses
users 1 ─── N notifications
users 1 ─── N media
```

### Business

```text
users 1 ─── N businesses
businesses 1 ─── N business_members
businesses N ─── N business_categories via business_category_links
businesses 1 ─── N business_documents
businesses 1 ─── N business_status_history
```

### Marketplace

```text
businesses 1 ─── N products
products 1 ─── N product_variants
products 1 ─── N product_images
products 1 ─── N inventories
users 1 ─── N marketplace_carts
marketplace_carts 1 ─── N marketplace_cart_items
users 1 ─── N marketplace_orders
marketplace_orders 1 ─── N marketplace_order_items
marketplace_orders 1 ─── 1 shipping_addresses
```

### Food

```text
businesses 1 ─── N restaurants
restaurants 1 ─── N menu_categories
menu_categories 1 ─── N menu_items
users 1 ─── N food_carts
food_carts 1 ─── N food_cart_items
users 1 ─── N food_orders
food_orders 1 ─── N food_order_items
food_orders 1 ─── 0..1 food_delivery_assignments
```

### Transport

```text
users 1 ─── 1 driver_profiles
users 1 ─── N vehicles
vehicle_types 1 ─── N vehicles
users 1 ─── N ride_requests
ride_requests 1 ─── 1 rides
rides 1 ─── 1 ride_fares
users 1 ─── N driver_locations
```

### Healthcare

```text
businesses 1 ─── N healthcare_providers
healthcare_providers N ─── N healthcare_specialties via provider_specialties
healthcare_providers N ─── N healthcare_services via provider_services
healthcare_providers 1 ─── N provider_availability
users 1 ─── 1 patient_profiles
users 1 ─── N appointments
healthcare_providers 1 ─── N appointments
healthcare_services 1 ─── N appointments
```

### Education

```text
businesses 1 ─── N education_institutions
education_institutions 1 ─── N courses
courses 1 ─── N course_sections
course_sections 1 ─── N lessons
lessons 1 ─── N course_materials
courses N ─── N users via enrollments
```

### Jobs

```text
businesses 1 ─── 1 employer_profiles
employer_profiles 1 ─── N jobs
jobs N ─── N job_skills via job_skill_links
users 1 ─── N resumes
jobs N ─── N users via job_applications
```

### News

```text
users 1 ─── N articles
articles 1 ─── N article_translations
articles 1 ─── N article_media
articles 1 ─── N article_comments
articles N ─── N users via article_reactions
```

### Messaging

```text
users N ─── N conversations via conversation_participants
conversations 1 ─── N messages
messages 1 ─── N message_attachments
messages N ─── N users via message_reads
messages N ─── 1 messages for reply threading
```

### Finance

```text
users 1 ─── N payment_intents
payment_intents 1 ─── N payments
payments 1 ─── N payment_refunds
payments 1 ─── N payment_events
users 1 ─── N wallet_accounts
wallet_accounts 1 ─── N wallet_transactions
wallet_transactions 1 ─── N wallet_transaction_entries
wallet_accounts 1 ─── N wallet_topups
wallet_accounts 1 ─── N wallet_withdrawals
```

## 6. RBAC Seed Model

The schema seeds these system roles:

| Role | Intended scope |
|---|---|
| `user` | Normal authenticated customer/candidate/student/patient |
| `business_owner` | Business operations across enabled modules |
| `moderator` | User/content/report moderation |
| `administrator` | Platform-wide administrative operations |
| `super_administrator` | Full system authority |

There is deliberately **no default super-admin account**. Account creation must happen through a secure application bootstrap process, with password hashing and audit logging.

## 7. Localization Data Model

`locales` contains:

| Code | Language | Direction |
|---|---|---|
| `ar` | Arabic | RTL |
| `fr` | French | LTR |
| `en` | English | LTR |

The database stores locale identifiers. Actual UI translations remain in PHP language files as required by the application architecture.

News is different: editorial content is user-generated/business data, so the `article_translations` table stores multilingual article content in the database.

## 8. Financial Integrity

### Order pricing

`marketplace_order_items`, `food_order_items`, and `ride_fares` retain the actual charged amounts. Product/service changes therefore do not rewrite historical transactions.

### Wallet model

A wallet has an operational balance (`available_balance`, `pending_balance`) and a transaction ledger (`wallet_transactions` + `wallet_transaction_entries`). The PHP wallet service must be the only code path allowed to change balances.

Recommended write pattern:

```text
BEGIN
  lock wallet row
  validate available funds/state
  create wallet transaction
  create ledger entries
  update wallet balance
COMMIT
```

Every reversal is represented as a compensating transaction rather than deletion of the original financial record.

## 9. Security Notes

### Passwords

`users.password_hash` stores only a PHP password hash created through `password_hash()`.

### Session tokens

`session_token_hash` and remember/reset token hashes are intentionally stored as hashes. Raw tokens are held only in the user's browser/session cookie when needed.

### Files

`media` stores metadata, not uploaded binary content. Files should be stored under a server-controlled path outside publicly writable/servable locations, or protected by Apache rules and application authorization.

### Polymorphic logical references

The following tables deliberately use `entity_type + entity_id` because the target can belong to different modules:

- `reviews`
- `reports`
- `payment_intents`
- `wallet_transactions` references

These cannot be enforced by a normal MySQL foreign key. The service layer must validate both existence and authorization before creating or reading these records.

## 10. Workflow History

Current-state columns are paired with immutable history/event records where operational traceability matters:

- `business_status_history`
- `marketplace_order_status_history`
- `food_order_status_history`
- `ride_status_history`
- `appointment_status_history`
- `application_status_history`
- `audit_logs`
- `payment_events`

The application should insert a history record whenever a business workflow changes state.

## 11. Recommended Application Rules Not Encoded Solely in SQL

SQL constraints enforce structural integrity, but these rules belong in PHP services:

1. A user may only access objects authorized for that user/business/role.
2. A business member can only manage capabilities allowed by their business role.
3. Order state transitions must follow legal workflow rules.
4. Inventory must be locked and checked within a transaction during checkout.
5. Wallet updates must be serialized and idempotent.
6. Payment provider webhooks must be signature-verified before state changes.
7. Appointment creation must detect scheduling conflicts.
8. Driver assignment must reject unavailable/unverified drivers.
9. Job application rules must prevent duplicates and respect closing dates.
10. Message sender must be an active participant in the conversation.
11. Uploaded media must be validated before a `media` record is made active.
12. Admin operations must generate audit records.

## 12. Indexing Strategy

The schema indexes:

- foreign keys used in joins
- status fields used in dashboards/queues
- `(user_id, created_at)` for user histories
- `(business_id, status)` for operator dashboards
- `(entity_type, entity_id)` for polymorphic targets
- workflow history `(entity_id, created_at)`
- job/category/status and appointment/provider/time search patterns
- message/conversation/time retrieval

Additional search indexes should be added only after measuring production query patterns.

## 13. Data Retention

Recommended policy:

- Authentication/session records: prune expired data periodically.
- Notifications: archive or prune according to product policy.
- Audit logs: retain according to administrative/security policy.
- Financial records: keep for the required accounting/compliance period.
- Orders and applications: retain sufficient history for customer/business support.
- Uploaded files: delete only after checking whether any retained record still references them.

## 14. Migration Strategy

`database.sql` is the baseline installation schema. After development starts, structural changes should be tracked as numbered migrations rather than manually editing production databases.

Suggested naming convention:

```text
001_create_core.sql
002_create_business.sql
003_create_marketplace.sql
004_create_food.sql
005_create_transport.sql
...
```

The baseline `database.sql` remains the clean-install representation used by XAMPP/phpMyAdmin.

## 15. Known Deliberate Trade-offs

### Polymorphic references

Used for genuinely cross-module concepts where one shared junction table is more maintainable than many duplicate tables. The trade-off is application-level integrity checks.

### JSON addresses

Operational snapshots are stored as JSON so historic delivery/ride addresses remain stable even if the user's reusable address changes. Searchable canonical locations remain structured columns where appropriate.

### Application-managed workflow transitions

The schema uses `CHECK` constraints for allowed status values but does not attempt to encode a complete finite-state machine in SQL. This keeps workflow rules testable in PHP services and avoids database triggers becoming the primary business-logic layer.

## 16. Baseline Acceptance Checklist

Before moving to Authentication implementation, verify:

- [ ] `database.sql` imports cleanly in phpMyAdmin.
- [ ] Database is `utf8mb4`.
- [ ] All application tables use InnoDB.
- [ ] Foreign keys are enabled after import.
- [ ] Three locales exist.
- [ ] Five system roles exist.
- [ ] Permission seed data exists.
- [ ] No default plaintext administrator exists.
- [ ] Core tables are reachable through expected foreign-key relationships.
- [ ] No financial table permits negative monetary amounts through its check constraints.
- [ ] Historical order/payment prices are stored on transaction records.

## 17. Next Implementation Dependency

The next phase can safely build the PHP authentication system against:

```text
users
user_profiles
roles
permissions
user_roles
role_permissions
sessions
remember_tokens
password_reset_tokens
user_addresses
notifications
notification_preferences
locales
audit_logs
```

The authentication layer should treat these tables as infrastructure and expose them through services/repositories rather than allowing controllers to perform unrestricted CRUD.
