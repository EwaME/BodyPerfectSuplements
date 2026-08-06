CREATE SCHEMA IF NOT EXISTS `ecommerce` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `ecommerce`;

SET FOREIGN_KEY_CHECKS = 0;
SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

CREATE TABLE IF NOT EXISTS `usuario` (
    `usercod`     bigint(10)   NOT NULL AUTO_INCREMENT,
    `useremail`   varchar(80)  DEFAULT NULL,
    `username`    varchar(80)  DEFAULT NULL,
    `userpswd`    varchar(128) DEFAULT NULL,
    `userfching`  datetime     DEFAULT NULL,
    `userpswdest` char(3)      DEFAULT NULL,
    `userpswdexp` datetime     DEFAULT NULL,
    `userest`     char(3)      DEFAULT NULL,
    `useractcod`  varchar(128) DEFAULT NULL,
    `userpswdchg` varchar(128) DEFAULT NULL,
    `usertipo`    char(3)      DEFAULT NULL COMMENT 'Tipo de Usuario, Normal, Consultor o Cliente',
    PRIMARY KEY (`usercod`),
    UNIQUE KEY `useremail_UNIQUE` (`useremail`),
    KEY `usertipo` (`usertipo`, `useremail`, `usercod`, `userest`)
) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS `roles` (
    `rolescod` varchar(128) NOT NULL,
    `rolesdsc` varchar(45)  DEFAULT NULL,
    `rolesest` char(3)      DEFAULT NULL,
    PRIMARY KEY (`rolescod`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS `roles_usuarios` (
    `usercod`     bigint(10)   NOT NULL,
    `rolescod`    varchar(128) NOT NULL,
    `roleuserest` char(3)      DEFAULT NULL,
    `roleuserfch` datetime     DEFAULT NULL,
    `roleuserexp` datetime     DEFAULT NULL,
    PRIMARY KEY (`usercod`, `rolescod`),
    KEY `rol_usuario_key_idx` (`rolescod`),
    CONSTRAINT `rol_usuario_key` FOREIGN KEY (`rolescod`) REFERENCES `roles` (`rolescod`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `usuario_rol_key` FOREIGN KEY (`usercod`) REFERENCES `usuario` (`usercod`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS `funciones` (
    `fncod` varchar(255) NOT NULL,
    `fndsc` varchar(255) DEFAULT NULL,
    `fnest` char(3)      DEFAULT NULL,
    `fntyp` char(3)      DEFAULT NULL,
    PRIMARY KEY (`fncod`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS `funciones_roles` (
    `rolescod`  varchar(128) NOT NULL,
    `fncod`     varchar(255) NOT NULL,
    `fnrolest`  char(3)      DEFAULT NULL,
    `fnexp`     datetime     DEFAULT NULL,
    PRIMARY KEY (`rolescod`, `fncod`),
    KEY `rol_funcion_key_idx` (`fncod`),
    CONSTRAINT `funcion_rol_key` FOREIGN KEY (`rolescod`) REFERENCES `roles` (`rolescod`) ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT `rol_funcion_key` FOREIGN KEY (`fncod`) REFERENCES `funciones` (`fncod`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE = InnoDB DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS `bitacora` (
    `bitacoracod`    int(11)      NOT NULL AUTO_INCREMENT,
    `bitacorafch`    datetime     DEFAULT NULL,
    `bitprograma`    varchar(255) DEFAULT NULL,
    `bitdescripcion` varchar(255) DEFAULT NULL,
    `bitobservacion` mediumtext,
    `bitTipo`        char(3)      DEFAULT NULL,
    `bitusuario`     bigint(18)   DEFAULT NULL,
    PRIMARY KEY (`bitacoracod`)
) ENGINE = InnoDB AUTO_INCREMENT = 10 DEFAULT CHARSET = utf8;

CREATE TABLE IF NOT EXISTS `two_factor_secrets` (
    `id`       int(11)     NOT NULL AUTO_INCREMENT,
    `usercod`  bigint(10)  NOT NULL,
    `secret`   varchar(32) NOT NULL,
    `activado` tinyint(1)  NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    UNIQUE KEY `two_factor_user_unique` (`usercod`),
    CONSTRAINT `two_factor_user_key` FOREIGN KEY (`usercod`)
        REFERENCES `usuario` (`usercod`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS `categories` (
    `categoryId`          int(11)      NOT NULL AUTO_INCREMENT,
    `categoryName`        varchar(255) NOT NULL,
    `categoryDescription` text         DEFAULT NULL,
    `parentCategoryId`    int(11)      DEFAULT NULL,
    PRIMARY KEY (`categoryId`),
    KEY `parentCategoryId_idx` (`parentCategoryId`),
    CONSTRAINT `category_parent_key` FOREIGN KEY (`parentCategoryId`)
        REFERENCES `categories` (`categoryId`)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS `products` (
    `productId`          int(11)        NOT NULL AUTO_INCREMENT,
    `productName`        varchar(255)   NOT NULL,
    `productDescription` text           NOT NULL,
    `productPrice`       decimal(10, 2) NOT NULL,
    `productImgUrl`      varchar(255)   NOT NULL DEFAULT '',
    `productStock`       int(11)        NOT NULL DEFAULT 0,
    `productStatus`      char(3)        NOT NULL DEFAULT 'ACT',
    `categoryId`         int(11)        DEFAULT NULL,
    PRIMARY KEY (`productId`),
    KEY `categoryId_idx` (`categoryId`),
    CONSTRAINT `product_category_key` FOREIGN KEY (`categoryId`)
        REFERENCES `categories` (`categoryId`)
        ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8mb4;

ALTER TABLE `products` ADD COLUMN IF NOT EXISTS `productStock` int(11) NOT NULL DEFAULT 0 AFTER `productImgUrl`;
ALTER TABLE `products` ADD COLUMN IF NOT EXISTS `productStatus` char(3) NOT NULL DEFAULT 'ACT' AFTER `productStock`;
ALTER TABLE `products` ADD COLUMN IF NOT EXISTS `categoryId` int(11) DEFAULT NULL AFTER `productStatus`;

CREATE TABLE IF NOT EXISTS `sales` (
    `saleId`    int(11)        NOT NULL AUTO_INCREMENT,
    `productId` int(11)        NOT NULL,
    `salePrice` decimal(10, 2) NOT NULL,
    `saleStart` datetime       NOT NULL,
    `saleEnd`   datetime       NOT NULL,
    PRIMARY KEY (`saleId`),
    KEY `sales_product_idx` (`productId`),
    CONSTRAINT `sales_product_key` FOREIGN KEY (`productId`)
        REFERENCES `products` (`productId`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS `highlights` (
    `highlightId`    int(11)  NOT NULL AUTO_INCREMENT,
    `productId`      int(11)  NOT NULL,
    `highlightStart` datetime NOT NULL,
    `highlightEnd`   datetime NOT NULL,
    PRIMARY KEY (`highlightId`),
    KEY `highlights_product_idx` (`productId`),
    CONSTRAINT `highlights_product_key` FOREIGN KEY (`productId`)
        REFERENCES `products` (`productId`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS `reviews` (
    `id`           int(11)    NOT NULL AUTO_INCREMENT,
    `productId`    int(11)    NOT NULL,
    `usercod`      bigint(10) NOT NULL,
    `calificacion` tinyint(1) NOT NULL COMMENT '1-5 estrellas',
    `comentario`   text       DEFAULT NULL,
    `created_at`   datetime   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `review_user_product_unique` (`productId`, `usercod`),
    KEY `reviews_user_idx` (`usercod`),
    CONSTRAINT `reviews_product_key` FOREIGN KEY (`productId`)
        REFERENCES `products` (`productId`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `reviews_user_key` FOREIGN KEY (`usercod`)
        REFERENCES `usuario` (`usercod`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS `carretilla` (
    `usercod`   bigint(10)     NOT NULL,
    `productId` int(11)        NOT NULL,
    `crrctd`    int(5)         NOT NULL,
    `crrprc`    decimal(12, 2) NOT NULL,
    `crrfching` datetime       NOT NULL,
    PRIMARY KEY (`usercod`, `productId`),
    KEY `carretilla_productId_idx` (`productId`),
    CONSTRAINT `carretilla_user_key` FOREIGN KEY (`usercod`)
        REFERENCES `usuario` (`usercod`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `carretilla_prd_key` FOREIGN KEY (`productId`)
        REFERENCES `products` (`productId`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS `carretillaanon` (
    `anoncod`   varchar(128)   NOT NULL,
    `productId` int(11)        NOT NULL,
    `crrctd`    int(5)         NOT NULL,
    `crrprc`    decimal(12, 2) NOT NULL,
    `crrfching` datetime       NOT NULL,
    PRIMARY KEY (`anoncod`, `productId`),
    KEY `carretillaanon_productId_idx` (`productId`),
    CONSTRAINT `carretillaanon_prd_key` FOREIGN KEY (`productId`)
        REFERENCES `products` (`productId`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS `pedidos` (
    `id`      int(11)        NOT NULL AUTO_INCREMENT,
    `usercod` bigint(10)     NOT NULL,
    `total`   decimal(12, 2) NOT NULL,
    `estado`  char(3)        NOT NULL DEFAULT 'PND' COMMENT 'PND=Pendiente, APR=Aprobado, RCH=Rechazado, CAN=Cancelado',
    `fecha`   datetime       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `pedidos_user_idx` (`usercod`),
    KEY `pedidos_estado_idx` (`estado`),
    CONSTRAINT `pedidos_user_key` FOREIGN KEY (`usercod`)
        REFERENCES `usuario` (`usercod`)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS `pedido_detalle` (
    `id`             int(11)        NOT NULL AUTO_INCREMENT,
    `pedidoId`       int(11)        NOT NULL,
    `productId`      int(11)        NOT NULL,
    `cantidad`       int(11)        NOT NULL,
    `precioUnitario` decimal(12, 2) NOT NULL,
    PRIMARY KEY (`id`),
    KEY `pedido_detalle_pedido_idx` (`pedidoId`),
    KEY `pedido_detalle_product_idx` (`productId`),
    CONSTRAINT `pedido_detalle_pedido_key` FOREIGN KEY (`pedidoId`)
        REFERENCES `pedidos` (`id`)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `pedido_detalle_product_key` FOREIGN KEY (`productId`)
        REFERENCES `products` (`productId`)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8mb4;

CREATE TABLE IF NOT EXISTS `transacciones` (
    `id`                 int(11)        NOT NULL AUTO_INCREMENT,
    `pedidoId`           int(11)        NOT NULL,
    `metodoPago`         varchar(20)    NOT NULL DEFAULT 'PAYPAL',
    `referenciaPasarela` varchar(255)   DEFAULT NULL COMMENT 'Order ID de PayPal',
    `estado`             char(3)        NOT NULL DEFAULT 'PND' COMMENT 'PND=Pendiente, APR=Aprobado, RCH=Rechazado, CAN=Cancelado',
    `monto`              decimal(12, 2) NOT NULL,
    `fecha`              datetime       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `transacciones_pedido_idx` (`pedidoId`),
    KEY `transacciones_ref_idx` (`referenciaPasarela`),
    CONSTRAINT `transacciones_pedido_key` FOREIGN KEY (`pedidoId`)
        REFERENCES `pedidos` (`id`)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8mb4;

-- roles del sistema
INSERT IGNORE INTO `roles` (`rolescod`, `rolesdsc`, `rolesest`) VALUES
    ('ADM', 'Administrador', 'ACT'),
    ('CLI', 'Cliente',       'ACT');

-- categorías
INSERT IGNORE INTO `categories` (`categoryId`, `categoryName`, `categoryDescription`, `parentCategoryId`) VALUES
    (1, 'Proteínas',          'Suplementos proteicos',            NULL),
    (2, 'Whey Protein',       'Proteína de suero de leche',       1),
    (3, 'Proteína Vegana',    'Proteína de origen vegetal',       1),
    (4, 'Pre-entreno',        'Energía y rendimiento',            NULL),
    (5, 'Creatina',           'Fuerza y potencia muscular',       NULL),
    (6, 'Aminoácidos',        'BCAA, Glutamina y más',            NULL),
    (7, 'Vitaminas y Salud',  'Multivitamínicos y bienestar',     NULL);

-- Catálogo de productos
INSERT IGNORE INTO `products` (`productId`, `productName`, `productDescription`, `productPrice`, `productImgUrl`, `productStock`, `productStatus`, `categoryId`) VALUES
    (11, 'Whey Protein Gold Standard 5lb',  'Proteína de suero sabor chocolate, 24g de proteína por servicio.',      1200.00, 'p6a74b50ad226e4.44276846.png', 50, 'ACT', 2),
    (12, 'Whey Protein Isolate 4lb',        'Isolate de alta pureza, bajo en lactosa. Sabor vainilla.',              1500.00, 'p6a74b6a530ff72.47822017.jpg', 30, 'ACT', 2),
    (13, 'Whey Protein 100% 3lb',           'Mezcla de concentrado e isolate. Sabor fresa.',                          850.00, 'p6a74b67d414e39.57298466.png', 40, 'ACT', 2),
    (14, 'Proteína Vegana Chocolate 2lb',   'Base de guisante y arroz, libre de lactosa y gluten.',                   950.00, 'p6a74b6471196c0.19504878.png', 20, 'ACT', 3),
    (15, 'Proteína Vegana Vainilla 2lb',    'Proteína vegetal completa con todos los aminoácidos esenciales.',       950.00, 'p6a74b63d168f12.53209269.jpg', 15, 'ACT', 3),
    (16, 'C4 Original Pre-entreno 30 sv',   'Energía y enfoque para tu entrenamiento. Sabor sandía.',                 850.00, 'p6a74b4bd5f3b56.26044628.jpg', 35, 'ACT', 4),
    (17, 'NO-Xplode Pre-entreno 30 sv',     'Formula avanzada con cafeína, beta-alanina y creatina.',                 900.00, 'p6a74b49aae3fb8.36926915.jpg', 25, 'ACT', 4),
    (18, 'Creatina Monohidratada 300g',     'Creatina pura micronizada, sin sabor. Aumenta fuerza y potencia.',       450.00, 'p6a74b458319c30.72242533.jpg', 59, 'ACT', 5),
    (19, 'Creatina Monohidratada 1000g',    'Formato más grande. Creatina de grado farmacéutico.',                   1050.00, 'p6a74b4796936d4.28944689.jpg', 45, 'ACT', 5),
    (20, 'BCAA 2:1:1 Powder 300g',          'Leucina, Isoleucina y Valina en proporción óptima. Sabor limón.',        700.00, 'p6a74b41fcddd06.07885670.jpg', 40, 'ACT', 6),
    (21, 'L-Glutamina 300g',                'Recuperación muscular y sistema inmune. Sin sabor.',                     550.00, 'p6a74b3fe629602.77012080.jpg', 30, 'ACT', 6),
    (22, 'Multivitamínico Atleta 60 tabs',  'Fórmula completa con vitaminas A, C, D, E, zinc y magnesio.',            380.00, 'p6a74b609c55a17.98844933.jpg', 55, 'ACT', 7),
    (23, 'Omega 3 Fish Oil 90 caps',        'EPA y DHA de alta concentración. Antiinflamatorio natural.',             420.00, 'p6a74b58f312327.95196840.jpg', 40, 'ACT', 7),
    (24, 'Quemador Lipo-6 Black 60 caps',   'Termogénico de acción rápida para definición muscular.',                 780.00, 'p6a74b5b1e52769.07674842.jpg', 20, 'ACT', 4),
    (25, 'Caseína Micelar Chocolate 4lb',   'Proteína de digestión lenta, ideal para tomar en la noche.',            1300.00, 'p6a74b4fa9a9892.88572906.jpg', 18, 'ACT', 2);

UPDATE `products` SET
    `productName` = 'Creatina Monohidratada 1000g',
    `productDescription` = 'Formato más grande. Creatina de grado farmacéutico.',
    `productPrice` = 1050.00,
    `productImgUrl` = 'p6a74b4796936d4.28944689.jpg'
WHERE `productId` = 19;

UPDATE `products` SET `productImgUrl` = 'p6a74b50ad226e4.44276846.png' WHERE `productId` = 11 AND `productImgUrl` <> 'p6a74b50ad226e4.44276846.png';
UPDATE `products` SET `productImgUrl` = 'p6a74b6a530ff72.47822017.jpg' WHERE `productId` = 12 AND `productImgUrl` <> 'p6a74b6a530ff72.47822017.jpg';
UPDATE `products` SET `productImgUrl` = 'p6a74b67d414e39.57298466.png' WHERE `productId` = 13 AND `productImgUrl` <> 'p6a74b67d414e39.57298466.png';
UPDATE `products` SET `productImgUrl` = 'p6a74b6471196c0.19504878.png' WHERE `productId` = 14 AND `productImgUrl` <> 'p6a74b6471196c0.19504878.png';
UPDATE `products` SET `productImgUrl` = 'p6a74b63d168f12.53209269.jpg' WHERE `productId` = 15 AND `productImgUrl` <> 'p6a74b63d168f12.53209269.jpg';
UPDATE `products` SET `productImgUrl` = 'p6a74b4bd5f3b56.26044628.jpg' WHERE `productId` = 16 AND `productImgUrl` <> 'p6a74b4bd5f3b56.26044628.jpg';
UPDATE `products` SET `productImgUrl` = 'p6a74b49aae3fb8.36926915.jpg' WHERE `productId` = 17 AND `productImgUrl` <> 'p6a74b49aae3fb8.36926915.jpg';
UPDATE `products` SET `productImgUrl` = 'p6a74b458319c30.72242533.jpg' WHERE `productId` = 18 AND `productImgUrl` <> 'p6a74b458319c30.72242533.jpg';
UPDATE `products` SET `productImgUrl` = 'p6a74b41fcddd06.07885670.jpg' WHERE `productId` = 20 AND `productImgUrl` <> 'p6a74b41fcddd06.07885670.jpg';
UPDATE `products` SET `productImgUrl` = 'p6a74b3fe629602.77012080.jpg' WHERE `productId` = 21 AND `productImgUrl` <> 'p6a74b3fe629602.77012080.jpg';
UPDATE `products` SET `productImgUrl` = 'p6a74b609c55a17.98844933.jpg' WHERE `productId` = 22 AND `productImgUrl` <> 'p6a74b609c55a17.98844933.jpg';
UPDATE `products` SET `productImgUrl` = 'p6a74b58f312327.95196840.jpg' WHERE `productId` = 23 AND `productImgUrl` <> 'p6a74b58f312327.95196840.jpg';
UPDATE `products` SET `productImgUrl` = 'p6a74b5b1e52769.07674842.jpg' WHERE `productId` = 24 AND `productImgUrl` <> 'p6a74b5b1e52769.07674842.jpg';
UPDATE `products` SET `productImgUrl` = 'p6a74b4fa9a9892.88572906.jpg' WHERE `productId` = 25 AND `productImgUrl` <> 'p6a74b4fa9a9892.88572906.jpg';

-- destacados
INSERT IGNORE INTO `highlights` (`highlightId`, `productId`, `highlightStart`, `highlightEnd`) VALUES
    (3,  11, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),
    (4,  12, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),
    (5,  13, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),
    (6,  14, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),
    (10, 19, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY)),
    (11, 23, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY));

-- ofertas
INSERT IGNORE INTO `sales` (`saleId`, `productId`, `salePrice`, `saleStart`, `saleEnd`) VALUES
    (4,  15, 760.00, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY)),
    (5,  16, 680.00, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY)),
    (6,  17, 720.00, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY)),
    (7,  18, 360.00, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY)),
    (8,  19, 520.00, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY)),
    (9,  20, 560.00, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY)),
    (10, 21, 440.00, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY)),
    (11, 22, 304.00, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY));

INSERT IGNORE INTO `funciones` (`fncod`, `fndsc`, `fnest`, `fntyp`) VALUES
    ('Menu_2FA',                             'Menu_2FA',                 'ACT', 'MNU'),
    ('Menu_AdminProductos',                  'Menu_AdminProductos',      'ACT', 'MNU'),
    ('Menu_Cart',                            'Menu_Cart',                'ACT', 'MNU'),
    ('Menu_Catalogo',                        'Menu_Catalogo',            'ACT', 'MNU'),
    ('Menu_Dashboard',                       'Dashboard Admin',          'ACT', 'MNU'),
    ('Menu_Historial',                       'Menu_Historial',           'ACT', 'MNU'),
    ('Controllers\\Checkout\\Accept',        'Pago aceptado',            'ACT', 'CTR'),
    ('Controllers\\Checkout\\Cart',          'Carrito',                  'ACT', 'CTR'),
    ('Controllers\\Checkout\\Checkout',      'Checkout',                 'ACT', 'CTR'),
    ('Controllers\\Checkout\\Error',         'Pago error',               'ACT', 'CTR'),
    ('Controllers\\Dashboard\\Dashboard',    'Dashboard',                'ACT', 'CTR'),
    ('Controllers\\History\\Admin',          'Admin transacciones',      'ACT', 'CTR'),
    ('Controllers\\History\\Detail',         'Detalle orden',            'ACT', 'CTR'),
    ('Controllers\\History\\Export',         'Exportar historial',       'ACT', 'CTR'),
    ('Controllers\\History\\History',        'Mi historial',             'ACT', 'CTR'),
    ('Controllers\\Products\\Admin',         'Admin lista productos',    'ACT', 'CTR'),
    ('Controllers\\Products\\Autocomplete',  'Autocomplete',             'ACT', 'CTR'),
    ('Controllers\\Products\\Create',        'Crear producto',           'ACT', 'CTR'),
    ('Controllers\\Products\\Edit',          'Editar producto',          'ACT', 'CTR'),
    ('Controllers\\Products\\Toggle',        'Activar/desactivar',       'ACT', 'CTR'),
    ('Controllers\\Reviews\\Review',         'Publicar reseña',          'ACT', 'CTR'),
    ('Controllers\\Sec\\TwoFactorSetup',     'Setup 2FA',                'ACT', 'CTR'),
    ('Controllers\\Sec\\TwoFactorVerify',    'Verificar 2FA',            'ACT', 'CTR');

-- Permisos: Administrador (todo)
INSERT IGNORE INTO `funciones_roles` (`rolescod`, `fncod`, `fnrolest`) VALUES
    ('ADM', 'Menu_2FA',                            'ACT'),
    ('ADM', 'Menu_AdminProductos',                 'ACT'),
    ('ADM', 'Menu_Cart',                           'ACT'),
    ('ADM', 'Menu_Catalogo',                       'ACT'),
    ('ADM', 'Menu_Dashboard',                      'ACT'),
    ('ADM', 'Menu_Historial',                      'ACT'),
    ('ADM', 'Controllers\\Checkout\\Accept',       'ACT'),
    ('ADM', 'Controllers\\Checkout\\Cart',         'ACT'),
    ('ADM', 'Controllers\\Checkout\\Checkout',     'ACT'),
    ('ADM', 'Controllers\\Checkout\\Error',        'ACT'),
    ('ADM', 'Controllers\\Dashboard\\Dashboard',   'ACT'),
    ('ADM', 'Controllers\\History\\Admin',         'ACT'),
    ('ADM', 'Controllers\\History\\Detail',        'ACT'),
    ('ADM', 'Controllers\\History\\Export',        'ACT'),
    ('ADM', 'Controllers\\History\\History',       'ACT'),
    ('ADM', 'Controllers\\Products\\Admin',        'ACT'),
    ('ADM', 'Controllers\\Products\\Autocomplete', 'ACT'),
    ('ADM', 'Controllers\\Products\\Create',       'ACT'),
    ('ADM', 'Controllers\\Products\\Edit',         'ACT'),
    ('ADM', 'Controllers\\Products\\Toggle',       'ACT'),
    ('ADM', 'Controllers\\Reviews\\Review',        'ACT'),
    ('ADM', 'Controllers\\Sec\\TwoFactorSetup',    'ACT'),
    ('ADM', 'Controllers\\Sec\\TwoFactorVerify',   'ACT');

-- Permisos: Cliente (tienda + su propio historial + 2FA opcional)
INSERT IGNORE INTO `funciones_roles` (`rolescod`, `fncod`, `fnrolest`) VALUES
    ('CLI', 'Menu_2FA',                            'ACT'),
    ('CLI', 'Menu_Cart',                           'ACT'),
    ('CLI', 'Menu_Catalogo',                       'ACT'),
    ('CLI', 'Menu_Historial',                      'ACT'),
    ('CLI', 'Controllers\\Checkout\\Accept',       'ACT'),
    ('CLI', 'Controllers\\Checkout\\Cart',         'ACT'),
    ('CLI', 'Controllers\\Checkout\\Checkout',     'ACT'),
    ('CLI', 'Controllers\\Checkout\\Error',        'ACT'),
    ('CLI', 'Controllers\\History\\Detail',        'ACT'),
    ('CLI', 'Controllers\\History\\Export',        'ACT'),
    ('CLI', 'Controllers\\History\\History',       'ACT'),
    ('CLI', 'Controllers\\Reviews\\Review',        'ACT'),
    ('CLI', 'Controllers\\Sec\\TwoFactorSetup',    'ACT'),
    ('CLI', 'Controllers\\Sec\\TwoFactorVerify',   'ACT');

SET FOREIGN_KEY_CHECKS = 1;

-- =============================================================
-- USUARIO ADMINISTRADOR INICIAL (paso manual — no lleva contraseñas
-- reales en este script para no exponer hashes en el repo)
--
-- 1. Generar el hash:
--      php sql/seed_admin.php
-- 2. Copiar el INSERT que imprime y correrlo en la base de datos.
--    Login de prueba documentado en README: admin@bodyperfect.com
-- =============================================================
