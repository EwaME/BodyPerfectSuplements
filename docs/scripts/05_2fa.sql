

CREATE TABLE
    `two_factor_secrets` (
        `id` int(11) NOT NULL AUTO_INCREMENT,
        `usercod` bigint(10) NOT NULL,
        `secret` varchar(32) NOT NULL,
        `activado` tinyint(1) NOT NULL DEFAULT 0,
        PRIMARY KEY (`id`),
        UNIQUE KEY `two_factor_user_unique` (`usercod`),
        CONSTRAINT `two_factor_user_key` FOREIGN KEY (`usercod`)
            REFERENCES `usuario` (`usercod`)
            ON DELETE CASCADE ON UPDATE CASCADE
    ) ENGINE = InnoDB AUTO_INCREMENT = 1 DEFAULT CHARSET = utf8mb4;
