-- Respaldo de base de datos TURISMOPERU_CPAM (Full y Diferencial)
USE master;
GO

-- Respaldo Completo (Base LSN)
BACKUP DATABASE [TURISMOPERU_CPAM]
TO DISK = N'/var/opt/mssql/data/TURISMOPERU_CPAM_Full.bak'
WITH INIT, FORMAT, COMPRESSION, CHECKSUM, STATS = 10;
GO

-- Respaldo Diferencial
BACKUP DATABASE [TURISMOPERU_CPAM]
TO DISK = N'/var/opt/mssql/data/TURISMOPERU_CPAM_Diff.bak'
WITH DIFFERENTIAL, INIT, FORMAT, COMPRESSION, CHECKSUM, STATS = 10;
GO

PRINT 'Respaldos Full y Diferencial completados exitosamente.';

-- Verificación en historial msdb
SELECT bs.database_name, bs.type AS tipo, bs.backup_finish_date,
       CAST(bs.backup_size / 1024.0 / 1024.0 AS DECIMAL(10, 2)) AS tamano_mb,
       CAST(bs.compressed_backup_size / 1024.0 / 1024.0 AS DECIMAL(10, 2)) AS comprimido_mb,
       bmf.physical_device_name
FROM msdb.dbo.backupset bs
JOIN msdb.dbo.backupmediafamily bmf ON bs.media_set_id = bmf.media_set_id
WHERE bs.database_name = 'TURISMOPERU_CPAM'
ORDER BY bs.backup_finish_date DESC;
GO
