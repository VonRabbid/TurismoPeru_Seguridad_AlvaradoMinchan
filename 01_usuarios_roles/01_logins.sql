-- Creación de logins a nivel de servidor
USE master;
GO

-- Login turismo_admin
IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'turismo_admin')
    CREATE LOGIN [turismo_admin] WITH PASSWORD = N'AdminTurismo#2026!', DEFAULT_DATABASE = [TURISMOPERU_CPAM], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF;
ELSE
    ALTER LOGIN [turismo_admin] WITH PASSWORD = N'AdminTurismo#2026!', DEFAULT_DATABASE = [TURISMOPERU_CPAM], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF;
GO

-- Login turismo_vendedor
IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'turismo_vendedor')
    CREATE LOGIN [turismo_vendedor] WITH PASSWORD = N'Vendedor#Turismo2026!', DEFAULT_DATABASE = [TURISMOPERU_CPAM], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF;
ELSE
    ALTER LOGIN [turismo_vendedor] WITH PASSWORD = N'Vendedor#Turismo2026!', DEFAULT_DATABASE = [TURISMOPERU_CPAM], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF;
GO

-- Login turismo_analista
IF NOT EXISTS (SELECT name FROM sys.server_principals WHERE name = 'turismo_analista')
    CREATE LOGIN [turismo_analista] WITH PASSWORD = N'Analista#Turismo2026!', DEFAULT_DATABASE = [TURISMOPERU_CPAM], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF;
ELSE
    ALTER LOGIN [turismo_analista] WITH PASSWORD = N'Analista#Turismo2026!', DEFAULT_DATABASE = [TURISMOPERU_CPAM], CHECK_POLICY = OFF, CHECK_EXPIRATION = OFF;
GO

PRINT 'Logins de servidor configurados correctamente.';

-- Verificación de logins
SELECT principal_id, name, type_desc, is_disabled, default_database_name
FROM sys.server_principals
WHERE name IN ('turismo_admin', 'turismo_vendedor', 'turismo_analista');
GO
