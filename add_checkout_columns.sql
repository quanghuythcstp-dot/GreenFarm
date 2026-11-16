-- ============================================================
-- Migration: Add checkout columns to Orders table
-- Run against the existing GreenFarm database.
-- Safe to run multiple times (checks each column before adding).
-- ============================================================

USE GreenFarm;
GO

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
               WHERE TABLE_NAME='Orders' AND COLUMN_NAME='deliveryMethod')
    ALTER TABLE Orders ADD deliveryMethod NVARCHAR(20)  NOT NULL DEFAULT 'Standard';
GO

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
               WHERE TABLE_NAME='Orders' AND COLUMN_NAME='paymentMethod')
    ALTER TABLE Orders ADD paymentMethod  NVARCHAR(20)  NOT NULL DEFAULT 'COD';
GO

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
               WHERE TABLE_NAME='Orders' AND COLUMN_NAME='shippingFee')
    ALTER TABLE Orders ADD shippingFee    DECIMAL(10,2) NOT NULL DEFAULT 2.00;
GO

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS
               WHERE TABLE_NAME='Orders' AND COLUMN_NAME='orderNote')
    ALTER TABLE Orders ADD orderNote      NVARCHAR(500)     NULL;
GO

PRINT 'Checkout columns migration complete.';
GO
