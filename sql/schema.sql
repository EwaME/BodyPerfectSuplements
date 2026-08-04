-- =============================================================
-- BodyPerfect Suplementos — Esquema de Base de Datos
-- Framework: Simple PHP MVC OOP
-- Proyecto Final Negocios Web
--
-- NOTA IMPORTANTE — carrito anónimo:
--   El Dao Cart/Cart.php del template trae un typo: consulta
--   la tabla como `carretillaanom` (con M). Este script crea
--   la tabla con el nombre correcto `carretillaanon` (con N).
--   El Módulo C debe corregir el nombre en su Dao antes de
--   integrarse.
-- =============================================================

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

-- -------------------------------------------------------------
-- MÓDULO D — Seguridad
-- Nomenclatura exacta del framework del curso
-- -------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `usuario` (
    `usercod`     BIGINT(10)   NOT NULL AUTO_INCREMENT,
    `useremail`   VARCHAR(80)  NOT NULL,
    `username`    VARCHAR(80)  NOT NULL,
    `userpswd`    VARCHAR(128) NOT NULL,
    `userfching`  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `userpswdest` CHAR(3)      NOT NULL DEFAULT 'ACT',
    `userpswdexp` DATETIME     NOT NULL,
    `userest`     CHAR(3)      NOT NULL DEFAULT 'ACT',
    `useractcod`  VARCHAR(128) NOT NULL,
    `userpswdchg` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `usertipo`    CHAR(3)      NOT NULL DEFAULT 'PBL',
    PRIMARY KEY (`usercod`),
    UNIQUE KEY `uk_useremail` (`useremail`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- usertipo: PBL = público/cliente, ADM = administrador, AUD = auditor
-- userest / userpswdest: ACT, INA, BLQ, SUS

CREATE TABLE IF NOT EXISTS `roles` (
    `rolescod` VARCHAR(30)  NOT NULL,
    `rolesdsc` VARCHAR(100) NOT NULL,
    `rolesest` CHAR(3)      NOT NULL DEFAULT 'ACT',
    PRIMARY KEY (`rolescod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `roles_usuarios` (
    `usercod`     BIGINT(10)  NOT NULL,
    `rolescod`    VARCHAR(30) NOT NULL,
    `roleuserest` CHAR(3)     NOT NULL DEFAULT 'ACT',
    `roleuserfch` DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `roleuserexp` DATETIME    NULL,
    PRIMARY KEY (`usercod`, `rolescod`),
    CONSTRAINT `fk_ru_usuario` FOREIGN KEY (`usercod`) REFERENCES `usuario` (`usercod`),
    CONSTRAINT `fk_ru_roles`   FOREIGN KEY (`rolescod`) REFERENCES `roles` (`rolescod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `funciones` (
    `fncod` VARCHAR(80)  NOT NULL,
    `fndsc` VARCHAR(100) NOT NULL,
    `fnest` CHAR(3)      NOT NULL DEFAULT 'ACT',
    `fntyp` CHAR(3)      NOT NULL DEFAULT 'FNC',
    PRIMARY KEY (`fncod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- fntyp: CTR = controlador (pantalla), MNU = ítem de menú, FNC = función genérica

CREATE TABLE IF NOT EXISTS `funciones_roles` (
    `rolescod` VARCHAR(30) NOT NULL,
    `fncod`    VARCHAR(80) NOT NULL,
    `fnrolest` CHAR(3)     NOT NULL DEFAULT 'ACT',
    `fnexp`    DATETIME    NULL,
    PRIMARY KEY (`rolescod`, `fncod`),
    CONSTRAINT `fk_fr_roles`    FOREIGN KEY (`rolescod`) REFERENCES `roles` (`rolescod`),
    CONSTRAINT `fk_fr_funciones` FOREIGN KEY (`fncod`)   REFERENCES `funciones` (`fncod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `bitacora` (
    `bitacoracod`    BIGINT(10)   NOT NULL AUTO_INCREMENT,
    `bitacorafch`    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `bitprograma`    VARCHAR(80)  NOT NULL,
    `bitdescripcion` VARCHAR(200) NOT NULL,
    `bitobservacion` TEXT         NULL,
    `bitTipo`        CHAR(3)      NOT NULL,
    `bitusuario`     BIGINT(10)   NULL,
    PRIMARY KEY (`bitacoracod`),
    CONSTRAINT `fk_bit_usuario` FOREIGN KEY (`bitusuario`) REFERENCES `usuario` (`usercod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- bitTipo: LOG = login, OUT = logout, ERR = error, AUD = auditoría

CREATE TABLE IF NOT EXISTS `two_factor_secrets` (
    `id`       INT         NOT NULL AUTO_INCREMENT,
    `usercod`  BIGINT(10)  NOT NULL,
    `secret`   VARCHAR(32) NOT NULL,
    `activado` TINYINT(1)  NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_2fa_usuario` (`usercod`),
    CONSTRAINT `fk_2fa_usuario` FOREIGN KEY (`usercod`) REFERENCES `usuario` (`usercod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -------------------------------------------------------------
-- MÓDULO B — Catálogo de Productos
-- Nomenclatura: camelCase inglés (patrón del curso para catálogo)
-- -------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `categories` (
    `categoryId`          INT          NOT NULL AUTO_INCREMENT,
    `categoryName`        VARCHAR(100) NOT NULL,
    `categoryDescription` TEXT         NULL,
    `parentCategoryId`    INT          NULL,
    PRIMARY KEY (`categoryId`),
    CONSTRAINT `fk_cat_parent` FOREIGN KEY (`parentCategoryId`) REFERENCES `categories` (`categoryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `products` (
    `productId`          INT            NOT NULL AUTO_INCREMENT,
    `productName`        VARCHAR(150)   NOT NULL,
    `productDescription` TEXT           NULL,
    `productPrice`       DECIMAL(10, 2) NOT NULL,
    `productImgUrl`      VARCHAR(255)   NULL,
    `productStock`       INT            NOT NULL DEFAULT 0,
    `productStatus`      CHAR(3)        NOT NULL DEFAULT 'ACT',
    `categoryId`         INT            NULL,
    PRIMARY KEY (`productId`),
    CONSTRAINT `fk_prod_category` FOREIGN KEY (`categoryId`) REFERENCES `categories` (`categoryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- productStatus: ACT = activo/disponible, INA = inactivo, AGO = agotado
-- Cuando productStock llega a 0 el controlador cambia status a 'AGO' automáticamente

CREATE TABLE IF NOT EXISTS `sales` (
    `id`        INT            NOT NULL AUTO_INCREMENT,
    `productId` INT            NOT NULL,
    `salePrice` DECIMAL(10, 2) NOT NULL,
    `saleStart` DATETIME       NOT NULL,
    `saleEnd`   DATETIME       NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_sale_product` FOREIGN KEY (`productId`) REFERENCES `products` (`productId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `highlights` (
    `id`             INT      NOT NULL AUTO_INCREMENT,
    `productId`      INT      NOT NULL,
    `highlightStart` DATETIME NOT NULL,
    `highlightEnd`   DATETIME NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_hl_product` FOREIGN KEY (`productId`) REFERENCES `products` (`productId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `reviews` (
    `id`           INT        NOT NULL AUTO_INCREMENT,
    `productId`    INT        NOT NULL,
    `usercod`      BIGINT(10) NOT NULL,
    `calificacion` TINYINT(1) NOT NULL COMMENT '1-5 estrellas',
    `comentario`   TEXT       NULL,
    `created_at`   DATETIME   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_rev_product` FOREIGN KEY (`productId`) REFERENCES `products` (`productId`),
    CONSTRAINT `fk_rev_usuario` FOREIGN KEY (`usercod`)   REFERENCES `usuario` (`usercod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -------------------------------------------------------------
-- MÓDULO C — Carrito de Compras
-- Patrón TTL: sin campo de estado, la vigencia se calcula
-- por ventana de tiempo sobre crrfching.
-- AVISO: Cart/Cart.php del template usa "carretillaanom" (M).
-- Módulo C debe cambiar ese nombre a "carretillaanon" (N).
-- -------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `carretilla` (
    `usercod`   BIGINT(10)     NOT NULL,
    `productId` INT            NOT NULL,
    `crrctd`    INT            NOT NULL DEFAULT 1,
    `crrprc`    DECIMAL(10, 2) NOT NULL,
    `crrfching` DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`usercod`, `productId`),
    CONSTRAINT `fk_crr_usuario`  FOREIGN KEY (`usercod`)   REFERENCES `usuario` (`usercod`),
    CONSTRAINT `fk_crr_producto` FOREIGN KEY (`productId`) REFERENCES `products` (`productId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `carretillaanon` (
    `anoncod`   VARCHAR(64)    NOT NULL,
    `productId` INT            NOT NULL,
    `crrctd`    INT            NOT NULL DEFAULT 1,
    `crrprc`    DECIMAL(10, 2) NOT NULL,
    `crrfching` DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`anoncod`, `productId`),
    CONSTRAINT `fk_crra_producto` FOREIGN KEY (`productId`) REFERENCES `products` (`productId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -------------------------------------------------------------
-- MÓDULO E — Pedidos y Pasarela de Pagos
-- ESTAS TABLAS NO EXISTEN en el código de referencia del curso.
-- El Módulo E las crea y es dueño de la persistencia aquí.
-- estados pedidos: PND=pendiente, APR=aprobado, RCH=rechazado, CAN=cancelado
-- -------------------------------------------------------------

CREATE TABLE IF NOT EXISTS `pedidos` (
    `id`       INT            NOT NULL AUTO_INCREMENT,
    `usercod`  BIGINT(10)     NOT NULL,
    `total`    DECIMAL(10, 2) NOT NULL,
    `estado`   CHAR(3)        NOT NULL DEFAULT 'PND',
    `fecha`    DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_ped_usuario` FOREIGN KEY (`usercod`) REFERENCES `usuario` (`usercod`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `pedido_detalle` (
    `id`             INT            NOT NULL AUTO_INCREMENT,
    `pedidoId`       INT            NOT NULL,
    `productId`      INT            NOT NULL,
    `cantidad`       INT            NOT NULL,
    `precioUnitario` DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_pd_pedido`   FOREIGN KEY (`pedidoId`)  REFERENCES `pedidos` (`id`),
    CONSTRAINT `fk_pd_producto` FOREIGN KEY (`productId`) REFERENCES `products` (`productId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS `transacciones` (
    `id`                  INT            NOT NULL AUTO_INCREMENT,
    `pedidoId`            INT            NOT NULL,
    `metodoPago`          VARCHAR(30)    NOT NULL DEFAULT 'PAYPAL',
    `referenciaPasarela`  VARCHAR(100)   NULL,
    `estado`              CHAR(3)        NOT NULL DEFAULT 'PND',
    `monto`               DECIMAL(10, 2) NOT NULL,
    `fecha`               DATETIME       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_trx_pedido` FOREIGN KEY (`pedidoId`) REFERENCES `pedidos` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================
-- DATOS SEMILLA
-- =============================================================

-- Roles base del sistema
INSERT IGNORE INTO `roles` (`rolescod`, `rolesdsc`, `rolesest`) VALUES
    ('ADM', 'Administrador', 'ACT'),
    ('CLI', 'Cliente',       'ACT');

-- Categorías de suplementos (datos de prueba)
INSERT IGNORE INTO `categories` (`categoryId`, `categoryName`, `categoryDescription`, `parentCategoryId`) VALUES
    (1, 'Proteínas',    'Suplementos proteicos para recuperación muscular', NULL),
    (2, 'Pre-Entrenos', 'Energía y enfoque para el entrenamiento',          NULL),
    (3, 'Vitaminas',    'Vitaminas y minerales esenciales',                 NULL),
    (4, 'Whey',         'Proteína de suero de leche',                      1),
    (5, 'Vegana',       'Proteína de origen vegetal',                      1),
    (6, 'Caseína',      'Proteína de liberación lenta',                    1);

-- Productos de prueba
INSERT IGNORE INTO `products` (`productId`, `productName`, `productDescription`, `productPrice`, `productImgUrl`, `productStock`, `productStatus`, `categoryId`) VALUES
    (1, 'Whey Gold Standard 5lb',    'Proteína whey de alta calidad, 24g por porción.',   85.00, 'p6a6ffc42971824.10737467.png', 50, 'ACT', 4),
    (2, 'Proteína Vegana Pea 2lb',   'Proteína de guisante 100% vegana, sin lactosa.',     62.00, 'p6a6ffc3e141f37.83416368.png', 30, 'ACT', 5),
    (3, 'Pre-Entreno N.O. Xplode',   'Máxima energía y bombeo muscular.',                 45.00, 'p6a6ffc3812cfa8.18191402.jpg',  40, 'ACT', 2),
    (4, 'Caseína Micelar 4lb',       'Proteína de liberación lenta ideal para la noche.', 75.00, 'p6a6ffbd9c1cad6.38587830.jpg',     20, 'ACT', 6),
    (5, 'Vitamina C 1000mg x90',     'Refuerzo inmunológico, 90 cápsulas.',                12.00, 'p6a6ffbcf4f0012.60461186.jpg',     100, 'ACT', 3),
    (6, 'Multivitamínico Sport x60', 'Complejo vitamínico para deportistas.',              18.00, NULL,      80, 'ACT', 3),
    (7, 'Creatina Monohidratada 300g', 'Creatina pura, aumenta fuerza y rendimiento.',      28.00, NULL,      4, 'ACT', 1);

-- Destacados activos (fechas fijas para evitar problemas de timezone en import)
INSERT IGNORE INTO `highlights` (`productId`, `highlightStart`, `highlightEnd`) VALUES
    (1, '2026-08-01 00:00:00', '2026-09-30 23:59:59'),
    (3, '2026-08-01 00:00:00', '2026-09-30 23:59:59');

-- Oferta del día
INSERT IGNORE INTO `sales` (`productId`, `salePrice`, `saleStart`, `saleEnd`) VALUES
    (2, 49.99, '2026-08-01 00:00:00', '2026-09-30 23:59:59'),
    (5,  9.99, '2026-08-01 00:00:00', '2026-09-30 23:59:59');

-- Funciones de menú y controladores (acceso RBAC por rol)
INSERT IGNORE INTO `funciones` (`fncod`, `fndsc`, `fnest`, `fntyp`) VALUES
    ('Menu_Catalogo',                        'Catálogo de Productos',  'ACT', 'MNU'),
    ('Menu_PaymentCheckout',                 'Carrito de Compras',     'ACT', 'MNU'),
    ('Menu_AdminProductos',                  'Admin Productos Menu',   'ACT', 'MNU'),
    ('Controllers\\Products\\Admin',         'Admin Lista Productos',  'ACT', 'CTR'),
    ('Controllers\\Products\\Create',        'Admin Crear Producto',   'ACT', 'CTR'),
    ('Controllers\\Products\\Edit',          'Admin Editar Producto',  'ACT', 'CTR'),
    ('Controllers\\Products\\Toggle',        'Admin Toggle Status',    'ACT', 'CTR'),
    ('Menu_2FA',                             'Menu Configurar 2FA',    'ACT', 'MNU'),
    ('Controllers\\Sec\\TwoFactorSetup',     'Configurar Doble Factor','ACT', 'CTR');

INSERT IGNORE INTO `funciones_roles` (`rolescod`, `fncod`, `fnrolest`) VALUES
    ('ADM', 'Menu_Catalogo',                       'ACT'),
    ('ADM', 'Menu_PaymentCheckout',                'ACT'),
    ('ADM', 'Menu_AdminProductos',                 'ACT'),
    ('ADM', 'Controllers\\Products\\Admin',        'ACT'),
    ('ADM', 'Controllers\\Products\\Create',       'ACT'),
    ('ADM', 'Controllers\\Products\\Edit',         'ACT'),
    ('ADM', 'Controllers\\Products\\Toggle',       'ACT'),
    ('ADM', 'Menu_2FA',                            'ACT'),
    ('ADM', 'Controllers\\Sec\\TwoFactorSetup',    'ACT'),
    ('CLI', 'Menu_Catalogo',                       'ACT'),
    ('CLI', 'Menu_PaymentCheckout',                'ACT');
-- Nota: Menu_2FA y Controllers\Sec\TwoFactorSetup solo se asignan al rol ADM
-- a propósito -- el 2FA (extra del Módulo D) es exclusivo del backoffice,
-- el cliente regular no debe ver esa pantalla ni requiere doble factor.

-- =============================================================
-- USUARIO ADMINISTRADOR INICIAL
--
-- Ejecuta este script PHP UNA SOLA VEZ para obtener el hash:
--
--   php -r "
--     \$pwd = 'Admin1234!';
--     \$salt = hash_hmac('sha256', \$pwd, 'TU_PWD_HASH_DE_ENV');
--     echo password_hash(\$salt, PASSWORD_BCRYPT);
--   "
--
-- Luego reemplaza el hash en el INSERT y ejecuta:
-- =============================================================

-- INSERT INTO `usuario`
--     (`useremail`, `username`, `userpswd`, `userfching`,
--      `userpswdest`, `userpswdexp`, `userest`, `useractcod`, `userpswdchg`, `usertipo`)
-- VALUES
--     ('admin@bodyperfect.com', 'Administrador',
--      'PEGA_EL_HASH_AQUI',
--      NOW(), 'ACT', DATE_ADD(NOW(), INTERVAL 90 DAY),
--      'ACT', 'setup_inicial', NOW(), 'ADM');

-- -- Asignar rol ADM al admin (usercod=1 asumiendo que es el primer usuario)
-- INSERT INTO `roles_usuarios` (`usercod`, `rolescod`, `roleuserest`, `roleuserfch`)
-- VALUES (1, 'ADM', 'ACT', NOW());

SET FOREIGN_KEY_CHECKS = 1;
