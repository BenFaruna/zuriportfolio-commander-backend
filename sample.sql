-- Active: 1674492101262@@127.0.0.1@3306@bank
CREATE TYPE "STATUS" AS ENUM (
  'pending',
  'complete',
  'failed'
);

CREATE TYPE "ADMIN_STATUS" AS ENUM (
'pending',
'reviewed',
'approved',
'suspended',
'blacklisted'
);

CREATE TYPE product_status AS ENUM (
  'active',
  'temporary'
 );
 
CREATE TYPE shop_status AS ENUM (
  'active',
  'temporary'
 );


CREATE TABLE "mail_log" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "email" varchar(225),
  "message_data" json,
  "message_type_id" int,
  "status" "STATUS" DEFAULT 'pending',
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "request_origin" varchar(225)
);


CREATE TABLE "user_assessment_progress" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "user_assessment_id" INT,
  "question_id" INT,
  "status" "STATUS" DEFAULT 'pending'
);


CREATE TABLE "user_assessment" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "user_id" UUID,
  "assessment_id" INT,
  "score" numeric(10,2),
  "status" "STATUS" DEFAULT 'pending',
  "submission_date" TIMESTAMP
);

CREATE TABLE "transaction" (
  "id" SERIAL PRIMARY KEY,
  "order_id" uuid,
  "app_id" int,
  "status" "STATUS" DEFAULT 'pending',
  "amount" numeric(10, 2),
  "currency" VARCHAR(255),
  "provider_ref" VARCHAR(255),
  "in_app_ref" VARCHAR(255),
  "provider" VARCHAR(255),
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "order" (
  "id" UUID PRIMARY KEY NOT NULL,
  "type" VARCHAR(255) NOT NULL,
  "quantity" BIGINT NOT NULL,
  "amount" numeric(10,2) NOT NULL,
  "subtotal" numeric(10, 2),
  "VAT" numeric(10, 2),
  "product_id" UUID,
  "merchant_id" UUID,
  "customer_id" UUID,
  "promo" int,
  "status" "STATUS" DEFAULT 'pending',
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);


CREATE TABLE "product_category" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "name" varchar(225),
  "parent_category_id" int,
  "status" "STATUS" DEFAULT 'pending'
);

CREATE TYPE "badges" AS ENUM (
  'Beginner',
  'Intermediate',
  'Expert'
);

CREATE Table "last_viewed_product" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "user_id" uuid,
  "product_id" uuid,
  "viewed_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "assessment" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "skill_id" INT,
  "title" VARCHAR(255) NOT NULL,
  "description" TEXT,
  "start_date" TIMESTAMP,
  "end_date" TIMESTAMP,
  "duration_minutes" INT,
  "pass_score" numeric(10,2),
  "is_published" BOOL DEFAULT false,
  "status" "STATUS" DEFAULT 'pending',
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);


CREATE TABLE "skill_badge" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "skill_id" int,
  "name" "badges",
  "badge_image" TEXT,
  "min_score" numeric(10,2),
  "max_score" numeric(10,2),
  "created_at" timestamp,
  "updated_at" timestamp
);


CREATE TYPE "Discount_type" AS ENUM (
  'Percentage',
  'Fixed'
);


CREATE TABLE "promotion" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "user_id" UUID,
  "code" VARCHAR(255) NOT NULL,
  "promotion_type" VARCHAR(255) NOT NULL,
  "discount_type" "Discount_type",
  "quantity" BIGINT NOT NULL,
  "amount" numeric(10, 2) NOT NULL,
  "product_id" UUID,
  "valid_from" TIMESTAMP NOT NULL,
  "valid_to" TIMESTAMP NOT NULL,
  "min_cart_price" BIGINT NOT NULL,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);


CREATE TYPE "restricted" AS ENUM (
  'no',
  'temporary',
  'permanent'
);

CREATE TYPE product_status AS ENUM (
  'active',
  'temporary'
  );


CREATE TYPE shop_status AS ENUM (
  'active',
  'temporary'
  );


CREATE TABLE "shop" (
  "id" UUID PRIMARY KEY NOT NULL,
  "merchant_id" UUID,
  "name" varchar(255),
  "policy_confirmation" boolean,
  "restricted" "restricted" DEFAULT 'no',
  "admin_status" "ADMIN_STATUS" DEFAULT 'pending',
  "is_deleted" shop_status DEFAULT 'active',
  "reviewed" boolean,
  "rating" numeric(10,2),
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);


CREATE TABLE "product_image" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "product_id" UUID,
  "url" VARCHAR(255) NOT NULL
);

CREATE TABLE "revenue" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "user_id" UUID,
  "app_id" int,
  "amount" numeric(10,2) NOT NULL,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "product" (
  "id" UUID PRIMARY KEY NOT NULL,
  "shop_id" UUID,
  "name" VARCHAR(255) NOT NULL,
  "description" VARCHAR(255) NOT NULL,
  "quantity" BIGINT NOT NULL,
  "category_id" int,
  "price" numeric(10,2) NOT NULL,
  "discount_price" numeric(10,2) NOT NULL,
  "tax" numeric(10,2) NOT NULL,
  "admin_status" "ADMIN_STATUS" DEFAULT 'pending',
  "is_deleted" product_status DEFAULT 'active',
  "rating_id" int,
  "is_published" BOOL NOT NULL DEFAULT false,
  "currency" VARCHAR(10) NOT NULL,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "user_product_rating" (
"id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
"user_id" UUID,
"product_id" UUID,
"rating" INT
);

CREATE TABLE "track_promotion" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "product_id" uuid,
  "user_id" uuid,
  "code" BIGINT NOT NULL,
  "type" VARCHAR(255) NOT NULL,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "store_traffic" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "user_id" uuid,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "user" (
  "id" UUID PRIMARY KEY NOT NULL,
  "username" VARCHAR(255) NOT NULL,
  "first_name" VARCHAR(255) NOT NULL,
  "last_name" VARCHAR(255) NOT NULL,
  "email" VARCHAR(255) NOT NULL,
  "section_order" text,
  "password" VARCHAR(255),
  "provider" varchar(255),
  "is_verified" BOOL DEFAULT false,
  "two_factor_auth" BOOL DEFAULT False,
  "location" VARCHAR(255),
  "country" VARCHAR(255),
  "profile_pic" TEXT,
  "refresh_token" VARCHAR(255) NOT NULL,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "promo_product" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "product_id" UUID,
  "promo_id" int,
  "user_id" UUID
);

CREATE TABLE "activity" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "action" TEXT NOT NULL,
  "user_id" UUID,
  "title" VARCHAR(255) NOT NULL,
  "description" VARCHAR(255),
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "sales_report" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "user_id" UUID,
  "sales" BIGINT NOT NULL,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "email_verification" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "user_id" UUID,
  "email" VARCHAR,
  "token" VARCHAR,
  "expiration_date" TIMESTAMP NOT NULL,
  "created_at" TIMESTAMP,
  "updated_at" TIMESTAMP
);

CREATE TABLE "skill" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "category_name" VARCHAR(100) NOT NULL,
  "description" TEXT,
  "parent_skill_id" INT
);

CREATE TABLE "question" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "assessment_id" INT,
  "question_text" TEXT,
  "question_type" VARCHAR(20)
);

CREATE TABLE "answer" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "question_id" INT,
  "option1" TEXT,
  "option2" TEXT,
  "option3" TEXT,
  "option4" TEXT,
  "correct_option" TEXT,
  "is_correct" BOOL
);

CREATE TABLE "user_response" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "user_assessment_id" INT,
  "question_id" INT,
  "answer_id" INT
);

CREATE TABLE "assessment_category" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "assessment_id" INT,
  "skill_id" INT
);

CREATE TABLE "user_badge" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "assessment_id" int,
  "user_id" UUID,
  "badge_id" int,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "roles" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "name" VARCHAR(225)
);

CREATE TABLE "user_roles" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "role_id" int,
  "user_id" uuid,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "permissions" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "name" VARCHAR(225),
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "user_permissions" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "user_id" uuid,
  "permission_id" int,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "roles_permissions" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "role_id" int,
  "permission_id" int,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "app" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "url" TEXT,
  "description" TEXT,
  "name" VARCHAR(225),
  "created_at" TIMESTAMP,
  "created_by" UUID
);

CREATE TABLE "user_analytics" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "app_id" int,
  "metric_total_number_users" INT,
  "metric_total_number_daily_users" INT,
  "metric_total_number_of_user_visitation_on_product" INT,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "sales_analytics" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "app_id" int,
  "metric_amount_goods_sold" DECIMAL(10, 2),
  "metric_average_sales" DECIMAL(10, 2),
  "metric_overall_revenue" DECIMAL(10, 2),
  "metric_revenue_per_category" DECIMAL(10, 2),
  "metric_product_popularity" DECIMAL(10, 2),
  "metric_total_orders" INT,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "portfolios_analytics" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "app_id" int,
  "metric_amount_portfolios" varchar(225),
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "report" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "report_type" varchar(225),
  "data" text,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "complaint" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "user_id" UUID,
  "product_id" UUID,
  "complaint_text" TEXT,
  "status" VARCHAR(225) DEFAULT 'pending',
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "complaint_comment" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "complaint_id" INT,
  "comment" TEXT,
  "user_id" UUID,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
  "updated_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "mail_type" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "name" varchar(225)
);

CREATE TABLE "section" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "name" varchar,
  "description" text,
  "meta" text
);

CREATE TABLE "tracks" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "track" varchar
);

CREATE TABLE "images" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "url" varchar
);

CREATE TABLE "work_experience_detail" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "role" varchar,
  "company" varchar,
  "description" text,
  "start_month" varchar,
  "start_year" varchar,
  "end_month" varchar,
  "end_year" varchar,
  "is_employee" bool,
  "user_id" uuid,
  "section_id" int
);

CREATE TABLE "project" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "title" varchar,
  "year" varchar,
  "url" varchar,
  "tags" text,
  "description" text,
  "thumbnail" integer,
  "user_id" uuid,
  "section_id" int
);

CREATE TABLE "education_detail" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "degree_id" int,
  "field_of_study" varchar,
  "school" varchar,
  "from" varchar,
  "description" text,
  "to" varchar,
  "user_id" uuid,
  "section_id" int
);

CREATE TABLE "degree" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "type" varchar
);

CREATE TABLE "about_detail" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "bio" text,
  "user_id" uuid,
  "section_id" int
);

CREATE TABLE "skills_detail" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "skills" text,
  "user_id" uuid,
  "section_id" int
);

CREATE TABLE "interest_detail" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "interest" text,
  "user_id" uuid,
  "section_id" int
);

CREATE TABLE "social_media" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "name" text
);

CREATE TABLE "social_user" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "user_id" uuid,
  "social_media_id" int,
  "url" text
);

CREATE TABLE "custom_user_section" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "user_id" uuid,
  "section_id" int
);

CREATE TABLE "custom_field" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "field_type" varchar,
  "field_name" varchar,
  "custom_section_id" int,
  "value" text
);

CREATE TABLE "notification_setting" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "email_summary" bool,
  "special_offers" bool,
  "community_update" bool,
  "follow_update" bool,
  "new_messages" bool,
  "user_id" uuid
);

CREATE TABLE "projects_image" (
"id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "project_id" int,
  "image_id" int
);

CREATE TABLE "cart" (
  "id" "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "user_id" uuid,
  "product_id" UUID
);

CREATE TABLE "order_item" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
  "order_id" uuid,
  "product_id" uuid
);


CREATE TABLE "product_review" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "product_id" uuid,
  "user_id" uuid,
  "comment" TEXT,
  "reply_id" int,
  "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "coupon" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "merchant_id" UUID,
  "shop_id" UUID,
  "transaction_id" int,
  "coupon_limit" int,
  "percentage" numeric(10, 2),
  "coupon_code" varchar(20),
  "expiry_date" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);


CREATE TABLE "product_logs" (
"id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "user_id" UUID NOT NULL,
  "action" VARCHAR(20),
  "product_id" UUID NOT NULL,
  "log_date"  TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "shop_logs" (
"id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "user_id" UUID NOT NULL,
  "action" VARCHAR(20),
  "shop_id" UUID NOT NULL,
  "log_date"  TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "wishlist" (
 "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
 "user_id"  UUID,
 "product_id"  UUID,
 "created_at" TIMESTAMP DEFAULT (CURRENT_TIMESTAMP),
 "updated_at"  TIMESTAMP DEFAULT (CURRENT_TIMESTAMP)
);

CREATE TABLE "favorites" (
  "id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "user_id"  UUID,
  "product_id"  UUID
);

CREATE TABLE "user_track" (
"id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "user_id" UUID,
  "track_id" int
);

CREATE TABLE "portfolio_detail" (
"id" INT GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY NOT NULL,
  "city" varchar,
  "country" varchar,
  "user_id" UUID
);

ALTER TABLE "user_track" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "user_track" ADD FOREIGN KEY ("track_id") REFERENCES "tracks" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "portfolio_detail" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "wishlist" ADD FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "wishlist" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "favorites" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "favorites" ADD FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "product_image" ADD FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "shop_logs" ADD FOREIGN KEY ("shop_id") REFERENCES "shop" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "shop_logs" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "product_logs" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "product_logs" ADD FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "revenue" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "revenue" ADD FOREIGN KEY ("app_id") REFERENCES "app" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "product" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "product" ADD FOREIGN KEY ("shop_id") REFERENCES "shop" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "product" ADD FOREIGN KEY ("category_id") REFERENCES "product_category" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "product" ADD FOREIGN KEY ("image_id") REFERENCES "product_image" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "product_category" ADD FOREIGN KEY ("parent_category_id") REFERENCES "product_category" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "track_promotion" ADD FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "track_promotion" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "promotion" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "promotion" ADD FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "store_traffic" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "order" ADD FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "order" ADD FOREIGN KEY ("merchant_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "order" ADD FOREIGN KEY ("customer_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "order" ADD FOREIGN KEY ("promo") REFERENCES "promotion" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "promo_product" ADD FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "promo_product" ADD FOREIGN KEY ("promo_id") REFERENCES "promotion" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "promo_product" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "activity" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sales_report" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "email_verification" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "skill" ADD FOREIGN KEY ("parent_skill_id") REFERENCES "skill" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "assessment" ADD FOREIGN KEY ("skill_id") REFERENCES "skill" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "question" ADD FOREIGN KEY ("assessment_id") REFERENCES "assessment" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "answer" ADD FOREIGN KEY ("question_id") REFERENCES "question" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "user_assessment" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "user_assessment" ADD FOREIGN KEY ("assessment_id") REFERENCES "assessment" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "user_response" ADD FOREIGN KEY ("user_assessment_id") REFERENCES "user_assessment" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "user_response" ADD FOREIGN KEY ("question_id") REFERENCES "question" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "user_assessment_progress" ADD FOREIGN KEY ("user_assessment_id") REFERENCES "user_assessment" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "user_assessment_progress" ADD FOREIGN KEY ("question_id") REFERENCES "question" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "assessment_category" ADD FOREIGN KEY ("assessment_id") REFERENCES "assessment" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "assessment_category" ADD FOREIGN KEY ("skill_id") REFERENCES "skill" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "skill_badge" ADD FOREIGN KEY ("skill_id") REFERENCES "skill" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "user_badge" ADD FOREIGN KEY ("assessment_id") REFERENCES "assessment" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "user_badge" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "user_badge" ADD FOREIGN KEY ("badge_id") REFERENCES "skill_badge" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "user_roles" ADD FOREIGN KEY ("role_id") REFERENCES "roles" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "user_roles" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "user_permissions" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "user_permissions" ADD FOREIGN KEY ("permission_id") REFERENCES "permissions" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "roles_permissions" ADD FOREIGN KEY ("role_id") REFERENCES "roles" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "roles_permissions" ADD FOREIGN KEY ("permission_id") REFERENCES "permissions" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "app" ADD FOREIGN KEY ("created_by") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "user_analytics" ADD FOREIGN KEY ("app_id") REFERENCES "app" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sales_analytics" ADD FOREIGN KEY ("app_id") REFERENCES "app" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "portfolios_analytics" ADD FOREIGN KEY ("app_id") REFERENCES "app" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "mail_log" ADD FOREIGN KEY ("message_type_id") REFERENCES "mail_type" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "work_experience_detail" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "work_experience_detail" ADD FOREIGN KEY ("section_id") REFERENCES "section" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "project" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "project" ADD FOREIGN KEY ("section_id") REFERENCES "section" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "education_detail" ADD FOREIGN KEY ("degree_id") REFERENCES "degree" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "education_detail" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "education_detail" ADD FOREIGN KEY ("section_id") REFERENCES "section" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "about_detail" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "about_detail" ADD FOREIGN KEY ("section_id") REFERENCES "section" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "skills_detail" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "skills_detail" ADD FOREIGN KEY ("section_id") REFERENCES "section" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "interest_detail" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "interest_detail" ADD FOREIGN KEY ("section_id") REFERENCES "section" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "social_user" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "social_user" ADD FOREIGN KEY ("social_media_id") REFERENCES "social_user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "custom_user_section" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "custom_user_section" ADD FOREIGN KEY ("section_id") REFERENCES "section" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "custom_field" ADD FOREIGN KEY ("custom_section_id") REFERENCES "custom_user_section" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "notification_setting" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "projects_image" ADD FOREIGN KEY ("project_id") REFERENCES "project" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "projects_image" ADD FOREIGN KEY ("image_id") REFERENCES "images" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "cart" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "complaint" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "complaint" ADD FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "complaint_comment" ADD FOREIGN KEY ("complaint_id") REFERENCES "complaint" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "complaint_comment" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "cart" ADD FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "order_item" ADD FOREIGN KEY ("order_id") REFERENCES "order" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "order_item" ADD FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "transaction" ADD FOREIGN KEY ("order_id") REFERENCES "order" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "transaction" ADD FOREIGN KEY ("app_id") REFERENCES "app" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "product_review" ADD FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "product_review" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "product_review" ADD FOREIGN KEY ("reply_id") REFERENCES "product_review" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "shop" ADD FOREIGN KEY ("merchant_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "coupon" ADD FOREIGN KEY ("merchant_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "coupon" ADD FOREIGN KEY ("shop_id") REFERENCES "shop" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "coupon" ADD FOREIGN KEY ("transaction_id") REFERENCES "transaction" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "product" ADD FOREIGN KEY ("rating_id") REFERENCES "user_product_rating" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "last_viewed_product" ADD FOREIGN KEY ("user_id") REFERENCES "user" ("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "last_viewed_product" ADD FOREIGN KEY ("product_id") REFERENCES "product" ("id") ON DELETE CASCADE ON UPDATE CASCADE;