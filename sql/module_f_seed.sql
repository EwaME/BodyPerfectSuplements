-- =============================================================
-- MÓDULO F — Histórico de Transacciones (Funciones y Permisos RBAC)
-- Ejecutar este script en la base de datos para habilitar los
-- accesos del cliente y del administrador al Módulo F.
-- =============================================================

-- 1. Registro de Funciones de Menú y Controladores
INSERT IGNORE INTO `funciones` (`fncod`, `fndsc`, `fnest`, `fntyp`) VALUES
    ('Menu_Historial',                       'Menú Mis Compras',           'ACT', 'MNU'),
    ('Controllers\\History\\History',        'Histórico de Transacciones', 'ACT', 'CTR'),
    ('Controllers\\History\\Detail',         'Detalle de Transacción',   'ACT', 'CTR'),
    ('Controllers\\History\\Export',         'Exportar Transacciones',   'ACT', 'CTR'),
    ('Controllers\\History\\Admin',          'Admin Transacciones',      'ACT', 'CTR');

-- 2. Permisos para el Rol Cliente (CLI)
INSERT IGNORE INTO `funciones_roles` (`rolescod`, `fncod`, `fnrolest`) VALUES
    ('CLI', 'Menu_Historial',                 'ACT'),
    ('CLI', 'Controllers\\History\\History', 'ACT'),
    ('CLI', 'Controllers\\History\\Detail',  'ACT'),
    ('CLI', 'Controllers\\History\\Export',  'ACT');

-- 3. Permisos para el Rol Administrador (ADM)
INSERT IGNORE INTO `funciones_roles` (`rolescod`, `fncod`, `fnrolest`) VALUES
    ('ADM', 'Controllers\\History\\Admin',   'ACT'),
    ('ADM', 'Controllers\\History\\Detail',  'ACT'),
    ('ADM', 'Controllers\\History\\Export',  'ACT');
