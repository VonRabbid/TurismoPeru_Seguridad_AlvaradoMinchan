-- Creación de roles personalizados y asignación de membresías
USE [TURISMOPERU_CPAM];
GO

-- Rol personalizado rol_vendedor
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'rol_vendedor' AND type = 'R')
    CREATE ROLE [rol_vendedor];
GO

-- Rol personalizado rol_analista
IF NOT EXISTS (SELECT name FROM sys.database_principals WHERE name = 'rol_analista' AND type = 'R')
    CREATE ROLE [rol_analista];
GO

-- Asignación de miembros
ALTER ROLE [db_owner] ADD MEMBER [turismo_admin];
ALTER ROLE [rol_vendedor] ADD MEMBER [turismo_vendedor];
ALTER ROLE [rol_analista] ADD MEMBER [turismo_analista];
GO

PRINT 'Roles y membresías asignados correctamente.';

-- Verificación de membresías
SELECT r.name AS rol, m.name AS miembro, m.type_desc, r.is_fixed_role
FROM sys.database_role_members rm
JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
JOIN sys.database_principals m ON rm.member_principal_id = m.principal_id
WHERE r.name IN ('db_owner', 'rol_vendedor', 'rol_analista')
  AND m.name IN ('turismo_admin', 'turismo_vendedor', 'turismo_analista');
GO
