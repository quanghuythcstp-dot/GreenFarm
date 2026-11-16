-- ============================================================
-- Migration: Create DeliveryConfig table for GreenFarm
-- ============================================================

USE GreenFarm;
GO

IF NOT EXISTS (
    SELECT 1 FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME = 'DeliveryConfig'
)
BEGIN
    CREATE TABLE DeliveryConfig (
        configId      INT            IDENTITY(1,1) NOT NULL,
        methodKey     NVARCHAR(20)   NOT NULL,   -- 'standard' or 'express'
        methodName    NVARCHAR(50)   NOT NULL,
        fee           DECIMAL(18,2)  NOT NULL,
        description   NVARCHAR(200)      NULL,

        CONSTRAINT PK_DeliveryConfig   PRIMARY KEY (configId),
        CONSTRAINT UQ_DeliveryMethodKey UNIQUE (methodKey)
    );

    INSERT INTO DeliveryConfig (methodKey, methodName, fee, description)
    VALUES
        ('standard', 'Standard Delivery', 2000, N'Delivered within 2–4 hours'),
        ('express',  'Express Delivery',  5000, N'Delivered within 1 hour');

    PRINT 'DeliveryConfig table created and seeded.';
END
ELSE
BEGIN
    PRINT 'DeliveryConfig table already exists. No change made.';
END
GO
