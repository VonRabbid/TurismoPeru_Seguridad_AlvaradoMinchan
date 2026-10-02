-- Procedimiento de restauración secuencial (Full con NORECOVERY + Diferencial con RECOVERY)
USE master;
GO

-- Aislamiento de base de datos
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'TURISMOPERU_CPAM')
    ALTER DATABASE [TURISMOPERU_CPAM] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- Paso 1: Restaurar Full Backup con NORECOVERY
RESTORE DATABASE [TURISMOPERU_CPAM]
FROM DISK = N'/var/opt/mssql/data/TURISMOPERU_CPAM_Full.bak'
WITH FILE = 1, NORECOVERY, REPLACE, STATS = 10;
GO

-- Paso 2: Restaurar Respaldo Diferencial con RECOVERY
RESTORE DATABASE [TURISMOPERU_CPAM]
FROM DISK = N'/var/opt/mssql/data/TURISMOPERU_CPAM_Diff.bak'
WITH FILE = 1, RECOVERY, STATS = 10;
GO

-- Restablecer modo multiusuario y chequeo de consistencia
ALTER DATABASE [TURISMOPERU_CPAM] SET MULTI_USER;
DBCC CHECKDB ([TURISMOPERU_CPAM]) WITH NO_INFOMSGS;
GO

PRINT 'Restauración secuencial completada exitosamente.';

-- Verificación de estado de base de datos
SELECT name, state_desc, user_access_desc, recovery_model_desc
FROM sys.databases
WHERE name = 'TURISMOPERU_CPAM';
GO
