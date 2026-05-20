-- init.sql

-- Table for the total visitor count
CREATE TABLE IF NOT EXISTS visitors (
    id SERIAL PRIMARY KEY,
    count INTEGER DEFAULT 0
);

-- Initialize the counter row if it doesn't exist
INSERT INTO visitors (id, count) VALUES (1, 0) ON CONFLICT DO NOTHING;

-- Table for individual visitor logs
CREATE TABLE IF NOT EXISTS visit_log (
    id SERIAL PRIMARY KEY,
    ip_address VARCHAR(50),
    visit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
