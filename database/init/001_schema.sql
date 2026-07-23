CREATE TABLE accounts (
    id BIGSERIAL PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    display_name TEXT,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE tickets (
    id BIGSERIAL PRIMARY KEY,
    local_id TEXT NOT NULL UNIQUE,

    submitted_by BIGINT NOT NULL REFERENCES accounts(id),

    student_id TEXT NOT NULL,
    student_name TEXT NOT NULL,
    class_name TEXT NOT NULL,

    violations JSONB NOT NULL,
    description TEXT NOT NULL DEFAULT '',

    status TEXT NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending', 'accepted', 'processing', 'resolved', 'rejected')),

    client_created_at TIMESTAMPTZ NOT NULL,
    received_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_tickets_submitted_by
ON tickets(submitted_by);

CREATE INDEX idx_tickets_status
ON tickets(status);

CREATE INDEX idx_tickets_client_created_at
ON tickets(client_created_at);

INSERT INTO accounts (
    username,
    password_hash,
    display_name
)
VALUES (
    'admin',
    'admin',
    'Administrator'
);