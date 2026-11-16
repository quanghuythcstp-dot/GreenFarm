-- ============================================================
-- Migration: Create ContactMessage table for GreenFarm
-- Run against the existing GreenFarm database.
-- Safe to run multiple times (checks before creating).
-- ============================================================

USE GreenFarm;
GO

IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'ContactMessage'
)
BEGIN
    CREATE TABLE ContactMessage (
        messageId   INT            IDENTITY(1,1) NOT NULL,
        fullName    NVARCHAR(100)  NOT NULL,
        phoneNumber NVARCHAR(20)   NOT NULL,
        email       NVARCHAR(100)      NULL,
        subject     NVARCHAR(200)      NULL,
        message     NVARCHAR(2000) NOT NULL,
        createdAt   DATETIME       NOT NULL DEFAULT GETDATE(),
        status      NVARCHAR(20)   NOT NULL DEFAULT 'New',

        CONSTRAINT PK_ContactMessage PRIMARY KEY (messageId),
        CONSTRAINT CK_Contact_Status CHECK (status IN ('New', 'Read', 'Replied'))
    );

    PRINT 'ContactMessage table created successfully.';
END
ELSE
BEGIN
    PRINT 'ContactMessage table already exists. No change made.';
END
GO
