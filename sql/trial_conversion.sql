CREATE DATABASE saas_conversion;
USE saas_conversion;

-- 1. Accounts Table
CREATE TABLE accounts (
    account_id VARCHAR(50) PRIMARY KEY,
    industry VARCHAR(100),
    signup_date DATETIME,
    referral_source VARCHAR(50),
    plan_tier VARCHAR(50),
    seats INT,
    is_trial TINYINT
);

-- 2. Subscriptions Table
CREATE TABLE subscriptions (
    subscription_id VARCHAR(50) PRIMARY KEY,
    account_id VARCHAR(50),
    start_date DATETIME,
    plan_tier VARCHAR(50),
    mrr_amount INT,
    is_trial TINYINT,
    billing_frequency VARCHAR(50),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE
);

-- 3. Feature Usage Table
CREATE TABLE feature_usage (
    subscription_id VARCHAR(50),
    usage_date DATETIME,
    feature_name VARCHAR(100),
    usage_count INT,
    usage_duration_secs INT,
    error_count INT,
    is_beta_feature TINYINT,
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(subscription_id) ON DELETE CASCADE
);

-- 4. Support Tickets Table
CREATE TABLE support_tickets (
    account_id VARCHAR(50),
    submitted_at DATETIME,
    resolution_time_hours FLOAT,
    first_response_time_minutes INT,
    satisfaction_score FLOAT NULL, -- Keeps NaNs as NULLs
    FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE
);

-- 5. Master Table
CREATE TABLE master_analytics (
    account_id VARCHAR(50) PRIMARY KEY,
    industry VARCHAR(100),
    signup_date DATETIME,
    referral_source VARCHAR(50),
    plan_tier VARCHAR(50),
    seats INT,
    converted_to_paid TINYINT,
    total_clicks INT,
    total_duration_mins FLOAT,
    total_errors_encountered INT,
    distinct_features_tried INT,
    active_days_count INT,
    tickets_raised_count INT,
    avg_response_time_mins FLOAT,
    avg_csat_score FLOAT,
    skipped_surveys_count INT,
    FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE
);

SELECT * FROM accounts LIMIT 5;
SELECT * FROM subscriptions LIMIT 5;
SELECT * FROM feature_usage LIMIT 5;
SELECT * FROM support_tickets LIMIT 5;
SELECT * FROM master_analytics LIMIT 5;