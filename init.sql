-- init.sql
CREATE TABLE IF NOT EXISTS visitors (
    id SERIAL PRIMARY KEY,
    count INTEGER DEFAULT 0
);
INSERT INTO visitors (id, count) VALUES (1, 0) ON CONFLICT DO NOTHING;


