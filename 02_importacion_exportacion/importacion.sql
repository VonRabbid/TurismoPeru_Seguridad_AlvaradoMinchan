-- Staging, validación y carga a producción de clientes
USE [TURISMOPERU_CPAM];
GO

-- Tabla de staging cliente_importacion
IF OBJECT_ID('dbo.cliente_importacion', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.cliente_importacion (
        Documento       VARCHAR(20)  NULL,
        Nombres         VARCHAR(100) NULL,
        ApellidoPaterno VARCHAR(100) NULL,
        ApellidoMaterno VARCHAR(100) NULL
    );
END
GO

-- Sinónimos de compatibilidad entre esquemas
IF NOT EXISTS (SELECT * FROM sys.synonyms WHERE name = 'cliente_importacion' AND schema_id = SCHEMA_ID('CPAM'))
    CREATE SYNONYM CPAM.cliente_importacion FOR dbo.cliente_importacion;
GO

IF NOT EXISTS (SELECT * FROM sys.synonyms WHERE name = 'cliente' AND schema_id = SCHEMA_ID('dbo'))
    CREATE SYNONYM dbo.cliente FOR CPAM.cliente;
GO

-- Comando BCP para carga masiva:
-- bcp TURISMOPERU_CPAM.dbo.cliente_importacion in "clientes.csv" -c -t "," -r "0x0a" -F 2 -S 161.132.54.162 -U <USUARIO_SQL> -P "<CONTRASEÑA_SQL>" -u

-- Detección de duplicados internos en el lote
WITH LoteNumerado AS (
    SELECT Documento, Nombres, ApellidoPaterno, ApellidoMaterno,
           ROW_NUMBER() OVER (PARTITION BY Documento ORDER BY Nombres, ApellidoPaterno) AS FilaNumero
    FROM dbo.cliente_importacion
    WHERE Documento IS NOT NULL AND LTRIM(RTRIM(Documento)) <> ''
)
SELECT Documento, Nombres, ApellidoPaterno, 'Duplicado interno en CSV' AS Motivo
FROM LoteNumerado
WHERE FilaNumero > 1;

-- Detección de duplicados preexistentes en producción
SELECT stg.Documento, stg.Nombres, stg.ApellidoPaterno, 'Ya existe en producción' AS Motivo
FROM dbo.cliente_importacion stg
WHERE EXISTS (SELECT 1 FROM CPAM.persona p WHERE p.numero_documento = stg.Documento);

-- Transferencia a tablas de producción (CPAM.persona y CPAM.cliente)
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO CPAM.persona (
        tipo_persona, nombres, apaterno, amaterno, razon_social,
        id_tipo_documento, numero_documento, id_nacionalidad, estado, fecha_registro
    )
    SELECT 
        'N', v.Nombres, v.ApellidoPaterno, v.ApellidoMaterno,
        RTRIM(v.Nombres) + ' ' + RTRIM(v.ApellidoPaterno) + ' ' + ISNULL(RTRIM(v.ApellidoMaterno), ''),
        1, v.Documento, 142, 'Activo', GETDATE()
    FROM (
        SELECT Documento, Nombres, ApellidoPaterno, ApellidoMaterno,
               ROW_NUMBER() OVER (PARTITION BY Documento ORDER BY Nombres) AS FilaNum
        FROM dbo.cliente_importacion
        WHERE Documento IS NOT NULL AND LTRIM(RTRIM(Documento)) <> ''
          AND Nombres IS NOT NULL AND LTRIM(RTRIM(Nombres)) <> ''
          AND ApellidoPaterno IS NOT NULL AND LTRIM(RTRIM(ApellidoPaterno)) <> ''
    ) v
    WHERE v.FilaNum = 1
      AND NOT EXISTS (SELECT 1 FROM CPAM.persona p WHERE p.numero_documento = v.Documento);

    INSERT INTO CPAM.cliente (id_persona, fecha_nacimiento)
    SELECT p.id_persona, '1995-01-01'
    FROM CPAM.persona p
    WHERE p.numero_documento IN (SELECT DISTINCT Documento FROM dbo.cliente_importacion)
      AND NOT EXISTS (SELECT 1 FROM CPAM.cliente c WHERE c.id_persona = p.id_persona);

    COMMIT TRANSACTION;
    PRINT 'Transferencia a producción completada exitosamente.';
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error en transferencia: ' + ERROR_MESSAGE();
END CATCH;
GO

-- Verificación de registros transferidos
SELECT c.id_persona, p.numero_documento, p.nombres, p.apaterno, p.estado
FROM CPAM.cliente c
JOIN CPAM.persona p ON c.id_persona = p.id_persona
WHERE p.numero_documento IN (SELECT DISTINCT Documento FROM dbo.cliente_importacion);
GO
