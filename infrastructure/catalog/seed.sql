CREATE DATABASE [CATALOG]
GO

USE [CATALOG]
GO

IF NOT EXISTS (SELECT * FROM sys.tables WHERE [NAME] = 'CATALOG_TYPE')
CREATE TABLE dbo.CATALOG_TYPE (
    [ID] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWSEQUENTIALID() ROWGUIDCOL,
    [TYPE] NVARCHAR(200) NOT NULL,
    [ICON] NVARCHAR(50) NULL
)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE [NAME] = 'CATALOG_BRAND')
CREATE TABLE dbo.CATALOG_BRAND (
    [ID] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWSEQUENTIALID() ROWGUIDCOL,
    [BRAND] NVARCHAR(200) NOT NULL,
    [ICON] NVARCHAR(50) NULL
)

IF NOT EXISTS (SELECT * FROM sys.tables WHERE [NAME] = 'CATALOG_ITEM')
CREATE TABLE dbo.CATALOG_ITEM (
    [ID] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY DEFAULT NEWSEQUENTIALID() ROWGUIDCOL,
    [NAME] NVARCHAR(200) NOT NULL,
    [PRICE] DECIMAL(9,2) NOT NULL,
    [DESCRIPTION] NVARCHAR(MAX) NULL,
    [IMAGE_PATH] NVARCHAR(MAX) NULL,
    [CREATED_DATE] DATETIME NOT NULL,
    [CATALOG_TYPE_ID] UNIQUEIDENTIFIER NOT NULL,
    [CATALOG_BRAND_ID] UNIQUEIDENTIFIER NOT NULL,
    CONSTRAINT FK_CATALOG_TYPE_ID FOREIGN KEY ([CATALOG_TYPE_ID]) REFERENCES [CATALOG_TYPE](ID),
    CONSTRAINT FK_CATALOG_BRAND_ID FOREIGN KEY ([CATALOG_BRAND_ID]) REFERENCES [CATALOG_BRAND](ID)
)

GO

INSERT INTO [CATALOG].[dbo].[CATALOG_TYPE] ([TYPE], [ICON]) VALUES ('Mug','local_cafe')
INSERT INTO [CATALOG].[dbo].[CATALOG_TYPE] ([TYPE], [ICON]) VALUES ('T-Shirt','person')
INSERT INTO [CATALOG].[dbo].[CATALOG_TYPE] ([TYPE], [ICON]) VALUES ('Sheet','label')
INSERT INTO [CATALOG].[dbo].[CATALOG_TYPE] ([TYPE], [ICON]) VALUES ('USB Memory Stick','usb')

INSERT INTO [CATALOG].[dbo].[CATALOG_BRAND] ([BRAND], [ICON]) VALUES ('Azure','cloud')
INSERT INTO [CATALOG].[dbo].[CATALOG_BRAND] ([BRAND], [ICON]) VALUES ('.NET','code')
INSERT INTO [CATALOG].[dbo].[CATALOG_BRAND] ([BRAND], [ICON]) VALUES ('Visual Studio','polymer')
INSERT INTO [CATALOG].[dbo].[CATALOG_BRAND] ([BRAND], [ICON]) VALUES ('SQL Server','storage')
INSERT INTO [CATALOG].[dbo].[CATALOG_BRAND] ([BRAND], [ICON]) VALUES ('Other','category')

INSERT INTO [CATALOG].[dbo].[CATALOG_ITEM] ([NAME],[PRICE],[DESCRIPTION],[IMAGE_PATH],[CREATED_DATE],[CATALOG_TYPE_ID],[CATALOG_BRAND_ID])
SELECT '.NET Bot Black Sweatshirt', 19.5, '.NET Bot Black Sweatshirt', 'Item 1.png', GETDATE(), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_TYPE] WHERE [TYPE] = 'T-Shirt'), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_BRAND] WHERE [BRAND] = '.NET')
INSERT INTO [CATALOG].[dbo].[CATALOG_ITEM] ([NAME],[PRICE],[DESCRIPTION],[IMAGE_PATH],[CREATED_DATE],[CATALOG_TYPE_ID],[CATALOG_BRAND_ID])
SELECT '.NET Black & White Mug', 8.5, '.NET Black & White Mug', 'Item 2.png', GETDATE(), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_TYPE] WHERE [TYPE] = 'Mug'), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_BRAND] WHERE [BRAND] = '.NET')
INSERT INTO [CATALOG].[dbo].[CATALOG_ITEM] ([NAME],[PRICE],[DESCRIPTION],[IMAGE_PATH],[CREATED_DATE],[CATALOG_TYPE_ID],[CATALOG_BRAND_ID])
SELECT 'Prism White T-Shirt', 12, 'Prism White T-Shirt', 'Item 3.png', GETDATE(), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_TYPE] WHERE [TYPE] = 'T-Shirt'), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_BRAND] WHERE [BRAND] = 'Other')
INSERT INTO [CATALOG].[dbo].[CATALOG_ITEM] ([NAME],[PRICE],[DESCRIPTION],[IMAGE_PATH],[CREATED_DATE],[CATALOG_TYPE_ID],[CATALOG_BRAND_ID])
SELECT '.NET Foundation Sweatshirt', 12, '.NET Foundation Sweatshirt', 'Item 4.png', GETDATE(), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_TYPE] WHERE [TYPE] = 'T-Shirt'), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_BRAND] WHERE [BRAND] = '.NET')
INSERT INTO [CATALOG].[dbo].[CATALOG_ITEM] ([NAME],[PRICE],[DESCRIPTION],[IMAGE_PATH],[CREATED_DATE],[CATALOG_TYPE_ID],[CATALOG_BRAND_ID])
SELECT 'Roslyn Red Sheet', 8.5, 'Roslyn Red Sheet', 'Item 5.png', GETDATE(), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_TYPE] WHERE [TYPE] = 'Sheet'), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_BRAND] WHERE [BRAND] = 'Other')
INSERT INTO [CATALOG].[dbo].[CATALOG_ITEM] ([NAME],[PRICE],[DESCRIPTION],[IMAGE_PATH],[CREATED_DATE],[CATALOG_TYPE_ID],[CATALOG_BRAND_ID])
SELECT '.NET Blue Sweatshirt', 12, '.NET Blue Sweatshirt', 'Item 6.png', GETDATE(), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_TYPE] WHERE [TYPE] = 'T-Shirt'), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_BRAND] WHERE [BRAND] = '.NET')
INSERT INTO [CATALOG].[dbo].[CATALOG_ITEM] ([NAME],[PRICE],[DESCRIPTION],[IMAGE_PATH],[CREATED_DATE],[CATALOG_TYPE_ID],[CATALOG_BRAND_ID])
SELECT 'Roslyn Red T-Shirt', 12, 'Roslyn Red T-Shirt', 'Item 7.png', GETDATE(), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_TYPE] WHERE [TYPE] = 'T-Shirt'), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_BRAND] WHERE [BRAND] = 'Other')
INSERT INTO [CATALOG].[dbo].[CATALOG_ITEM] ([NAME],[PRICE],[DESCRIPTION],[IMAGE_PATH],[CREATED_DATE],[CATALOG_TYPE_ID],[CATALOG_BRAND_ID])
SELECT 'Kudu Purple Sweatshirt', 8.5, 'Kudu Purple Sweatshirt', 'Item 8.png', GETDATE(), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_TYPE] WHERE [TYPE] = 'T-Shirt'), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_BRAND] WHERE [BRAND] = 'Other')
INSERT INTO [CATALOG].[dbo].[CATALOG_ITEM] ([NAME],[PRICE],[DESCRIPTION],[IMAGE_PATH],[CREATED_DATE],[CATALOG_TYPE_ID],[CATALOG_BRAND_ID])
SELECT 'Cup<T> White Mug', 12, 'Cup<T> White Mug', 'Item 9.png', GETDATE(), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_TYPE] WHERE [TYPE] = 'Mug'), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_BRAND] WHERE [BRAND] = 'Other')
INSERT INTO [CATALOG].[dbo].[CATALOG_ITEM] ([NAME],[PRICE],[DESCRIPTION],[IMAGE_PATH],[CREATED_DATE],[CATALOG_TYPE_ID],[CATALOG_BRAND_ID])
SELECT '.NET Foundation Sheet', 12, '.NET Foundation Sheet', 'Item 10.png', GETDATE(), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_TYPE] WHERE [TYPE] = 'Sheet'), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_BRAND] WHERE [BRAND] = '.NET')
INSERT INTO [CATALOG].[dbo].[CATALOG_ITEM] ([NAME],[PRICE],[DESCRIPTION],[IMAGE_PATH],[CREATED_DATE],[CATALOG_TYPE_ID],[CATALOG_BRAND_ID])
SELECT 'Cup<T> Sheet', 8.5, 'Cup<T> Sheet', 'Item 11.png', GETDATE(), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_TYPE] WHERE [TYPE] = 'Sheet'), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_BRAND] WHERE [BRAND] = '.NET')
INSERT INTO [CATALOG].[dbo].[CATALOG_ITEM] ([NAME],[PRICE],[DESCRIPTION],[IMAGE_PATH],[CREATED_DATE],[CATALOG_TYPE_ID],[CATALOG_BRAND_ID])
SELECT 'Prism White TShirt', 12, 'Prism White TShirt', 'Item 12.png', GETDATE(), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_TYPE] WHERE [TYPE] = 'T-Shirt'), (SELECT [ID] FROM [CATALOG].[dbo].[CATALOG_BRAND] WHERE [BRAND] = 'Other')