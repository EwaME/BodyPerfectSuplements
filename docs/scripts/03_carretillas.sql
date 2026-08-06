-- Módulo C: Carrito de compras (patrón TTL — sin campo de estado)
-- Depende de: products (02_catalogo.sql), usuario (01_security.sql)

CREATE TABLE
    `carretilla` (
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

CREATE TABLE
    `carretillaanon` (
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
