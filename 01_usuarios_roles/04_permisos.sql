-- Asignación de permisos granulares para rol_vendedor y rol_analista
USE [TURISMOPERU_CPAM];
GO

-- Sinónimos para compatibilidad de esquemas
IF NOT EXISTS (SELECT * FROM sys.synonyms WHERE name = 'paqueteturistico' AND schema_id = SCHEMA_ID('CPAM'))
    CREATE SYNONYM CPAM.paqueteturistico FOR CPAM.paquete;
GO

IF NOT EXISTS (SELECT * FROM sys.synonyms WHERE name = 'paqueteturistico' AND schema_id = SCHEMA_ID('dbo'))
    CREATE SYNONYM dbo.paqueteturistico FOR CPAM.paquete;
GO

-- Permisos rol_vendedor
GRANT SELECT, INSERT ON CPAM.cliente TO [rol_vendedor];
GRANT SELECT, INSERT ON CPAM.reserva TO [rol_vendedor];
GRANT SELECT ON CPAM.alojamiento TO [rol_vendedor];
GRANT SELECT ON CPAM.habitacion TO [rol_vendedor];
DENY DELETE ON CPAM.cliente TO [rol_vendedor];
DENY DELETE ON CPAM.reserva TO [rol_vendedor];
DENY ALTER ANY USER TO [rol_vendedor];
DENY ALTER ANY ROLE TO [rol_vendedor];
DENY BACKUP DATABASE TO [rol_vendedor];
DENY BACKUP LOG TO [rol_vendedor];
GO

-- Permisos rol_analista
GRANT SELECT ON CPAM.cliente TO [rol_analista];
GRANT SELECT ON CPAM.reserva TO [rol_analista];
GRANT SELECT ON CPAM.pago TO [rol_analista];
GRANT SELECT ON CPAM.alojamiento TO [rol_analista];
GRANT SELECT ON CPAM.habitacion TO [rol_analista];
GRANT SELECT ON CPAM.paquete TO [rol_analista];
GRANT SELECT ON CPAM.lugar_turistico TO [rol_analista];
DENY INSERT, UPDATE, DELETE ON SCHEMA::CPAM TO [rol_analista];
DENY INSERT, UPDATE, DELETE ON SCHEMA::dbo TO [rol_analista];
DENY INSERT, UPDATE, DELETE ON CPAM.cliente TO [rol_analista];
DENY INSERT, UPDATE, DELETE ON CPAM.reserva TO [rol_analista];
DENY INSERT, UPDATE, DELETE ON CPAM.pago TO [rol_analista];
DENY INSERT, UPDATE, DELETE ON CPAM.alojamiento TO [rol_analista];
DENY INSERT, UPDATE, DELETE ON CPAM.habitacion TO [rol_analista];
DENY INSERT, UPDATE, DELETE ON CPAM.paquete TO [rol_analista];
DENY INSERT, UPDATE, DELETE ON CPAM.lugar_turistico TO [rol_analista];
DENY BACKUP DATABASE TO [rol_analista];
DENY BACKUP LOG TO [rol_analista];
DENY ALTER ANY USER TO [rol_analista];
DENY ALTER ANY ROLE TO [rol_analista];
GO

PRINT 'Permisos granulares configurados correctamente.';

-- Verificación de permisos
SELECT pr.name AS rol, dp.permission_name, dp.state_desc,
       OBJECT_SCHEMA_NAME(dp.major_id) AS esquema, OBJECT_NAME(dp.major_id) AS objeto
FROM sys.database_permissions dp
JOIN sys.database_principals pr ON dp.grantee_principal_id = pr.principal_id
WHERE pr.name IN ('rol_vendedor', 'rol_analista')
ORDER BY pr.name, dp.state_desc, objeto;
GO
