-- Módulo B: Catálogo de Productos
-- categories debe crearse antes de products (FK)

CREATE TABLE
    `categories` (
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

-- Reemplaza la definición en 02_carretillas.sql (que no tiene categoryId).
-- Si ya ejecutaste 02_carretillas.sql, usa el ALTER al final de este archivo.
CREATE TABLE
    `products` (
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

-- Si products ya existe sin categoryId, ejecutar esto en su lugar:
-- ALTER TABLE `products`
--     ADD COLUMN `categoryId` int(11) DEFAULT NULL AFTER `productStatus`,
--     ADD KEY `categoryId_idx` (`categoryId`),
--     ADD CONSTRAINT `product_category_key`
--         FOREIGN KEY (`categoryId`) REFERENCES `categories` (`categoryId`)
--         ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE
    `sales` (
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

CREATE TABLE
    `highlights` (
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

CREATE TABLE
    `reviews` (
        `id`           int(11)       NOT NULL AUTO_INCREMENT,
        `productId`    int(11)       NOT NULL,
        `usercod`      bigint(10)    NOT NULL,
        `calificacion` tinyint(1)    NOT NULL COMMENT '1-5 estrellas',
        `comentario`   text          DEFAULT NULL,
        `created_at`   datetime      NOT NULL DEFAULT CURRENT_TIMESTAMP,
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
