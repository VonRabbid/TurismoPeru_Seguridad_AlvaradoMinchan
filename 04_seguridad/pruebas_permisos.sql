-- Pruebas de validación de permisos y denegaciones (Error 229)
USE [TURISMOPERU_CPAM];
GO
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- Escenario 1: Pruebas con turismo_analista
EXECUTE AS USER = 'turismo_analista';

-- 1.1 Lectura en CPAM.pago (Permitida)
BEGIN TRY
    SELECT TOP 3 id_pago, id_reserva, monto, fecha_pago, estado FROM CPAM.pago;
    PRINT 'SELECT en CPAM.pago autorizado para turismo_analista.';
END TRY
BEGIN CATCH
    PRINT 'Error en SELECT: ' + ERROR_MESSAGE();
END CATCH;

-- 1.2 Inserción en CPAM.pago (Denegada - Error 229)
BEGIN TRY
    INSERT INTO CPAM.pago (id_reserva, id_medio_pago, monto, fecha_pago, estado)
    VALUES (1, 1, 999.99, GETDATE(), 'AuditTest');
END TRY
BEGIN CATCH
    PRINT 'Error 229: Permiso INSERT denegado como se esperaba para turismo_analista.';
END CATCH;

REVERT;
GO

-- Escenario 2: Pruebas con turismo_vendedor
EXECUTE AS USER = 'turismo_vendedor';

-- 2.1 Lectura en CPAM.reserva (Permitida)
BEGIN TRY
    SELECT TOP 3 id_reserva, codigo_reserva, precio_total, fecha_reserva FROM CPAM.reserva;
    PRINT 'SELECT en CPAM.reserva autorizado para turismo_vendedor.';
END TRY
BEGIN CATCH
    PRINT 'Error en SELECT: ' + ERROR_MESSAGE();
END CATCH;

-- 2.2 Eliminación en CPAM.reserva (Denegada - Error 229)
BEGIN TRY
    DELETE FROM CPAM.reserva WHERE id_reserva = -1;
END TRY
BEGIN CATCH
    PRINT 'Error 229: Permiso DELETE en reserva denegado como se esperaba para turismo_vendedor.';
END CATCH;

-- 2.3 Eliminación en CPAM.cliente (Denegada - Error 229)
BEGIN TRY
    DELETE FROM CPAM.cliente WHERE id_persona = -1;
END TRY
BEGIN CATCH
    PRINT 'Error 229: Permiso DELETE en cliente denegado como se esperaba para turismo_vendedor.';
END CATCH;

REVERT;
GO
