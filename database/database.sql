-- ============================================================
-- TUNIVERSE - DATABASE SCHEMA
-- Version: 1.0.0
-- Target: MySQL 8.0+ / MariaDB 10.6+ with minor adjustments
-- Charset: utf8mb4 / utf8mb4_unicode_ci
-- Engine: InnoDB
-- ============================================================

SET NAMES utf8mb4;
SET time_zone = '+00:00';
SET FOREIGN_KEY_CHECKS = 0;

CREATE DATABASE IF NOT EXISTS tuniverse
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE tuniverse;

-- ------------------------------------------------------------
-- DROP TABLES (dependency-safe order)
-- ------------------------------------------------------------
DROP TABLE IF EXISTS wallet_transaction_entries;
DROP TABLE IF EXISTS wallet_transactions;
DROP TABLE IF EXISTS wallet_withdrawals;
DROP TABLE IF EXISTS wallet_topups;
DROP TABLE IF EXISTS wallet_accounts;
DROP TABLE IF EXISTS payment_events;
DROP TABLE IF EXISTS payment_refunds;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS payment_intents;
DROP TABLE IF EXISTS message_reads;
DROP TABLE IF EXISTS message_attachments;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS conversation_participants;
DROP TABLE IF EXISTS conversations;
DROP TABLE IF EXISTS article_reactions;
DROP TABLE IF EXISTS article_comments;
DROP TABLE IF EXISTS article_media;
DROP TABLE IF EXISTS article_translations;
DROP TABLE IF EXISTS articles;
DROP TABLE IF EXISTS news_categories;
DROP TABLE IF EXISTS application_status_history;
DROP TABLE IF EXISTS job_applications;
DROP TABLE IF EXISTS resumes;
DROP TABLE IF EXISTS job_skill_links;
DROP TABLE IF EXISTS job_skills;
DROP TABLE IF EXISTS job_locations;
DROP TABLE IF EXISTS jobs;
DROP TABLE IF EXISTS job_categories;
DROP TABLE IF EXISTS employer_profiles;
DROP TABLE IF EXISTS student_progress;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS course_materials;
DROP TABLE IF EXISTS lessons;
DROP TABLE IF EXISTS course_sections;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS course_categories;
DROP TABLE IF EXISTS institution_staff;
DROP TABLE IF EXISTS education_institutions;
DROP TABLE IF EXISTS appointment_status_history;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS provider_availability;
DROP TABLE IF EXISTS provider_services;
DROP TABLE IF EXISTS healthcare_services;
DROP TABLE IF EXISTS provider_specialties;
DROP TABLE IF EXISTS healthcare_specialties;
DROP TABLE IF EXISTS patient_profiles;
DROP TABLE IF EXISTS healthcare_providers;
DROP TABLE IF EXISTS ride_status_history;
DROP TABLE IF EXISTS ride_fares;
DROP TABLE IF EXISTS driver_locations;
DROP TABLE IF EXISTS rides;
DROP TABLE IF EXISTS ride_requests;
DROP TABLE IF EXISTS driver_documents;
DROP TABLE IF EXISTS driver_profiles;
DROP TABLE IF EXISTS vehicles;
DROP TABLE IF EXISTS vehicle_types;
DROP TABLE IF EXISTS food_delivery_assignments;
DROP TABLE IF EXISTS food_order_status_history;
DROP TABLE IF EXISTS food_order_items;
DROP TABLE IF EXISTS food_orders;
DROP TABLE IF EXISTS food_cart_items;
DROP TABLE IF EXISTS food_carts;
DROP TABLE IF EXISTS menu_items;
DROP TABLE IF EXISTS menu_categories;
DROP TABLE IF EXISTS restaurant_hours;
DROP TABLE IF EXISTS restaurants;
DROP TABLE IF EXISTS marketplace_order_status_history;
DROP TABLE IF EXISTS marketplace_order_items;
DROP TABLE IF EXISTS marketplace_orders;
DROP TABLE IF EXISTS shipping_addresses;
DROP TABLE IF EXISTS marketplace_cart_items;
DROP TABLE IF EXISTS marketplace_carts;
DROP TABLE IF EXISTS inventories;
DROP TABLE IF EXISTS product_images;
DROP TABLE IF EXISTS product_variants;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS marketplace_categories;
DROP TABLE IF EXISTS business_status_history;
DROP TABLE IF EXISTS business_documents;
DROP TABLE IF EXISTS business_hours;
DROP TABLE IF EXISTS business_categories;
DROP TABLE IF EXISTS business_category_links;
DROP TABLE IF EXISTS business_members;
DROP TABLE IF EXISTS businesses;
DROP TABLE IF EXISTS review_replies;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS reports;
DROP TABLE IF EXISTS notification_preferences;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS media;
DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS system_settings;
DROP TABLE IF EXISTS password_reset_tokens;
DROP TABLE IF EXISTS remember_tokens;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS user_addresses;
DROP TABLE IF EXISTS user_profiles;
DROP TABLE IF EXISTS user_roles;
DROP TABLE IF EXISTS role_permissions;
DROP TABLE IF EXISTS permissions;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS locales;

-- ============================================================
-- CORE / IDENTITY / SECURITY
-- ============================================================

CREATE TABLE locales (
    code                VARCHAR(10)  NOT NULL,
    name                VARCHAR(100) NOT NULL,
    native_name         VARCHAR(100) NOT NULL,
    direction           VARCHAR(3)   NOT NULL DEFAULT 'ltr',
    is_active           TINYINT(1)   NOT NULL DEFAULT 1,
    sort_order          INT UNSIGNED NOT NULL DEFAULT 0,
    created_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (code),
    CONSTRAINT chk_locales_direction CHECK (direction IN ('ltr','rtl'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE users (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    email               VARCHAR(191)    NULL,
    phone               VARCHAR(30)     NULL,
    password_hash       VARCHAR(255)    NOT NULL,
    status              VARCHAR(30)     NOT NULL DEFAULT 'active',
    email_verified_at   DATETIME        NULL,
    phone_verified_at   DATETIME        NULL,
    last_login_at       DATETIME        NULL,
    last_login_ip       VARBINARY(16)   NULL,
    failed_login_count  SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    locked_until        DATETIME        NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at          DATETIME        NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_users_email (email),
    UNIQUE KEY uq_users_phone (phone),
    KEY idx_users_status (status),
    KEY idx_users_deleted_at (deleted_at),
    KEY idx_users_last_login_at (last_login_at),
    CONSTRAINT chk_users_status CHECK (status IN ('pending','active','suspended','locked','deleted'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE user_profiles (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id             BIGINT UNSIGNED NOT NULL,
    first_name          VARCHAR(100)    NULL,
    last_name           VARCHAR(100)    NULL,
    display_name        VARCHAR(150)    NULL,
    avatar_media_id     BIGINT UNSIGNED  NULL,
    date_of_birth       DATE             NULL,
    gender              VARCHAR(30)      NULL,
    bio                 TEXT             NULL,
    preferred_locale    VARCHAR(10)      NOT NULL DEFAULT 'fr',
    timezone            VARCHAR(64)      NOT NULL DEFAULT 'Africa/Tunis',
    created_at          DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_user_profiles_user (user_id),
    KEY idx_user_profiles_locale (preferred_locale),
    CONSTRAINT fk_user_profiles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_profiles_locale FOREIGN KEY (preferred_locale) REFERENCES locales(code) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE roles (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    slug                VARCHAR(80)  NOT NULL,
    name                VARCHAR(120) NOT NULL,
    description         VARCHAR(500) NULL,
    is_system           TINYINT(1)   NOT NULL DEFAULT 1,
    created_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_roles_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE permissions (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    slug                VARCHAR(120) NOT NULL,
    name                VARCHAR(150) NOT NULL,
    description         VARCHAR(500) NULL,
    created_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_permissions_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE user_roles (
    user_id             BIGINT UNSIGNED NOT NULL,
    role_id             BIGINT UNSIGNED NOT NULL,
    assigned_by_user_id BIGINT UNSIGNED NULL,
    assigned_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, role_id),
    KEY idx_user_roles_role (role_id),
    CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_assigned_by FOREIGN KEY (assigned_by_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE role_permissions (
    role_id             BIGINT UNSIGNED NOT NULL,
    permission_id       BIGINT UNSIGNED NOT NULL,
    assigned_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (role_id, permission_id),
    KEY idx_role_permissions_permission (permission_id),
    CONSTRAINT fk_role_permissions_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE,
    CONSTRAINT fk_role_permissions_permission FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE sessions (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id             BIGINT UNSIGNED NOT NULL,
    session_token_hash  CHAR(64)        NOT NULL,
    ip_address          VARBINARY(16)   NULL,
    user_agent          VARCHAR(500)    NULL,
    last_activity_at    DATETIME        NOT NULL,
    expires_at          DATETIME        NOT NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_sessions_token_hash (session_token_hash),
    KEY idx_sessions_user (user_id),
    KEY idx_sessions_expires (expires_at),
    CONSTRAINT fk_sessions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE remember_tokens (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id             BIGINT UNSIGNED NOT NULL,
    token_hash          CHAR(64)        NOT NULL,
    expires_at          DATETIME        NOT NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_used_at        DATETIME        NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_remember_tokens_hash (token_hash),
    KEY idx_remember_tokens_user (user_id),
    KEY idx_remember_tokens_expires (expires_at),
    CONSTRAINT fk_remember_tokens_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE password_reset_tokens (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id             BIGINT UNSIGNED NOT NULL,
    token_hash          CHAR(64)        NOT NULL,
    expires_at          DATETIME        NOT NULL,
    used_at             DATETIME        NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_password_reset_token_hash (token_hash),
    KEY idx_password_reset_user (user_id),
    KEY idx_password_reset_expires (expires_at),
    CONSTRAINT fk_password_reset_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE user_addresses (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id             BIGINT UNSIGNED NOT NULL,
    label               VARCHAR(80)     NOT NULL,
    recipient_name      VARCHAR(150)    NULL,
    phone               VARCHAR(30)     NULL,
    address_line1       VARCHAR(255)    NOT NULL,
    address_line2       VARCHAR(255)    NULL,
    city                VARCHAR(120)    NOT NULL,
    state_region        VARCHAR(120)    NULL,
    postal_code         VARCHAR(30)     NULL,
    country_code        CHAR(2)         NOT NULL DEFAULT 'TN',
    latitude            DECIMAL(10,7)   NULL,
    longitude           DECIMAL(10,7)   NULL,
    is_default          TINYINT(1)      NOT NULL DEFAULT 0,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at          DATETIME        NULL,
    PRIMARY KEY (id),
    KEY idx_user_addresses_user (user_id),
    KEY idx_user_addresses_city (city),
    KEY idx_user_addresses_default (user_id, is_default),
    CONSTRAINT fk_user_addresses_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE media (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    uploaded_by_user_id BIGINT UNSIGNED NOT NULL,
    storage_disk        VARCHAR(50)     NOT NULL DEFAULT 'local',
    storage_path        VARCHAR(500)    NOT NULL,
    original_name       VARCHAR(255)    NULL,
    mime_type           VARCHAR(150)    NOT NULL,
    extension           VARCHAR(20)     NULL,
    size_bytes          BIGINT UNSIGNED NOT NULL,
    width_px             INT UNSIGNED    NULL,
    height_px            INT UNSIGNED    NULL,
    checksum_sha256     CHAR(64)        NULL,
    status              VARCHAR(30)     NOT NULL DEFAULT 'active',
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at          DATETIME        NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_media_checksum_path (checksum_sha256, storage_path),
    KEY idx_media_uploaded_by (uploaded_by_user_id),
    KEY idx_media_status (status),
    CONSTRAINT fk_media_user FOREIGN KEY (uploaded_by_user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT chk_media_status CHECK (status IN ('pending','active','quarantined','deleted'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE user_profiles
    ADD CONSTRAINT fk_user_profiles_avatar FOREIGN KEY (avatar_media_id) REFERENCES media(id) ON DELETE SET NULL;

CREATE TABLE notifications (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id             BIGINT UNSIGNED NOT NULL,
    type                VARCHAR(100)    NOT NULL,
    title_key           VARCHAR(191)    NOT NULL,
    body_key            VARCHAR(191)    NULL,
    data_json           JSON            NULL,
    read_at             DATETIME        NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_notifications_user_read (user_id, read_at),
    KEY idx_notifications_created (created_at),
    CONSTRAINT fk_notifications_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE notification_preferences (
    user_id             BIGINT UNSIGNED NOT NULL,
    notification_type   VARCHAR(100)    NOT NULL,
    in_app_enabled      TINYINT(1)      NOT NULL DEFAULT 1,
    email_enabled       TINYINT(1)      NOT NULL DEFAULT 1,
    sms_enabled         TINYINT(1)      NOT NULL DEFAULT 0,
    push_enabled        TINYINT(1)      NOT NULL DEFAULT 0,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, notification_type),
    CONSTRAINT fk_notification_preferences_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE reports (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    reporter_user_id    BIGINT UNSIGNED NULL,
    entity_type         VARCHAR(80)     NOT NULL,
    entity_id           BIGINT UNSIGNED  NOT NULL,
    reason_code         VARCHAR(80)     NOT NULL,
    description         TEXT            NULL,
    status              VARCHAR(30)     NOT NULL DEFAULT 'open',
    resolved_by_user_id BIGINT UNSIGNED NULL,
    resolved_at         DATETIME        NULL,
    resolution_notes    TEXT            NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_reports_entity (entity_type, entity_id),
    KEY idx_reports_status (status),
    KEY idx_reports_reporter (reporter_user_id),
    CONSTRAINT fk_reports_reporter FOREIGN KEY (reporter_user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT fk_reports_resolver FOREIGN KEY (resolved_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_reports_status CHECK (status IN ('open','under_review','resolved','rejected'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE reviews (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    author_user_id      BIGINT UNSIGNED NOT NULL,
    target_type         VARCHAR(80)     NOT NULL,
    target_id           BIGINT UNSIGNED  NOT NULL,
    order_id            BIGINT UNSIGNED  NULL,
    rating              TINYINT UNSIGNED NOT NULL,
    title               VARCHAR(200)    NULL,
    content             TEXT            NULL,
    status              VARCHAR(30)     NOT NULL DEFAULT 'published',
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at          DATETIME        NULL,
    PRIMARY KEY (id),
    KEY idx_reviews_target (target_type, target_id, status),
    KEY idx_reviews_author (author_user_id),
    KEY idx_reviews_created (created_at),
    CONSTRAINT fk_reviews_author FOREIGN KEY (author_user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT chk_reviews_rating CHECK (rating BETWEEN 1 AND 5),
    CONSTRAINT chk_reviews_status CHECK (status IN ('pending','published','hidden','rejected'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE review_replies (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    review_id           BIGINT UNSIGNED NOT NULL,
    author_user_id      BIGINT UNSIGNED NOT NULL,
    content             TEXT            NOT NULL,
    status              VARCHAR(30)     NOT NULL DEFAULT 'published',
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_review_replies_review (review_id),
    CONSTRAINT fk_review_replies_review FOREIGN KEY (review_id) REFERENCES reviews(id) ON DELETE CASCADE,
    CONSTRAINT fk_review_replies_author FOREIGN KEY (author_user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT chk_review_replies_status CHECK (status IN ('pending','published','hidden'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE audit_logs (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    actor_user_id       BIGINT UNSIGNED NULL,
    action              VARCHAR(120)    NOT NULL,
    entity_type         VARCHAR(100)    NULL,
    entity_id           BIGINT UNSIGNED  NULL,
    old_values          JSON            NULL,
    new_values          JSON            NULL,
    ip_address          VARBINARY(16)   NULL,
    user_agent          VARCHAR(500)    NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_audit_actor_created (actor_user_id, created_at),
    KEY idx_audit_entity (entity_type, entity_id),
    KEY idx_audit_action (action),
    CONSTRAINT fk_audit_actor FOREIGN KEY (actor_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE system_settings (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    setting_key         VARCHAR(191)    NOT NULL,
    setting_value       TEXT            NULL,
    value_type          VARCHAR(30)     NOT NULL DEFAULT 'string',
    is_public            TINYINT(1)      NOT NULL DEFAULT 0,
    updated_by_user_id  BIGINT UNSIGNED NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_system_settings_key (setting_key),
    CONSTRAINT fk_system_settings_user FOREIGN KEY (updated_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_system_settings_type CHECK (value_type IN ('string','integer','decimal','boolean','json'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- BUSINESS PLATFORM
-- ============================================================

CREATE TABLE businesses (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    owner_user_id       BIGINT UNSIGNED NOT NULL,
    name                VARCHAR(200)    NOT NULL,
    legal_name          VARCHAR(255)    NULL,
    slug                VARCHAR(191)    NOT NULL,
    description         TEXT            NULL,
    logo_media_id       BIGINT UNSIGNED NULL,
    cover_media_id      BIGINT UNSIGNED NULL,
    email               VARCHAR(191)    NULL,
    phone               VARCHAR(30)     NULL,
    website_url         VARCHAR(500)    NULL,
    tax_identifier      VARCHAR(100)    NULL,
    status              VARCHAR(40)     NOT NULL DEFAULT 'draft',
    verified_at         DATETIME        NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at          DATETIME        NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_businesses_slug (slug),
    KEY idx_businesses_owner (owner_user_id),
    KEY idx_businesses_status (status),
    CONSTRAINT fk_businesses_owner FOREIGN KEY (owner_user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_businesses_logo FOREIGN KEY (logo_media_id) REFERENCES media(id) ON DELETE SET NULL,
    CONSTRAINT fk_businesses_cover FOREIGN KEY (cover_media_id) REFERENCES media(id) ON DELETE SET NULL,
    CONSTRAINT chk_businesses_status CHECK (status IN ('draft','pending_review','approved','rejected','suspended','archived'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE business_members (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    business_id         BIGINT UNSIGNED NOT NULL,
    user_id             BIGINT UNSIGNED NOT NULL,
    member_role         VARCHAR(50)     NOT NULL DEFAULT 'staff',
    status              VARCHAR(30)     NOT NULL DEFAULT 'active',
    invited_by_user_id  BIGINT UNSIGNED NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_business_member (business_id, user_id),
    KEY idx_business_members_user (user_id),
    CONSTRAINT fk_business_members_business FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE,
    CONSTRAINT fk_business_members_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_business_members_inviter FOREIGN KEY (invited_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_business_members_role CHECK (member_role IN ('owner','manager','staff','editor','accountant','driver','provider','teacher','recruiter')),
    CONSTRAINT chk_business_members_status CHECK (status IN ('invited','active','suspended','removed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE business_categories (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name_key            VARCHAR(191)    NOT NULL,
    slug                VARCHAR(191)    NOT NULL,
    parent_id           BIGINT UNSIGNED NULL,
    is_active           TINYINT(1)      NOT NULL DEFAULT 1,
    sort_order          INT UNSIGNED    NOT NULL DEFAULT 0,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_business_categories_slug (slug),
    KEY idx_business_categories_parent (parent_id),
    CONSTRAINT fk_business_categories_parent FOREIGN KEY (parent_id) REFERENCES business_categories(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE business_category_links (
    business_id         BIGINT UNSIGNED NOT NULL,
    category_id         BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (business_id, category_id),
    KEY idx_business_category_links_category (category_id),
    CONSTRAINT fk_business_category_links_business FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE,
    CONSTRAINT fk_business_category_links_category FOREIGN KEY (category_id) REFERENCES business_categories(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE business_hours (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    business_id         BIGINT UNSIGNED NOT NULL,
    day_of_week         TINYINT UNSIGNED NOT NULL,
    opens_at            TIME             NULL,
    closes_at           TIME             NULL,
    is_closed            TINYINT(1)      NOT NULL DEFAULT 0,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_business_hours_day (business_id, day_of_week),
    CONSTRAINT fk_business_hours_business FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE,
    CONSTRAINT chk_business_hours_day CHECK (day_of_week BETWEEN 0 AND 6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE business_documents (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    business_id         BIGINT UNSIGNED NOT NULL,
    media_id             BIGINT UNSIGNED NOT NULL,
    document_type        VARCHAR(80)     NOT NULL,
    status               VARCHAR(30)     NOT NULL DEFAULT 'pending',
    reviewed_by_user_id  BIGINT UNSIGNED  NULL,
    reviewed_at          DATETIME         NULL,
    rejection_reason     TEXT             NULL,
    created_at           DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_business_documents_business (business_id),
    KEY idx_business_documents_status (status),
    CONSTRAINT fk_business_documents_business FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE,
    CONSTRAINT fk_business_documents_media FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE RESTRICT,
    CONSTRAINT fk_business_documents_reviewer FOREIGN KEY (reviewed_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_business_documents_status CHECK (status IN ('pending','approved','rejected','expired'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE business_status_history (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    business_id         BIGINT UNSIGNED NOT NULL,
    old_status          VARCHAR(40) NULL,
    new_status          VARCHAR(40) NOT NULL,
    changed_by_user_id  BIGINT UNSIGNED NULL,
    reason              TEXT NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_business_status_history_business (business_id, created_at),
    CONSTRAINT fk_business_status_history_business FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE CASCADE,
    CONSTRAINT fk_business_status_history_user FOREIGN KEY (changed_by_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- MARKETPLACE
-- ============================================================

CREATE TABLE marketplace_categories (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    parent_id           BIGINT UNSIGNED NULL,
    name_key            VARCHAR(191)    NOT NULL,
    slug                VARCHAR(191)    NOT NULL,
    description_key     VARCHAR(191)    NULL,
    image_media_id      BIGINT UNSIGNED NULL,
    is_active            TINYINT(1)     NOT NULL DEFAULT 1,
    sort_order           INT UNSIGNED   NOT NULL DEFAULT 0,
    created_at           DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_marketplace_categories_slug (slug),
    KEY idx_marketplace_categories_parent (parent_id),
    CONSTRAINT fk_marketplace_categories_parent FOREIGN KEY (parent_id) REFERENCES marketplace_categories(id) ON DELETE SET NULL,
    CONSTRAINT fk_marketplace_categories_image FOREIGN KEY (image_media_id) REFERENCES media(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE products (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    business_id         BIGINT UNSIGNED NOT NULL,
    category_id         BIGINT UNSIGNED NULL,
    name                VARCHAR(255)    NOT NULL,
    slug                VARCHAR(191)    NOT NULL,
    description         TEXT            NULL,
    sku                 VARCHAR(100)    NULL,
    base_price          DECIMAL(14,3)   NOT NULL,
    currency            CHAR(3)         NOT NULL DEFAULT 'TND',
    status              VARCHAR(30)     NOT NULL DEFAULT 'draft',
    published_at        DATETIME        NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at          DATETIME        NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_products_business_slug (business_id, slug),
    UNIQUE KEY uq_products_business_sku (business_id, sku),
    KEY idx_products_category (category_id),
    KEY idx_products_status (business_id, status),
    KEY idx_products_price (base_price),
    CONSTRAINT fk_products_business FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE RESTRICT,
    CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES marketplace_categories(id) ON DELETE SET NULL,
    CONSTRAINT chk_products_price CHECK (base_price >= 0),
    CONSTRAINT chk_products_status CHECK (status IN ('draft','active','out_of_stock','archived','suspended'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE product_variants (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id          BIGINT UNSIGNED NOT NULL,
    name                VARCHAR(255)    NOT NULL,
    sku                 VARCHAR(100)    NULL,
    price               DECIMAL(14,3)   NOT NULL,
    currency            CHAR(3)         NOT NULL DEFAULT 'TND',
    attributes_json     JSON            NULL,
    status              VARCHAR(30)     NOT NULL DEFAULT 'active',
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_product_variants_sku (sku),
    KEY idx_product_variants_product (product_id),
    CONSTRAINT fk_product_variants_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT chk_product_variants_price CHECK (price >= 0),
    CONSTRAINT chk_product_variants_status CHECK (status IN ('active','inactive','archived'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE product_images (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id          BIGINT UNSIGNED NOT NULL,
    media_id             BIGINT UNSIGNED NOT NULL,
    sort_order           INT UNSIGNED NOT NULL DEFAULT 0,
    is_primary           TINYINT(1) NOT NULL DEFAULT 0,
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_product_images_product_media (product_id, media_id),
    KEY idx_product_images_product_order (product_id, sort_order),
    CONSTRAINT fk_product_images_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_product_images_media FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE inventories (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    product_id          BIGINT UNSIGNED NULL,
    variant_id          BIGINT UNSIGNED NULL,
    quantity_available  INT NOT NULL DEFAULT 0,
    quantity_reserved   INT NOT NULL DEFAULT 0,
    reorder_level       INT NOT NULL DEFAULT 0,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_inventories_product (product_id),
    UNIQUE KEY uq_inventories_variant (variant_id),
    CONSTRAINT fk_inventories_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE,
    CONSTRAINT fk_inventories_variant FOREIGN KEY (variant_id) REFERENCES product_variants(id) ON DELETE CASCADE,
    CONSTRAINT chk_inventories_qty CHECK (quantity_available >= 0 AND quantity_reserved >= 0 AND reorder_level >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE marketplace_carts (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id             BIGINT UNSIGNED NOT NULL,
    business_id         BIGINT UNSIGNED NULL,
    status              VARCHAR(30)     NOT NULL DEFAULT 'active',
    currency            CHAR(3)         NOT NULL DEFAULT 'TND',
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_marketplace_carts_user_status (user_id, status),
    KEY idx_marketplace_carts_business (business_id),
    CONSTRAINT fk_marketplace_carts_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_marketplace_carts_business FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE SET NULL,
    CONSTRAINT chk_marketplace_carts_status CHECK (status IN ('active','converted','abandoned'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE marketplace_cart_items (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    cart_id             BIGINT UNSIGNED NOT NULL,
    product_id          BIGINT UNSIGNED NOT NULL,
    variant_id          BIGINT UNSIGNED NULL,
    quantity             INT UNSIGNED NOT NULL,
    unit_price           DECIMAL(14,3) NOT NULL,
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_marketplace_cart_item (cart_id, product_id, variant_id),
    KEY idx_marketplace_cart_items_product (product_id),
    CONSTRAINT fk_marketplace_cart_items_cart FOREIGN KEY (cart_id) REFERENCES marketplace_carts(id) ON DELETE CASCADE,
    CONSTRAINT fk_marketplace_cart_items_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    CONSTRAINT fk_marketplace_cart_items_variant FOREIGN KEY (variant_id) REFERENCES product_variants(id) ON DELETE RESTRICT,
    CONSTRAINT chk_marketplace_cart_items_qty CHECK (quantity > 0),
    CONSTRAINT chk_marketplace_cart_items_price CHECK (unit_price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE shipping_addresses (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id             BIGINT UNSIGNED NOT NULL,
    recipient_name       VARCHAR(150)    NOT NULL,
    phone                VARCHAR(30)     NULL,
    address_line1       VARCHAR(255)     NOT NULL,
    address_line2       VARCHAR(255)     NULL,
    city                VARCHAR(120)     NOT NULL,
    state_region        VARCHAR(120)     NULL,
    postal_code         VARCHAR(30)      NULL,
    country_code        CHAR(2)          NOT NULL DEFAULT 'TN',
    latitude            DECIMAL(10,7)    NULL,
    longitude           DECIMAL(10,7)    NULL,
    created_at          DATETIME         NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_shipping_addresses_order (order_id),
    CONSTRAINT fk_shipping_addresses_order FOREIGN KEY (order_id) REFERENCES marketplace_orders(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE marketplace_orders (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_number        VARCHAR(40)     NOT NULL,
    user_id             BIGINT UNSIGNED  NOT NULL,
    business_id         BIGINT UNSIGNED  NOT NULL,
    currency            CHAR(3)         NOT NULL DEFAULT 'TND',
    subtotal_amount     DECIMAL(14,3)   NOT NULL,
    shipping_amount     DECIMAL(14,3)   NOT NULL DEFAULT 0,
    discount_amount     DECIMAL(14,3)   NOT NULL DEFAULT 0,
    tax_amount          DECIMAL(14,3)   NOT NULL DEFAULT 0,
    total_amount        DECIMAL(14,3)   NOT NULL,
    status              VARCHAR(40)     NOT NULL DEFAULT 'pending',
    payment_status      VARCHAR(30)     NOT NULL DEFAULT 'unpaid',
    notes               TEXT            NULL,
    placed_at           DATETIME        NULL,
    completed_at        DATETIME        NULL,
    cancelled_at        DATETIME        NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_marketplace_orders_number (order_number),
    KEY idx_marketplace_orders_user_created (user_id, created_at),
    KEY idx_marketplace_orders_business_status (business_id, status),
    KEY idx_marketplace_orders_payment_status (payment_status),
    CONSTRAINT fk_marketplace_orders_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_marketplace_orders_business FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE RESTRICT,
    CONSTRAINT chk_marketplace_orders_amounts CHECK (subtotal_amount >= 0 AND shipping_amount >= 0 AND discount_amount >= 0 AND tax_amount >= 0 AND total_amount >= 0),
    CONSTRAINT chk_marketplace_orders_status CHECK (status IN ('pending','confirmed','processing','ready','shipped','out_for_delivery','delivered','cancelled','refunded','failed')),
    CONSTRAINT chk_marketplace_orders_payment_status CHECK (payment_status IN ('unpaid','authorized','paid','partially_refunded','refunded','failed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

ALTER TABLE reviews
    ADD CONSTRAINT fk_reviews_order FOREIGN KEY (order_id) REFERENCES marketplace_orders(id) ON DELETE SET NULL;

CREATE TABLE marketplace_order_items (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id            BIGINT UNSIGNED NOT NULL,
    product_id          BIGINT UNSIGNED NOT NULL,
    variant_id          BIGINT UNSIGNED NULL,
    product_name        VARCHAR(255)    NOT NULL,
    variant_name        VARCHAR(255)    NULL,
    sku                 VARCHAR(100)    NULL,
    quantity            INT UNSIGNED    NOT NULL,
    unit_price          DECIMAL(14,3)   NOT NULL,
    total_price         DECIMAL(14,3)   NOT NULL,
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_marketplace_order_items_order (order_id),
    KEY idx_marketplace_order_items_product (product_id),
    CONSTRAINT fk_marketplace_order_items_order FOREIGN KEY (order_id) REFERENCES marketplace_orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_marketplace_order_items_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    CONSTRAINT fk_marketplace_order_items_variant FOREIGN KEY (variant_id) REFERENCES product_variants(id) ON DELETE SET NULL,
    CONSTRAINT chk_marketplace_order_items_values CHECK (quantity > 0 AND unit_price >= 0 AND total_price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE marketplace_order_status_history (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id             BIGINT UNSIGNED NOT NULL,
    old_status           VARCHAR(40) NULL,
    new_status           VARCHAR(40) NOT NULL,
    changed_by_user_id   BIGINT UNSIGNED NULL,
    notes                TEXT NULL,
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_marketplace_order_status_history_order (order_id, created_at),
    CONSTRAINT fk_marketplace_order_status_history_order FOREIGN KEY (order_id) REFERENCES marketplace_orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_marketplace_order_status_history_user FOREIGN KEY (changed_by_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- FOOD DELIVERY
-- ============================================================

CREATE TABLE restaurants (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    business_id         BIGINT UNSIGNED NOT NULL,
    name                VARCHAR(200)    NOT NULL,
    slug                VARCHAR(191)    NOT NULL,
    description         TEXT            NULL,
    logo_media_id       BIGINT UNSIGNED NULL,
    cover_media_id      BIGINT UNSIGNED NULL,
    address_line1       VARCHAR(255)    NULL,
    city                VARCHAR(120)    NULL,
    latitude            DECIMAL(10,7)   NULL,
    longitude           DECIMAL(10,7)   NULL,
    min_order_amount    DECIMAL(14,3)   NOT NULL DEFAULT 0,
    delivery_fee        DECIMAL(14,3)   NOT NULL DEFAULT 0,
    avg_preparation_min SMALLINT UNSIGNED NOT NULL DEFAULT 30,
    status              VARCHAR(30)     NOT NULL DEFAULT 'draft',
    created_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at          DATETIME        NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_restaurants_business_slug (business_id, slug),
    KEY idx_restaurants_city_status (city, status),
    CONSTRAINT fk_restaurants_business FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE RESTRICT,
    CONSTRAINT fk_restaurants_logo FOREIGN KEY (logo_media_id) REFERENCES media(id) ON DELETE SET NULL,
    CONSTRAINT fk_restaurants_cover FOREIGN KEY (cover_media_id) REFERENCES media(id) ON DELETE SET NULL,
    CONSTRAINT chk_restaurants_status CHECK (status IN ('draft','open','closed','suspended','archived')),
    CONSTRAINT chk_restaurants_amounts CHECK (min_order_amount >= 0 AND delivery_fee >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE restaurant_hours (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    restaurant_id       BIGINT UNSIGNED NOT NULL,
    day_of_week         TINYINT UNSIGNED NOT NULL,
    opens_at            TIME NULL,
    closes_at           TIME NULL,
    is_closed           TINYINT(1) NOT NULL DEFAULT 0,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_restaurant_hours_day (restaurant_id, day_of_week),
    CONSTRAINT fk_restaurant_hours_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    CONSTRAINT chk_restaurant_hours_day CHECK (day_of_week BETWEEN 0 AND 6)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE menu_categories (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    restaurant_id       BIGINT UNSIGNED NOT NULL,
    name                VARCHAR(150) NOT NULL,
    description         VARCHAR(500) NULL,
    sort_order           INT UNSIGNED NOT NULL DEFAULT 0,
    status              VARCHAR(30) NOT NULL DEFAULT 'active',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_menu_categories_restaurant (restaurant_id, sort_order),
    CONSTRAINT fk_menu_categories_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE CASCADE,
    CONSTRAINT chk_menu_categories_status CHECK (status IN ('active','inactive'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE menu_items (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    menu_category_id    BIGINT UNSIGNED NOT NULL,
    name                VARCHAR(200) NOT NULL,
    description         TEXT NULL,
    price               DECIMAL(14,3) NOT NULL,
    currency            CHAR(3) NOT NULL DEFAULT 'TND',
    image_media_id      BIGINT UNSIGNED NULL,
    is_available        TINYINT(1) NOT NULL DEFAULT 1,
    sort_order          INT UNSIGNED NOT NULL DEFAULT 0,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at          DATETIME NULL,
    PRIMARY KEY (id),
    KEY idx_menu_items_category_order (menu_category_id, sort_order),
    KEY idx_menu_items_available (menu_category_id, is_available),
    CONSTRAINT fk_menu_items_category FOREIGN KEY (menu_category_id) REFERENCES menu_categories(id) ON DELETE CASCADE,
    CONSTRAINT fk_menu_items_image FOREIGN KEY (image_media_id) REFERENCES media(id) ON DELETE SET NULL,
    CONSTRAINT chk_menu_items_price CHECK (price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE food_carts (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id             BIGINT UNSIGNED NOT NULL,
    restaurant_id       BIGINT UNSIGNED NOT NULL,
    status              VARCHAR(30) NOT NULL DEFAULT 'active',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_food_carts_user_status (user_id, status),
    KEY idx_food_carts_restaurant (restaurant_id),
    CONSTRAINT fk_food_carts_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_food_carts_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE RESTRICT,
    CONSTRAINT chk_food_carts_status CHECK (status IN ('active','converted','abandoned'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE food_cart_items (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    cart_id             BIGINT UNSIGNED NOT NULL,
    menu_item_id        BIGINT UNSIGNED NOT NULL,
    quantity            INT UNSIGNED NOT NULL,
    unit_price          DECIMAL(14,3) NOT NULL,
    notes               VARCHAR(500) NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_food_cart_item (cart_id, menu_item_id),
    CONSTRAINT fk_food_cart_items_cart FOREIGN KEY (cart_id) REFERENCES food_carts(id) ON DELETE CASCADE,
    CONSTRAINT fk_food_cart_items_menu_item FOREIGN KEY (menu_item_id) REFERENCES menu_items(id) ON DELETE RESTRICT,
    CONSTRAINT chk_food_cart_items_values CHECK (quantity > 0 AND unit_price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE food_orders (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_number        VARCHAR(40) NOT NULL,
    user_id             BIGINT UNSIGNED NOT NULL,
    restaurant_id       BIGINT UNSIGNED NOT NULL,
    currency            CHAR(3) NOT NULL DEFAULT 'TND',
    subtotal_amount     DECIMAL(14,3) NOT NULL,
    delivery_fee        DECIMAL(14,3) NOT NULL DEFAULT 0,
    discount_amount     DECIMAL(14,3) NOT NULL DEFAULT 0,
    tax_amount          DECIMAL(14,3) NOT NULL DEFAULT 0,
    total_amount        DECIMAL(14,3) NOT NULL,
    status              VARCHAR(40) NOT NULL DEFAULT 'pending',
    payment_status      VARCHAR(30) NOT NULL DEFAULT 'unpaid',
    delivery_address    JSON NOT NULL,
    customer_notes      TEXT NULL,
    placed_at           DATETIME NULL,
    delivered_at        DATETIME NULL,
    cancelled_at        DATETIME NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_food_orders_number (order_number),
    KEY idx_food_orders_user_created (user_id, created_at),
    KEY idx_food_orders_restaurant_status (restaurant_id, status),
    KEY idx_food_orders_payment_status (payment_status),
    CONSTRAINT fk_food_orders_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_food_orders_restaurant FOREIGN KEY (restaurant_id) REFERENCES restaurants(id) ON DELETE RESTRICT,
    CONSTRAINT chk_food_orders_amounts CHECK (subtotal_amount >= 0 AND delivery_fee >= 0 AND discount_amount >= 0 AND tax_amount >= 0 AND total_amount >= 0),
    CONSTRAINT chk_food_orders_status CHECK (status IN ('pending','confirmed','preparing','ready','assigned','out_for_delivery','delivered','cancelled','refunded','failed')),
    CONSTRAINT chk_food_orders_payment_status CHECK (payment_status IN ('unpaid','authorized','paid','partially_refunded','refunded','failed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE food_order_items (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    order_id            BIGINT UNSIGNED NOT NULL,
    menu_item_id        BIGINT UNSIGNED NOT NULL,
    item_name           VARCHAR(200) NOT NULL,
    quantity            INT UNSIGNED NOT NULL,
    unit_price          DECIMAL(14,3) NOT NULL,
    total_price         DECIMAL(14,3) NOT NULL,
    notes               VARCHAR(500) NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_food_order_items_order (order_id),
    CONSTRAINT fk_food_order_items_order FOREIGN KEY (order_id) REFERENCES food_orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_food_order_items_menu_item FOREIGN KEY (menu_item_id) REFERENCES menu_items(id) ON DELETE RESTRICT,
    CONSTRAINT chk_food_order_items_values CHECK (quantity > 0 AND unit_price >= 0 AND total_price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE food_order_status_history (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    food_order_id       BIGINT UNSIGNED NOT NULL,
    old_status          VARCHAR(40) NULL,
    new_status          VARCHAR(40) NOT NULL,
    changed_by_user_id  BIGINT UNSIGNED NULL,
    notes               TEXT NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_food_order_status_history_order (food_order_id, created_at),
    CONSTRAINT fk_food_order_status_history_order FOREIGN KEY (food_order_id) REFERENCES food_orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_food_order_status_history_user FOREIGN KEY (changed_by_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE food_delivery_assignments (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    food_order_id       BIGINT UNSIGNED NOT NULL,
    driver_user_id      BIGINT UNSIGNED NULL,
    status              VARCHAR(30) NOT NULL DEFAULT 'pending',
    accepted_at         DATETIME NULL,
    picked_up_at        DATETIME NULL,
    delivered_at        DATETIME NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_food_delivery_assignment_order (food_order_id),
    KEY idx_food_delivery_assignment_driver (driver_user_id, status),
    CONSTRAINT fk_food_delivery_assignment_order FOREIGN KEY (food_order_id) REFERENCES food_orders(id) ON DELETE CASCADE,
    CONSTRAINT fk_food_delivery_assignment_driver FOREIGN KEY (driver_user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_food_delivery_assignment_status CHECK (status IN ('pending','assigned','accepted','picked_up','delivered','cancelled'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- TRANSPORTATION
-- ============================================================

CREATE TABLE vehicle_types (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name_key             VARCHAR(191) NOT NULL,
    slug                 VARCHAR(100) NOT NULL,
    max_passengers       TINYINT UNSIGNED NOT NULL DEFAULT 4,
    base_fare            DECIMAL(14,3) NOT NULL DEFAULT 0,
    per_km_fare          DECIMAL(14,3) NOT NULL DEFAULT 0,
    per_minute_fare      DECIMAL(14,3) NOT NULL DEFAULT 0,
    is_active             TINYINT(1) NOT NULL DEFAULT 1,
    created_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at            DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_vehicle_types_slug (slug),
    CONSTRAINT chk_vehicle_types_amounts CHECK (base_fare >= 0 AND per_km_fare >= 0 AND per_minute_fare >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE vehicles (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    driver_user_id      BIGINT UNSIGNED NOT NULL,
    vehicle_type_id     BIGINT UNSIGNED NOT NULL,
    make                VARCHAR(100) NULL,
    model               VARCHAR(100) NULL,
    model_year          SMALLINT UNSIGNED NULL,
    color               VARCHAR(50) NULL,
    plate_number        VARCHAR(50) NOT NULL,
    status              VARCHAR(30) NOT NULL DEFAULT 'pending',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_vehicles_plate (plate_number),
    KEY idx_vehicles_driver_status (driver_user_id, status),
    CONSTRAINT fk_vehicles_driver FOREIGN KEY (driver_user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_vehicles_type FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id) ON DELETE RESTRICT,
    CONSTRAINT chk_vehicles_status CHECK (status IN ('pending','approved','suspended','inactive'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE driver_profiles (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id             BIGINT UNSIGNED NOT NULL,
    verification_status VARCHAR(30) NOT NULL DEFAULT 'pending',
    rating_average      DECIMAL(3,2) NOT NULL DEFAULT 0,
    total_rides         INT UNSIGNED NOT NULL DEFAULT 0,
    is_online           TINYINT(1) NOT NULL DEFAULT 0,
    current_latitude    DECIMAL(10,7) NULL,
    current_longitude   DECIMAL(10,7) NULL,
    last_location_at    DATETIME NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_driver_profiles_user (user_id),
    KEY idx_driver_profiles_online (is_online, verification_status),
    CONSTRAINT fk_driver_profiles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT chk_driver_profiles_verification CHECK (verification_status IN ('pending','approved','rejected','suspended')),
    CONSTRAINT chk_driver_profiles_rating CHECK (rating_average BETWEEN 0 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE driver_documents (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    driver_profile_id   BIGINT UNSIGNED NOT NULL,
    media_id            BIGINT UNSIGNED NOT NULL,
    document_type       VARCHAR(80) NOT NULL,
    document_number     VARCHAR(150) NULL,
    expires_at          DATE NULL,
    status              VARCHAR(30) NOT NULL DEFAULT 'pending',
    reviewed_by_user_id BIGINT UNSIGNED NULL,
    reviewed_at         DATETIME NULL,
    rejection_reason    TEXT NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_driver_documents_driver (driver_profile_id),
    KEY idx_driver_documents_status (status),
    CONSTRAINT fk_driver_documents_driver FOREIGN KEY (driver_profile_id) REFERENCES driver_profiles(id) ON DELETE CASCADE,
    CONSTRAINT fk_driver_documents_media FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE RESTRICT,
    CONSTRAINT fk_driver_documents_reviewer FOREIGN KEY (reviewed_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_driver_documents_status CHECK (status IN ('pending','approved','rejected','expired'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ride_requests (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    request_number      VARCHAR(40) NOT NULL,
    passenger_user_id   BIGINT UNSIGNED NOT NULL,
    vehicle_type_id     BIGINT UNSIGNED NOT NULL,
    pickup_address      JSON NOT NULL,
    destination_address JSON NOT NULL,
    requested_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status              VARCHAR(40) NOT NULL DEFAULT 'searching',
    estimated_distance_km DECIMAL(10,2) NULL,
    estimated_duration_min INT UNSIGNED NULL,
    estimated_fare      DECIMAL(14,3) NULL,
    currency            CHAR(3) NOT NULL DEFAULT 'TND',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_ride_requests_number (request_number),
    KEY idx_ride_requests_passenger_status (passenger_user_id, status),
    KEY idx_ride_requests_status_created (status, created_at),
    CONSTRAINT fk_ride_requests_passenger FOREIGN KEY (passenger_user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_ride_requests_vehicle_type FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_types(id) ON DELETE RESTRICT,
    CONSTRAINT chk_ride_requests_status CHECK (status IN ('searching','matched','accepted','expired','cancelled','completed')),
    CONSTRAINT chk_ride_requests_estimates CHECK (estimated_fare IS NULL OR estimated_fare >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE rides (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    ride_request_id     BIGINT UNSIGNED NOT NULL,
    driver_user_id      BIGINT UNSIGNED NOT NULL,
    vehicle_id          BIGINT UNSIGNED NOT NULL,
    status              VARCHAR(40) NOT NULL DEFAULT 'assigned',
    actual_distance_km  DECIMAL(10,2) NULL,
    actual_duration_min INT UNSIGNED NULL,
    started_at          DATETIME NULL,
    completed_at        DATETIME NULL,
    cancelled_at        DATETIME NULL,
    cancellation_reason TEXT NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_rides_request (ride_request_id),
    KEY idx_rides_driver_status (driver_user_id, status),
    KEY idx_rides_status_created (status, created_at),
    CONSTRAINT fk_rides_request FOREIGN KEY (ride_request_id) REFERENCES ride_requests(id) ON DELETE RESTRICT,
    CONSTRAINT fk_rides_driver FOREIGN KEY (driver_user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_rides_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles(id) ON DELETE RESTRICT,
    CONSTRAINT chk_rides_status CHECK (status IN ('assigned','driver_arriving','passenger_onboard','in_progress','completed','cancelled','no_show'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ride_fares (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    ride_id             BIGINT UNSIGNED NOT NULL,
    base_fare           DECIMAL(14,3) NOT NULL,
    distance_fare       DECIMAL(14,3) NOT NULL DEFAULT 0,
    time_fare           DECIMAL(14,3) NOT NULL DEFAULT 0,
    surge_amount        DECIMAL(14,3) NOT NULL DEFAULT 0,
    discount_amount     DECIMAL(14,3) NOT NULL DEFAULT 0,
    tax_amount          DECIMAL(14,3) NOT NULL DEFAULT 0,
    total_amount        DECIMAL(14,3) NOT NULL,
    currency            CHAR(3) NOT NULL DEFAULT 'TND',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_ride_fares_ride (ride_id),
    CONSTRAINT fk_ride_fares_ride FOREIGN KEY (ride_id) REFERENCES rides(id) ON DELETE CASCADE,
    CONSTRAINT chk_ride_fares_amounts CHECK (base_fare >= 0 AND distance_fare >= 0 AND time_fare >= 0 AND surge_amount >= 0 AND discount_amount >= 0 AND tax_amount >= 0 AND total_amount >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE ride_status_history (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    ride_id              BIGINT UNSIGNED NOT NULL,
    old_status           VARCHAR(40) NULL,
    new_status           VARCHAR(40) NOT NULL,
    changed_by_user_id   BIGINT UNSIGNED NULL,
    notes                TEXT NULL,
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_ride_status_history_ride (ride_id, created_at),
    CONSTRAINT fk_ride_status_history_ride FOREIGN KEY (ride_id) REFERENCES rides(id) ON DELETE CASCADE,
    CONSTRAINT fk_ride_status_history_user FOREIGN KEY (changed_by_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE driver_locations (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    driver_user_id      BIGINT UNSIGNED NOT NULL,
    latitude            DECIMAL(10,7) NOT NULL,
    longitude           DECIMAL(10,7) NOT NULL,
    accuracy_meters     DECIMAL(10,2) NULL,
    recorded_at         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_driver_locations_driver_time (driver_user_id, recorded_at),
    CONSTRAINT fk_driver_locations_driver FOREIGN KEY (driver_user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- HEALTHCARE
-- ============================================================

CREATE TABLE healthcare_providers (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    business_id         BIGINT UNSIGNED NOT NULL,
    user_id             BIGINT UNSIGNED NULL,
    provider_type       VARCHAR(50) NOT NULL DEFAULT 'professional',
    professional_title  VARCHAR(150) NULL,
    license_number      VARCHAR(150) NULL,
    bio                 TEXT NULL,
    status              VARCHAR(30) NOT NULL DEFAULT 'pending',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_healthcare_provider_license (license_number),
    KEY idx_healthcare_providers_business (business_id),
    KEY idx_healthcare_providers_user (user_id),
    KEY idx_healthcare_providers_status (status),
    CONSTRAINT fk_healthcare_providers_business FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE RESTRICT,
    CONSTRAINT fk_healthcare_providers_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_healthcare_providers_status CHECK (status IN ('pending','approved','suspended','archived'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE healthcare_specialties (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name_key            VARCHAR(191) NOT NULL,
    slug                VARCHAR(191) NOT NULL,
    is_active            TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    UNIQUE KEY uq_healthcare_specialties_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE provider_specialties (
    provider_id         BIGINT UNSIGNED NOT NULL,
    specialty_id        BIGINT UNSIGNED NOT NULL,
    is_primary           TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (provider_id, specialty_id),
    KEY idx_provider_specialties_specialty (specialty_id),
    CONSTRAINT fk_provider_specialties_provider FOREIGN KEY (provider_id) REFERENCES healthcare_providers(id) ON DELETE CASCADE,
    CONSTRAINT fk_provider_specialties_specialty FOREIGN KEY (specialty_id) REFERENCES healthcare_specialties(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE healthcare_services (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    business_id         BIGINT UNSIGNED NOT NULL,
    name                VARCHAR(200) NOT NULL,
    description         TEXT NULL,
    duration_minutes    SMALLINT UNSIGNED NOT NULL DEFAULT 30,
    price               DECIMAL(14,3) NOT NULL DEFAULT 0,
    currency            CHAR(3) NOT NULL DEFAULT 'TND',
    status              VARCHAR(30) NOT NULL DEFAULT 'active',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_healthcare_services_business_status (business_id, status),
    CONSTRAINT fk_healthcare_services_business FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE RESTRICT,
    CONSTRAINT chk_healthcare_services_price CHECK (price >= 0),
    CONSTRAINT chk_healthcare_services_status CHECK (status IN ('active','inactive','archived'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE provider_services (
    provider_id         BIGINT UNSIGNED NOT NULL,
    service_id          BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (provider_id, service_id),
    KEY idx_provider_services_service (service_id),
    CONSTRAINT fk_provider_services_provider FOREIGN KEY (provider_id) REFERENCES healthcare_providers(id) ON DELETE CASCADE,
    CONSTRAINT fk_provider_services_service FOREIGN KEY (service_id) REFERENCES healthcare_services(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE provider_availability (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    provider_id         BIGINT UNSIGNED NOT NULL,
    day_of_week         TINYINT UNSIGNED NOT NULL,
    start_time          TIME NOT NULL,
    end_time            TIME NOT NULL,
    is_active            TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    KEY idx_provider_availability_provider_day (provider_id, day_of_week),
    CONSTRAINT fk_provider_availability_provider FOREIGN KEY (provider_id) REFERENCES healthcare_providers(id) ON DELETE CASCADE,
    CONSTRAINT chk_provider_availability_day CHECK (day_of_week BETWEEN 0 AND 6),
    CONSTRAINT chk_provider_availability_time CHECK (start_time < end_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE patient_profiles (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id             BIGINT UNSIGNED NOT NULL,
    emergency_contact_name VARCHAR(150) NULL,
    emergency_contact_phone VARCHAR(30) NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_patient_profiles_user (user_id),
    CONSTRAINT fk_patient_profiles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE appointments (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    appointment_number  VARCHAR(40) NOT NULL,
    patient_user_id     BIGINT UNSIGNED NOT NULL,
    provider_id         BIGINT UNSIGNED NOT NULL,
    service_id          BIGINT UNSIGNED NOT NULL,
    starts_at           DATETIME NOT NULL,
    ends_at             DATETIME NOT NULL,
    status              VARCHAR(40) NOT NULL DEFAULT 'pending',
    price               DECIMAL(14,3) NOT NULL DEFAULT 0,
    currency            CHAR(3) NOT NULL DEFAULT 'TND',
    notes               TEXT NULL,
    patient_notes       TEXT NULL,
    confirmed_at        DATETIME NULL,
    cancelled_at        DATETIME NULL,
    completed_at        DATETIME NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_appointments_number (appointment_number),
    KEY idx_appointments_patient_start (patient_user_id, starts_at),
    KEY idx_appointments_provider_start (provider_id, starts_at),
    KEY idx_appointments_status_start (status, starts_at),
    CONSTRAINT fk_appointments_patient FOREIGN KEY (patient_user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_appointments_provider FOREIGN KEY (provider_id) REFERENCES healthcare_providers(id) ON DELETE RESTRICT,
    CONSTRAINT fk_appointments_service FOREIGN KEY (service_id) REFERENCES healthcare_services(id) ON DELETE RESTRICT,
    CONSTRAINT chk_appointments_time CHECK (starts_at < ends_at),
    CONSTRAINT chk_appointments_price CHECK (price >= 0),
    CONSTRAINT chk_appointments_status CHECK (status IN ('pending','confirmed','in_progress','completed','cancelled','no_show','rejected'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE appointment_status_history (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    appointment_id      BIGINT UNSIGNED NOT NULL,
    old_status          VARCHAR(40) NULL,
    new_status          VARCHAR(40) NOT NULL,
    changed_by_user_id  BIGINT UNSIGNED NULL,
    notes               TEXT NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_appointment_status_history_appointment (appointment_id, created_at),
    CONSTRAINT fk_appointment_status_history_appointment FOREIGN KEY (appointment_id) REFERENCES appointments(id) ON DELETE CASCADE,
    CONSTRAINT fk_appointment_status_history_user FOREIGN KEY (changed_by_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- EDUCATION
-- ============================================================

CREATE TABLE education_institutions (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    business_id         BIGINT UNSIGNED NOT NULL,
    name                VARCHAR(200) NOT NULL,
    slug                VARCHAR(191) NOT NULL,
    description         TEXT NULL,
    institution_type    VARCHAR(80) NULL,
    address_line1       VARCHAR(255) NULL,
    city                VARCHAR(120) NULL,
    website_url         VARCHAR(500) NULL,
    status              VARCHAR(30) NOT NULL DEFAULT 'pending',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at          DATETIME NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_education_institutions_business_slug (business_id, slug),
    KEY idx_education_institutions_status (status),
    CONSTRAINT fk_education_institutions_business FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE RESTRICT,
    CONSTRAINT chk_education_institutions_status CHECK (status IN ('pending','approved','suspended','archived'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE institution_staff (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    institution_id      BIGINT UNSIGNED NOT NULL,
    user_id             BIGINT UNSIGNED NOT NULL,
    staff_role           VARCHAR(50) NOT NULL DEFAULT 'teacher',
    status              VARCHAR(30) NOT NULL DEFAULT 'active',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_institution_staff (institution_id, user_id),
    KEY idx_institution_staff_user (user_id),
    CONSTRAINT fk_institution_staff_institution FOREIGN KEY (institution_id) REFERENCES education_institutions(id) ON DELETE CASCADE,
    CONSTRAINT fk_institution_staff_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT chk_institution_staff_status CHECK (status IN ('active','inactive','suspended'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE course_categories (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name_key            VARCHAR(191) NOT NULL,
    slug                VARCHAR(191) NOT NULL,
    parent_id           BIGINT UNSIGNED NULL,
    is_active            TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    UNIQUE KEY uq_course_categories_slug (slug),
    KEY idx_course_categories_parent (parent_id),
    CONSTRAINT fk_course_categories_parent FOREIGN KEY (parent_id) REFERENCES course_categories(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE courses (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    institution_id      BIGINT UNSIGNED NOT NULL,
    category_id         BIGINT UNSIGNED NULL,
    instructor_user_id  BIGINT UNSIGNED NULL,
    title               VARCHAR(255) NOT NULL,
    slug                VARCHAR(191) NOT NULL,
    description         TEXT NULL,
    level               VARCHAR(50) NULL,
    price               DECIMAL(14,3) NOT NULL DEFAULT 0,
    currency            CHAR(3) NOT NULL DEFAULT 'TND',
    status              VARCHAR(30) NOT NULL DEFAULT 'draft',
    published_at        DATETIME NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at          DATETIME NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_courses_institution_slug (institution_id, slug),
    KEY idx_courses_category_status (category_id, status),
    KEY idx_courses_instructor (instructor_user_id),
    CONSTRAINT fk_courses_institution FOREIGN KEY (institution_id) REFERENCES education_institutions(id) ON DELETE RESTRICT,
    CONSTRAINT fk_courses_category FOREIGN KEY (category_id) REFERENCES course_categories(id) ON DELETE SET NULL,
    CONSTRAINT fk_courses_instructor FOREIGN KEY (instructor_user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_courses_price CHECK (price >= 0),
    CONSTRAINT chk_courses_status CHECK (status IN ('draft','published','archived','suspended'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE course_sections (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    course_id            BIGINT UNSIGNED NOT NULL,
    title                VARCHAR(255) NOT NULL,
    sort_order           INT UNSIGNED NOT NULL DEFAULT 0,
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_course_sections_course_order (course_id, sort_order),
    CONSTRAINT fk_course_sections_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE lessons (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    section_id           BIGINT UNSIGNED NOT NULL,
    title                VARCHAR(255) NOT NULL,
    content              LONGTEXT NULL,
    duration_minutes     INT UNSIGNED NULL,
    sort_order           INT UNSIGNED NOT NULL DEFAULT 0,
    status               VARCHAR(30) NOT NULL DEFAULT 'draft',
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_lessons_section_order (section_id, sort_order),
    CONSTRAINT fk_lessons_section FOREIGN KEY (section_id) REFERENCES course_sections(id) ON DELETE CASCADE,
    CONSTRAINT chk_lessons_status CHECK (status IN ('draft','published','archived'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE course_materials (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    lesson_id           BIGINT UNSIGNED NOT NULL,
    media_id            BIGINT UNSIGNED NOT NULL,
    material_type       VARCHAR(50) NOT NULL DEFAULT 'file',
    title               VARCHAR(255) NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_course_materials_lesson (lesson_id),
    CONSTRAINT fk_course_materials_lesson FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    CONSTRAINT fk_course_materials_media FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE enrollments (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    course_id            BIGINT UNSIGNED NOT NULL,
    student_user_id      BIGINT UNSIGNED NOT NULL,
    status               VARCHAR(30) NOT NULL DEFAULT 'active',
    price_paid           DECIMAL(14,3) NOT NULL DEFAULT 0,
    currency             CHAR(3) NOT NULL DEFAULT 'TND',
    enrolled_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at         DATETIME NULL,
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_enrollments_course_student (course_id, student_user_id),
    KEY idx_enrollments_student_status (student_user_id, status),
    CONSTRAINT fk_enrollments_course FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE RESTRICT,
    CONSTRAINT fk_enrollments_student FOREIGN KEY (student_user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT chk_enrollments_status CHECK (status IN ('active','completed','cancelled','suspended')),
    CONSTRAINT chk_enrollments_price CHECK (price_paid >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE student_progress (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    enrollment_id       BIGINT UNSIGNED NOT NULL,
    lesson_id           BIGINT UNSIGNED NOT NULL,
    progress_percent    DECIMAL(5,2) NOT NULL DEFAULT 0,
    completed_at        DATETIME NULL,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_student_progress_lesson (enrollment_id, lesson_id),
    CONSTRAINT fk_student_progress_enrollment FOREIGN KEY (enrollment_id) REFERENCES enrollments(id) ON DELETE CASCADE,
    CONSTRAINT fk_student_progress_lesson FOREIGN KEY (lesson_id) REFERENCES lessons(id) ON DELETE CASCADE,
    CONSTRAINT chk_student_progress_percent CHECK (progress_percent BETWEEN 0 AND 100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- JOBS
-- ============================================================

CREATE TABLE employer_profiles (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    business_id         BIGINT UNSIGNED NOT NULL,
    contact_user_id     BIGINT UNSIGNED NULL,
    description         TEXT NULL,
    status              VARCHAR(30) NOT NULL DEFAULT 'active',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_employer_profiles_business (business_id),
    CONSTRAINT fk_employer_profiles_business FOREIGN KEY (business_id) REFERENCES businesses(id) ON DELETE RESTRICT,
    CONSTRAINT fk_employer_profiles_contact FOREIGN KEY (contact_user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_employer_profiles_status CHECK (status IN ('active','inactive','suspended'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE job_categories (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name_key            VARCHAR(191) NOT NULL,
    slug                VARCHAR(191) NOT NULL,
    parent_id           BIGINT UNSIGNED NULL,
    is_active            TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    UNIQUE KEY uq_job_categories_slug (slug),
    KEY idx_job_categories_parent (parent_id),
    CONSTRAINT fk_job_categories_parent FOREIGN KEY (parent_id) REFERENCES job_categories(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE jobs (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    employer_profile_id BIGINT UNSIGNED NOT NULL,
    category_id         BIGINT UNSIGNED NULL,
    title               VARCHAR(255) NOT NULL,
    slug                VARCHAR(191) NOT NULL,
    description         LONGTEXT NOT NULL,
    employment_type     VARCHAR(50) NOT NULL,
    workplace_type      VARCHAR(50) NOT NULL DEFAULT 'on_site',
    salary_min          DECIMAL(14,3) NULL,
    salary_max          DECIMAL(14,3) NULL,
    currency            CHAR(3) NOT NULL DEFAULT 'TND',
    status              VARCHAR(30) NOT NULL DEFAULT 'draft',
    published_at        DATETIME NULL,
    closes_at           DATETIME NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at          DATETIME NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_jobs_employer_slug (employer_profile_id, slug),
    KEY idx_jobs_category_status (category_id, status),
    KEY idx_jobs_status_closes (status, closes_at),
    CONSTRAINT fk_jobs_employer FOREIGN KEY (employer_profile_id) REFERENCES employer_profiles(id) ON DELETE RESTRICT,
    CONSTRAINT fk_jobs_category FOREIGN KEY (category_id) REFERENCES job_categories(id) ON DELETE SET NULL,
    CONSTRAINT chk_jobs_salary CHECK ((salary_min IS NULL OR salary_min >= 0) AND (salary_max IS NULL OR salary_max >= 0) AND (salary_min IS NULL OR salary_max IS NULL OR salary_max >= salary_min)),
    CONSTRAINT chk_jobs_status CHECK (status IN ('draft','published','paused','closed','archived'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE job_locations (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    job_id               BIGINT UNSIGNED NOT NULL,
    city                VARCHAR(120) NOT NULL,
    state_region        VARCHAR(120) NULL,
    country_code        CHAR(2) NOT NULL DEFAULT 'TN',
    latitude            DECIMAL(10,7) NULL,
    longitude           DECIMAL(10,7) NULL,
    is_remote            TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    KEY idx_job_locations_job (job_id),
    KEY idx_job_locations_city (city),
    CONSTRAINT fk_job_locations_job FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE job_skills (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name                VARCHAR(150) NOT NULL,
    slug                VARCHAR(191) NOT NULL,
    is_active            TINYINT(1) NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    UNIQUE KEY uq_job_skills_slug (slug)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE job_skill_links (
    job_id               BIGINT UNSIGNED NOT NULL,
    skill_id             BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (job_id, skill_id),
    KEY idx_job_skill_links_skill (skill_id),
    CONSTRAINT fk_job_skill_links_job FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE CASCADE,
    CONSTRAINT fk_job_skill_links_skill FOREIGN KEY (skill_id) REFERENCES job_skills(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE resumes (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id             BIGINT UNSIGNED NOT NULL,
    media_id            BIGINT UNSIGNED NULL,
    title               VARCHAR(200) NOT NULL,
    summary             TEXT NULL,
    skills_json         JSON NULL,
    experience_json     JSON NULL,
    education_json      JSON NULL,
    is_default          TINYINT(1) NOT NULL DEFAULT 0,
    status              VARCHAR(30) NOT NULL DEFAULT 'active',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at          DATETIME NULL,
    PRIMARY KEY (id),
    KEY idx_resumes_user_status (user_id, status),
    CONSTRAINT fk_resumes_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_resumes_media FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE SET NULL,
    CONSTRAINT chk_resumes_status CHECK (status IN ('active','archived'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE job_applications (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    job_id               BIGINT UNSIGNED NOT NULL,
    applicant_user_id    BIGINT UNSIGNED NOT NULL,
    resume_id            BIGINT UNSIGNED NULL,
    cover_letter         LONGTEXT NULL,
    status               VARCHAR(40) NOT NULL DEFAULT 'submitted',
    applied_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    withdrawn_at         DATETIME NULL,
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_job_applications_job_applicant (job_id, applicant_user_id),
    KEY idx_job_applications_applicant_status (applicant_user_id, status),
    KEY idx_job_applications_job_status (job_id, status),
    CONSTRAINT fk_job_applications_job FOREIGN KEY (job_id) REFERENCES jobs(id) ON DELETE RESTRICT,
    CONSTRAINT fk_job_applications_applicant FOREIGN KEY (applicant_user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_job_applications_resume FOREIGN KEY (resume_id) REFERENCES resumes(id) ON DELETE SET NULL,
    CONSTRAINT chk_job_applications_status CHECK (status IN ('submitted','reviewing','shortlisted','interview','offer','accepted','rejected','withdrawn'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE application_status_history (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    application_id      BIGINT UNSIGNED NOT NULL,
    old_status          VARCHAR(40) NULL,
    new_status          VARCHAR(40) NOT NULL,
    changed_by_user_id  BIGINT UNSIGNED NULL,
    notes               TEXT NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_application_status_history_application (application_id, created_at),
    CONSTRAINT fk_application_status_history_application FOREIGN KEY (application_id) REFERENCES job_applications(id) ON DELETE CASCADE,
    CONSTRAINT fk_application_status_history_user FOREIGN KEY (changed_by_user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- NEWS
-- ============================================================

CREATE TABLE news_categories (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    parent_id           BIGINT UNSIGNED NULL,
    name_key            VARCHAR(191) NOT NULL,
    slug                VARCHAR(191) NOT NULL,
    is_active             TINYINT(1) NOT NULL DEFAULT 1,
    sort_order            INT UNSIGNED NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    UNIQUE KEY uq_news_categories_slug (slug),
    KEY idx_news_categories_parent (parent_id),
    CONSTRAINT fk_news_categories_parent FOREIGN KEY (parent_id) REFERENCES news_categories(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE articles (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    author_user_id      BIGINT UNSIGNED NOT NULL,
    category_id         BIGINT UNSIGNED NULL,
    slug                VARCHAR(191) NOT NULL,
    featured_media_id   BIGINT UNSIGNED NULL,
    status              VARCHAR(40) NOT NULL DEFAULT 'draft',
    published_at        DATETIME NULL,
    view_count          BIGINT UNSIGNED NOT NULL DEFAULT 0,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at          DATETIME NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_articles_slug (slug),
    KEY idx_articles_category_status (category_id, status, published_at),
    KEY idx_articles_author (author_user_id),
    CONSTRAINT fk_articles_author FOREIGN KEY (author_user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_articles_category FOREIGN KEY (category_id) REFERENCES news_categories(id) ON DELETE SET NULL,
    CONSTRAINT fk_articles_featured_media FOREIGN KEY (featured_media_id) REFERENCES media(id) ON DELETE SET NULL,
    CONSTRAINT chk_articles_status CHECK (status IN ('draft','in_review','scheduled','published','rejected','archived'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE article_translations (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    article_id          BIGINT UNSIGNED NOT NULL,
    locale_code         VARCHAR(10) NOT NULL,
    title               VARCHAR(255) NOT NULL,
    excerpt             TEXT NULL,
    content             LONGTEXT NOT NULL,
    seo_title           VARCHAR(255) NULL,
    seo_description     VARCHAR(500) NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_article_translations_locale (article_id, locale_code),
    CONSTRAINT fk_article_translations_article FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    CONSTRAINT fk_article_translations_locale FOREIGN KEY (locale_code) REFERENCES locales(code) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE article_media (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    article_id          BIGINT UNSIGNED NOT NULL,
    media_id            BIGINT UNSIGNED NOT NULL,
    caption_key         VARCHAR(191) NULL,
    sort_order          INT UNSIGNED NOT NULL DEFAULT 0,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_article_media (article_id, media_id),
    KEY idx_article_media_order (article_id, sort_order),
    CONSTRAINT fk_article_media_article FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    CONSTRAINT fk_article_media_media FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE article_comments (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    article_id          BIGINT UNSIGNED NOT NULL,
    user_id              BIGINT UNSIGNED NOT NULL,
    parent_id           BIGINT UNSIGNED NULL,
    content             TEXT NOT NULL,
    status              VARCHAR(30) NOT NULL DEFAULT 'pending',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at          DATETIME NULL,
    PRIMARY KEY (id),
    KEY idx_article_comments_article_status (article_id, status, created_at),
    KEY idx_article_comments_parent (parent_id),
    CONSTRAINT fk_article_comments_article FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    CONSTRAINT fk_article_comments_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_article_comments_parent FOREIGN KEY (parent_id) REFERENCES article_comments(id) ON DELETE CASCADE,
    CONSTRAINT chk_article_comments_status CHECK (status IN ('pending','published','hidden','rejected'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE article_reactions (
    article_id          BIGINT UNSIGNED NOT NULL,
    user_id             BIGINT UNSIGNED NOT NULL,
    reaction_type       VARCHAR(30) NOT NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (article_id, user_id, reaction_type),
    KEY idx_article_reactions_user (user_id),
    CONSTRAINT fk_article_reactions_article FOREIGN KEY (article_id) REFERENCES articles(id) ON DELETE CASCADE,
    CONSTRAINT fk_article_reactions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- MESSAGING
-- ============================================================

CREATE TABLE conversations (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    type                VARCHAR(30) NOT NULL DEFAULT 'direct',
    subject             VARCHAR(255) NULL,
    created_by_user_id  BIGINT UNSIGNED NOT NULL,
    last_message_at     DATETIME NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    archived_at         DATETIME NULL,
    PRIMARY KEY (id),
    KEY idx_conversations_created_by (created_by_user_id),
    KEY idx_conversations_last_message (last_message_at),
    CONSTRAINT fk_conversations_creator FOREIGN KEY (created_by_user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT chk_conversations_type CHECK (type IN ('direct','business','group','support'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE conversation_participants (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    conversation_id     BIGINT UNSIGNED NOT NULL,
    user_id             BIGINT UNSIGNED NOT NULL,
    participant_role    VARCHAR(50) NOT NULL DEFAULT 'member',
    joined_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    left_at             DATETIME NULL,
    last_read_at        DATETIME NULL,
    muted_until         DATETIME NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_conversation_participant (conversation_id, user_id),
    KEY idx_conversation_participants_user (user_id),
    CONSTRAINT fk_conversation_participants_conversation FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
    CONSTRAINT fk_conversation_participants_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE messages (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    conversation_id     BIGINT UNSIGNED NOT NULL,
    sender_user_id      BIGINT UNSIGNED NOT NULL,
    body                TEXT NULL,
    message_type        VARCHAR(30) NOT NULL DEFAULT 'text',
    status              VARCHAR(30) NOT NULL DEFAULT 'sent',
    reply_to_message_id BIGINT UNSIGNED NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    edited_at           DATETIME NULL,
    deleted_at          DATETIME NULL,
    PRIMARY KEY (id),
    KEY idx_messages_conversation_created (conversation_id, created_at),
    KEY idx_messages_sender (sender_user_id),
    KEY idx_messages_reply (reply_to_message_id),
    CONSTRAINT fk_messages_conversation FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
    CONSTRAINT fk_messages_sender FOREIGN KEY (sender_user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT fk_messages_reply FOREIGN KEY (reply_to_message_id) REFERENCES messages(id) ON DELETE SET NULL,
    CONSTRAINT chk_messages_type CHECK (message_type IN ('text','system','attachment','image')),
    CONSTRAINT chk_messages_status CHECK (status IN ('sent','edited','deleted'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE message_attachments (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    message_id          BIGINT UNSIGNED NOT NULL,
    media_id             BIGINT UNSIGNED NOT NULL,
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_message_attachment (message_id, media_id),
    CONSTRAINT fk_message_attachments_message FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE,
    CONSTRAINT fk_message_attachments_media FOREIGN KEY (media_id) REFERENCES media(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE message_reads (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    message_id          BIGINT UNSIGNED NOT NULL,
    user_id             BIGINT UNSIGNED NOT NULL,
    read_at             DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_message_reads (message_id, user_id),
    KEY idx_message_reads_user (user_id, read_at),
    CONSTRAINT fk_message_reads_message FOREIGN KEY (message_id) REFERENCES messages(id) ON DELETE CASCADE,
    CONSTRAINT fk_message_reads_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- PAYMENTS / WALLET
-- ============================================================

CREATE TABLE payment_intents (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    intent_number       VARCHAR(60) NOT NULL,
    user_id             BIGINT UNSIGNED NOT NULL,
    amount              DECIMAL(14,3) NOT NULL,
    currency            CHAR(3) NOT NULL DEFAULT 'TND',
    purpose_type        VARCHAR(80) NOT NULL,
    purpose_id          BIGINT UNSIGNED NULL,
    provider            VARCHAR(80) NULL,
    status              VARCHAR(30) NOT NULL DEFAULT 'created',
    client_secret_hash  CHAR(64) NULL,
    expires_at          DATETIME NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_payment_intents_number (intent_number),
    KEY idx_payment_intents_user_status (user_id, status),
    KEY idx_payment_intents_purpose (purpose_type, purpose_id),
    CONSTRAINT fk_payment_intents_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT chk_payment_intents_amount CHECK (amount > 0),
    CONSTRAINT chk_payment_intents_status CHECK (status IN ('created','requires_action','authorized','succeeded','failed','cancelled','expired'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE payments (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    payment_intent_id   BIGINT UNSIGNED NULL,
    payer_user_id       BIGINT UNSIGNED NOT NULL,
    provider             VARCHAR(80) NOT NULL,
    provider_reference   VARCHAR(191) NULL,
    amount              DECIMAL(14,3) NOT NULL,
    currency            CHAR(3) NOT NULL DEFAULT 'TND',
    status              VARCHAR(30) NOT NULL DEFAULT 'pending',
    paid_at             DATETIME NULL,
    failed_at           DATETIME NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_payments_provider_reference (provider, provider_reference),
    KEY idx_payments_intent (payment_intent_id),
    KEY idx_payments_user_status (payer_user_id, status),
    CONSTRAINT fk_payments_intent FOREIGN KEY (payment_intent_id) REFERENCES payment_intents(id) ON DELETE SET NULL,
    CONSTRAINT fk_payments_user FOREIGN KEY (payer_user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT chk_payments_amount CHECK (amount > 0),
    CONSTRAINT chk_payments_status CHECK (status IN ('pending','authorized','succeeded','failed','cancelled','refunded','partially_refunded'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE payment_refunds (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    payment_id          BIGINT UNSIGNED NOT NULL,
    amount              DECIMAL(14,3) NOT NULL,
    currency            CHAR(3) NOT NULL DEFAULT 'TND',
    provider_reference  VARCHAR(191) NULL,
    reason              VARCHAR(255) NULL,
    status              VARCHAR(30) NOT NULL DEFAULT 'pending',
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at        DATETIME NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_payment_refunds_provider_reference (provider_reference),
    KEY idx_payment_refunds_payment (payment_id),
    CONSTRAINT fk_payment_refunds_payment FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE RESTRICT,
    CONSTRAINT chk_payment_refunds_amount CHECK (amount > 0),
    CONSTRAINT chk_payment_refunds_status CHECK (status IN ('pending','completed','failed','cancelled'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE payment_events (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    payment_id          BIGINT UNSIGNED NULL,
    provider             VARCHAR(80) NOT NULL,
    event_type           VARCHAR(120) NOT NULL,
    provider_event_id    VARCHAR(191) NULL,
    payload_json         JSON NOT NULL,
    signature_valid      TINYINT(1) NOT NULL DEFAULT 0,
    processed_at         DATETIME NULL,
    created_at           DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_payment_events_provider_event (provider, provider_event_id),
    KEY idx_payment_events_payment (payment_id),
    KEY idx_payment_events_type_created (event_type, created_at),
    CONSTRAINT fk_payment_events_payment FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE wallet_accounts (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id             BIGINT UNSIGNED NOT NULL,
    currency            CHAR(3) NOT NULL DEFAULT 'TND',
    status              VARCHAR(30) NOT NULL DEFAULT 'active',
    available_balance   DECIMAL(18,3) NOT NULL DEFAULT 0,
    pending_balance     DECIMAL(18,3) NOT NULL DEFAULT 0,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_wallet_accounts_user_currency (user_id, currency),
    KEY idx_wallet_accounts_status (status),
    CONSTRAINT fk_wallet_accounts_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT chk_wallet_accounts_balance CHECK (available_balance >= 0 AND pending_balance >= 0),
    CONSTRAINT chk_wallet_accounts_status CHECK (status IN ('active','frozen','closed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE wallet_transactions (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    wallet_account_id   BIGINT UNSIGNED NOT NULL,
    transaction_number  VARCHAR(60) NOT NULL,
    transaction_type    VARCHAR(50) NOT NULL,
    direction            VARCHAR(10) NOT NULL,
    amount              DECIMAL(18,3) NOT NULL,
    currency             CHAR(3) NOT NULL DEFAULT 'TND',
    status              VARCHAR(30) NOT NULL DEFAULT 'posted',
    reference_type      VARCHAR(80) NULL,
    reference_id        BIGINT UNSIGNED NULL,
    description_key     VARCHAR(191) NULL,
    idempotency_key     VARCHAR(191) NULL,
    created_by_user_id  BIGINT UNSIGNED NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_wallet_transactions_number (transaction_number),
    UNIQUE KEY uq_wallet_transactions_idempotency (idempotency_key),
    KEY idx_wallet_transactions_account_created (wallet_account_id, created_at),
    KEY idx_wallet_transactions_reference (reference_type, reference_id),
    CONSTRAINT fk_wallet_transactions_account FOREIGN KEY (wallet_account_id) REFERENCES wallet_accounts(id) ON DELETE RESTRICT,
    CONSTRAINT fk_wallet_transactions_creator FOREIGN KEY (created_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_wallet_transactions_direction CHECK (direction IN ('credit','debit')),
    CONSTRAINT chk_wallet_transactions_amount CHECK (amount > 0),
    CONSTRAINT chk_wallet_transactions_status CHECK (status IN ('pending','posted','reversed','failed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE wallet_transaction_entries (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    wallet_transaction_id BIGINT UNSIGNED NOT NULL,
    entry_type          VARCHAR(30) NOT NULL,
    amount              DECIMAL(18,3) NOT NULL,
    balance_after       DECIMAL(18,3) NOT NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_wallet_transaction_entries_tx (wallet_transaction_id),
    CONSTRAINT fk_wallet_transaction_entries_tx FOREIGN KEY (wallet_transaction_id) REFERENCES wallet_transactions(id) ON DELETE RESTRICT,
    CONSTRAINT chk_wallet_transaction_entries_amount CHECK (amount > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE wallet_topups (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    wallet_account_id   BIGINT UNSIGNED NOT NULL,
    payment_id          BIGINT UNSIGNED NULL,
    amount              DECIMAL(18,3) NOT NULL,
    currency            CHAR(3) NOT NULL DEFAULT 'TND',
    status              VARCHAR(30) NOT NULL DEFAULT 'pending',
    requested_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    completed_at        DATETIME NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_wallet_topups_account_status (wallet_account_id, status),
    KEY idx_wallet_topups_payment (payment_id),
    CONSTRAINT fk_wallet_topups_account FOREIGN KEY (wallet_account_id) REFERENCES wallet_accounts(id) ON DELETE RESTRICT,
    CONSTRAINT fk_wallet_topups_payment FOREIGN KEY (payment_id) REFERENCES payments(id) ON DELETE SET NULL,
    CONSTRAINT chk_wallet_topups_amount CHECK (amount > 0),
    CONSTRAINT chk_wallet_topups_status CHECK (status IN ('pending','completed','failed','cancelled'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE wallet_withdrawals (
    id                  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    wallet_account_id   BIGINT UNSIGNED NOT NULL,
    amount              DECIMAL(18,3) NOT NULL,
    currency            CHAR(3) NOT NULL DEFAULT 'TND',
    destination_type    VARCHAR(50) NOT NULL,
    destination_data    JSON NOT NULL,
    status              VARCHAR(30) NOT NULL DEFAULT 'pending',
    requested_at        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    processed_at        DATETIME NULL,
    processed_by_user_id BIGINT UNSIGNED NULL,
    failure_reason      TEXT NULL,
    created_at          DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_wallet_withdrawals_account_status (wallet_account_id, status),
    CONSTRAINT fk_wallet_withdrawals_account FOREIGN KEY (wallet_account_id) REFERENCES wallet_accounts(id) ON DELETE RESTRICT,
    CONSTRAINT fk_wallet_withdrawals_processor FOREIGN KEY (processed_by_user_id) REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_wallet_withdrawals_amount CHECK (amount > 0),
    CONSTRAINT chk_wallet_withdrawals_status CHECK (status IN ('pending','approved','processing','completed','rejected','failed','cancelled'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================
-- SEED DATA: LOCALES, ROLES, PERMISSIONS
-- ============================================================

INSERT INTO locales (code, name, native_name, direction, is_active, sort_order)
VALUES
    ('ar', 'Arabic', 'العربية', 'rtl', 1, 1),
    ('fr', 'French', 'Français', 'ltr', 1, 2),
    ('en', 'English', 'English', 'ltr', 1, 3);

INSERT INTO roles (slug, name, description, is_system)
VALUES
    ('user', 'User', 'Standard authenticated platform user', 1),
    ('business_owner', 'Business Owner', 'Business owner and operator', 1),
    ('moderator', 'Moderator', 'Content and community moderator', 1),
    ('administrator', 'Administrator', 'Platform administrator', 1),
    ('super_administrator', 'Super Administrator', 'Full system administrator', 1);

INSERT INTO permissions (slug, name, description)
VALUES
    ('user.view_profile', 'View profile', 'View own profile'),
    ('user.edit_profile', 'Edit profile', 'Edit own profile'),
    ('business.create', 'Create business', 'Create a business'),
    ('business.view', 'View business', 'View business data'),
    ('business.edit', 'Edit business', 'Edit owned or assigned business'),
    ('business.manage_staff', 'Manage staff', 'Manage business members'),
    ('business.approve', 'Approve business', 'Approve business verification'),
    ('business.suspend', 'Suspend business', 'Suspend a business'),
    ('product.create', 'Create product', 'Create marketplace product'),
    ('product.edit', 'Edit product', 'Edit marketplace product'),
    ('product.delete', 'Delete product', 'Archive marketplace product'),
    ('order.view', 'View orders', 'View authorized orders'),
    ('order.manage', 'Manage orders', 'Manage authorized orders'),
    ('restaurant.manage', 'Manage restaurant', 'Manage restaurant operations'),
    ('transport.manage', 'Manage transport', 'Manage driver and transport operations'),
    ('healthcare.manage', 'Manage healthcare', 'Manage providers and appointments'),
    ('education.manage', 'Manage education', 'Manage institution and courses'),
    ('job.create', 'Create job', 'Create job listings'),
    ('job.edit', 'Edit job', 'Edit job listings'),
    ('application.view', 'View applications', 'View authorized applications'),
    ('article.create', 'Create article', 'Create articles'),
    ('article.edit', 'Edit article', 'Edit articles'),
    ('article.publish', 'Publish article', 'Publish articles'),
    ('article.moderate', 'Moderate article', 'Moderate articles'),
    ('article.view', 'View article', 'View article administration data'),
    ('review.moderate', 'Moderate reviews', 'Moderate reviews'),
    ('report.manage', 'Manage reports', 'Review reports'),
    ('user.moderate', 'Moderate users', 'Moderate user accounts'),
    ('wallet.view', 'View wallet', 'View wallet information'),
    ('wallet.manage', 'Manage wallet', 'Perform authorized wallet operations'),
    ('admin.users', 'Administer users', 'Manage all users'),
    ('admin.businesses', 'Administer businesses', 'Manage all businesses'),
    ('admin.roles', 'Manage roles', 'Manage roles and assignments'),
    ('admin.permissions', 'Manage permissions', 'Manage permissions'),
    ('admin.settings', 'Manage settings', 'Manage global settings'),
    ('admin.audit', 'View audit logs', 'View audit logs'),
    ('admin.finance', 'Manage finance', 'Manage financial administration'),
    ('admin.security', 'Manage security', 'Manage security settings');

-- User permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.slug IN (
    'user.view_profile','user.edit_profile',
    'order.view',
    'wallet.view'
)
WHERE r.slug = 'user';

-- Business owner inherits normal user abilities plus business operations.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.slug IN (
    'user.view_profile','user.edit_profile','order.view','wallet.view',
    'business.create','business.view','business.edit','business.manage_staff',
    'product.create','product.edit','product.delete','order.manage',
    'restaurant.manage','transport.manage','healthcare.manage','education.manage',
    'job.create','job.edit','application.view'
)
WHERE r.slug = 'business_owner';

-- Moderator permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.slug IN (
    'user.view_profile','review.moderate','report.manage','user.moderate',
    'article.moderate','article.view'
)
WHERE r.slug = 'moderator';

-- Administrator permissions
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
JOIN permissions p ON p.slug IN (
    'user.view_profile','user.edit_profile','order.view','wallet.view',
    'admin.users','admin.businesses','admin.roles','admin.permissions','admin.settings',
    'admin.audit','admin.finance','admin.security','review.moderate','report.manage',
    'user.moderate','article.moderate','article.publish','article.edit','business.approve','business.suspend'
)
WHERE r.slug = 'administrator';

-- Full system permissions for super administrator.
INSERT INTO role_permissions (role_id, permission_id)
SELECT r.id, p.id
FROM roles r
CROSS JOIN permissions p
WHERE r.slug = 'super_administrator';

-- ============================================================
-- SEED DATA: BUSINESS / MODULE CATEGORIES
-- Names are translation keys; translated UI is kept in lang files.
-- ============================================================

INSERT INTO business_categories (name_key, slug, sort_order) VALUES
    ('business.category.retail', 'retail', 1),
    ('business.category.restaurant', 'restaurant', 2),
    ('business.category.healthcare', 'healthcare', 3),
    ('business.category.education', 'education', 4),
    ('business.category.professional_services', 'professional-services', 5),
    ('business.category.transport', 'transport', 6),
    ('business.category.recruitment', 'recruitment', 7);

INSERT INTO vehicle_types (name_key, slug, max_passengers, base_fare, per_km_fare, per_minute_fare) VALUES
    ('transport.vehicle.standard', 'standard', 4, 2.500, 0.900, 0.120),
    ('transport.vehicle.comfort', 'comfort', 4, 4.000, 1.200, 0.160),
    ('transport.vehicle.van', 'van', 7, 5.500, 1.500, 0.190);

INSERT INTO healthcare_specialties (name_key, slug) VALUES
    ('healthcare.specialty.general_practice', 'general-practice'),
    ('healthcare.specialty.dentistry', 'dentistry'),
    ('healthcare.specialty.dermatology', 'dermatology'),
    ('healthcare.specialty.pediatrics', 'pediatrics'),
    ('healthcare.specialty.cardiology', 'cardiology');


SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- NOTES
-- ============================================================
-- 1. No default administrator or super administrator account is created.
--    Create one through a secure installation/bootstrap procedure.
-- 2. All passwords and remember/reset tokens must be generated and hashed
--    by PHP. Never insert plaintext credentials into this schema.
-- 3. Wallet balances must be changed only through application services and
--    corresponding immutable wallet transaction records.
-- 4. The application must enforce legal workflow transitions; CHECK constraints
--    intentionally validate allowed values but do not encode all workflow rules.
-- 5. Polymorphic tables such as reviews/reports/payment_intents reference a
--    logical entity_type + entity_id pair and therefore require application-layer
--    authorization and existence validation.
