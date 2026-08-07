

CREATE TABLE
    `pedidos` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `usercod` bigint(10) NOT NULL,
        `total` decimal(12, 2) NOT NULL,
        `estado` char(3) NOT NULL DEFAULT 'PND' COMMENT 'PND=Pendiente, APR=Aprobado, RCH=Rechazado, CAN=Cancelado',
        `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        KEY `pedidos_user_idx` (`usercod`),
        KEY `pedidos_estado_idx` (`estado`),
        CONSTRAINT `pedidos_user_key` FOREIGN KEY (`usercod`)
            REFERENCES `usuario` (`usercod`)
            ON DELETE RESTRICT ON UPDATE CASCADE
    ) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8mb4;

CREATE TABLE
    `pedido_detalle` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `pedidoId` int(11) NOT NULL,
        `productId` int(11) NOT NULL,
        `cantidad` int(11) NOT NULL,
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

CREATE TABLE
    `transacciones` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `pedidoId` int(11) NOT NULL,
        `metodoPago` varchar(20) NOT NULL DEFAULT 'PAYPAL',
        `referenciaPasarela` varchar(255) DEFAULT NULL COMMENT 'Order ID de PayPal',
        `estado` char(3) NOT NULL DEFAULT 'PND' COMMENT 'PND=Pendiente, APR=Aprobado, RCH=Rechazado, CAN=Cancelado',
        `monto` decimal(12, 2) NOT NULL,
        `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (`id`),
        KEY `transacciones_pedido_idx` (`pedidoId`),
        KEY `transacciones_ref_idx` (`referenciaPasarela`),
        CONSTRAINT `transacciones_pedido_key` FOREIGN KEY (`pedidoId`)
            REFERENCES `pedidos` (`id`)
            ON DELETE CASCADE ON UPDATE CASCADE
    ) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8mb4;
