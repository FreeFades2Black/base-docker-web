-- init.sql

-- 1. Total historical hits counter
CREATE TABLE IF NOT EXISTS visitors (
    id SERIAL PRIMARY KEY,
    count INTEGER DEFAULT 0
);
INSERT INTO visitors (id, count) VALUES (1, 0) ON CONFLICT DO NOTHING;

-- 2. Unique User Profiles table
CREATE TABLE IF NOT EXISTS user_profiles (
    id SERIAL PRIMARY KEY,
    ip_address VARCHAR(50) UNIQUE NOT NULL,
    first_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    nickname VARCHAR(100) DEFAULT 'Anonymous Guest'
);

-- 3. Visit Logs table linked by a Foreign Key
CREATE TABLE IF NOT EXISTS visit_log (
    id SERIAL PRIMARY KEY,
    profile_id INTEGER REFERENCES user_profiles(id) ON DELETE CASCADE,
    referrer VARCHAR(100) DEFAULT 'Direct',
    visit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
