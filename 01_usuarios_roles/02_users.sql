-- Creación y mapeo de usuarios de base de datos en TURISMOPERU_CPAM
USE [TURISMOPERU_CPAM];
GO

-- Usuario turismo_admin
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'turismo_admin')
    CREATE USER [turismo_admin] FOR LOGIN [turismo_admin] WITH DEFAULT_SCHEMA = [CPAM];
ELSE
    ALTER USER [turismo_admin] WITH LOGIN = [turismo_admin], DEFAULT_SCHEMA = [CPAM];
GO

-- Usuario turismo_vendedor
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'turismo_vendedor')
    CREATE USER [turismo_vendedor] FOR LOGIN [turismo_vendedor] WITH DEFAULT_SCHEMA = [CPAM];
ELSE
    ALTER USER [turismo_vendedor] WITH LOGIN = [turismo_vendedor], DEFAULT_SCHEMA = [CPAM];
GO

-- Usuario turismo_analista
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'turismo_analista')
    CREATE USER [turismo_analista] FOR LOGIN [turismo_analista] WITH DEFAULT_SCHEMA = [CPAM];
ELSE
    ALTER USER [turismo_analista] WITH LOGIN = [turismo_analista], DEFAULT_SCHEMA = [CPAM];
GO

PRINT 'Usuarios de base de datos configurados correctamente.';

-- Verificación de usuarios
SELECT dp.principal_id, dp.name, dp.type_desc, sp.name AS login_name, dp.default_schema_name
FROM sys.database_principals dp
LEFT JOIN sys.server_principals sp ON dp.sid = sp.sid
WHERE dp.name IN ('turismo_admin', 'turismo_vendedor', 'turismo_analista');
GO
