

INSERT IGNORE INTO `funciones` (`fncod`, `fndsc`, `fnest`, `fntyp`) VALUES
    ('Menu_Historial', 'Menú Mis Compras', 'ACT', 'MNU'),
    ('Controllers\\History\\History', 'Histórico de Transacciones', 'ACT', 'CTR'),
    ('Controllers\\History\\Detail', 'Detalle de Transacción', 'ACT', 'CTR'),
    ('Controllers\\History\\Export', 'Exportar Transacciones', 'ACT', 'CTR'),
    ('Controllers\\History\\Admin', 'Admin Transacciones', 'ACT', 'CTR');

INSERT IGNORE INTO `funciones_roles` (`rolescod`, `fncod`, `fnrolest`) VALUES
    ('CLI', 'Menu_Historial', 'ACT'),
    ('CLI', 'Controllers\\History\\History', 'ACT'),
    ('CLI', 'Controllers\\History\\Detail', 'ACT'),
    ('CLI', 'Controllers\\History\\Export', 'ACT');

INSERT IGNORE INTO `funciones_roles` (`rolescod`, `fncod`, `fnrolest`) VALUES
    ('ADM', 'Controllers\\History\\Admin', 'ACT'),
    ('ADM', 'Controllers\\History\\Detail', 'ACT'),
    ('ADM', 'Controllers\\History\\Export', 'ACT');
