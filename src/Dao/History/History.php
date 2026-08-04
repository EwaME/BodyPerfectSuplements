<?php

namespace Dao\History;

use Dao\Table;

class History extends Table
{
    /**
     * Obtiene el listado de pedidos de un usuario con paginación y filtro por estado.
     */
    public static function getTransaccionesPorUsuario($usercod, $page = 1, $perPage = 10, $estado = null)
    {
        $offset = ($page - 1) * $perPage;
        $params = array("usercod" => $usercod);
        
        $whereState = "";
        if ($estado !== null && $estado !== "" && $estado !== "ALL") {
            $whereState = " AND p.estado = :estado";
            $params["estado"] = $estado;
        }

        $sql = "SELECT p.id, p.usercod, p.total, p.estado, p.fecha,
                       t.metodoPago, t.referenciaPasarela,
                       (SELECT COUNT(*) FROM pedido_detalle pd WHERE pd.pedidoId = p.id) AS totalItems
                FROM pedidos p
                LEFT JOIN transacciones t ON t.pedidoId = p.id
                WHERE p.usercod = :usercod {$whereState}
                ORDER BY p.fecha DESC, p.id DESC
                LIMIT {$offset}, {$perPage};";

        return self::obtenerRegistros($sql, $params);
    }

    /**
     * Cuenta el total de pedidos de un usuario para calcular totalPages.
     */
    public static function countTransaccionesPorUsuario($usercod, $estado = null)
    {
        $params = array("usercod" => $usercod);
        $whereState = "";
        if ($estado !== null && $estado !== "" && $estado !== "ALL") {
            $whereState = " AND estado = :estado";
            $params["estado"] = $estado;
        }

        $sql = "SELECT COUNT(*) AS total FROM pedidos WHERE usercod = :usercod {$whereState};";
        $row = self::obtenerUnRegistro($sql, $params);
        return intval($row["total"] ?? 0);
    }

    /**
     * Obtiene los datos generales de un pedido asegurándose de que pertenezca al usuario.
     */
    public static function getPedidoUsuario($pedidoId, $usercod)
    {
        $sql = "SELECT p.id, p.usercod, p.total, p.estado, p.fecha,
                       t.metodoPago, t.referenciaPasarela, t.fecha AS fechaTrx
                FROM pedidos p
                LEFT JOIN transacciones t ON t.pedidoId = p.id
                WHERE p.id = :pedidoId AND p.usercod = :usercod;";
        
        return self::obtenerUnRegistro($sql, array("pedidoId" => $pedidoId, "usercod" => $usercod));
    }

    /**
     * Obtiene el desglose de productos de un pedido del usuario.
     */
    public static function getDetallePedidoUsuario($pedidoId, $usercod)
    {
        $sql = "SELECT pd.id, pd.pedidoId, pd.productId, pd.cantidad, pd.precioUnitario,
                       (pd.cantidad * pd.precioUnitario) AS subtotal,
                       p.productName, p.productImgUrl
                FROM pedido_detalle pd
                INNER JOIN pedidos ped ON ped.id = pd.pedidoId
                INNER JOIN products p ON p.productId = pd.productId
                WHERE pd.pedidoId = :pedidoId AND ped.usercod = :usercod
                ORDER BY pd.id ASC;";

        return self::obtenerRegistros($sql, array("pedidoId" => $pedidoId, "usercod" => $usercod));
    }

    /**
     * Vista Administrativa: Obtiene todas las transacciones del sistema con filtros de búsqueda, estado y rango de fechas.
     */
    public static function getAllTransaccionesAdmin($search = '', $estado = '', $fechaInicio = '', $fechaFin = '', $page = 1, $perPage = 10)
    {
        $offset = ($page - 1) * $perPage;
        $params = array();
        $conditions = array("1 = 1");

        if ($search !== '') {
            $conditions[] = "(u.useremail LIKE :search OR u.username LIKE :search OR CAST(p.id AS CHAR) LIKE :search OR t.referenciaPasarela LIKE :search)";
            $params["search"] = '%' . $search . '%';
        }

        if ($estado !== '' && $estado !== 'ALL') {
            $conditions[] = "p.estado = :estado";
            $params["estado"] = $estado;
        }

        if ($fechaInicio !== '') {
            $conditions[] = "DATE(p.fecha) >= :fechaInicio";
            $params["fechaInicio"] = $fechaInicio;
        }

        if ($fechaFin !== '') {
            $conditions[] = "DATE(p.fecha) <= :fechaFin";
            $params["fechaFin"] = $fechaFin;
        }

        $whereClause = implode(" AND ", $conditions);

        $sql = "SELECT p.id, p.usercod, p.total, p.estado, p.fecha,
                       u.useremail, u.username,
                       t.metodoPago, t.referenciaPasarela,
                       (SELECT COUNT(*) FROM pedido_detalle pd WHERE pd.pedidoId = p.id) AS totalItems
                FROM pedidos p
                INNER JOIN usuario u ON u.usercod = p.usercod
                LEFT JOIN transacciones t ON t.pedidoId = p.id
                WHERE {$whereClause}
                ORDER BY p.fecha DESC, p.id DESC
                LIMIT {$offset}, {$perPage};";

        return self::obtenerRegistros($sql, $params);
    }

    /**
     * Conteo total de transacciones para paginación administrativa.
     */
    public static function countAllTransaccionesAdmin($search = '', $estado = '', $fechaInicio = '', $fechaFin = '')
    {
        $params = array();
        $conditions = array("1 = 1");

        if ($search !== '') {
            $conditions[] = "(u.useremail LIKE :search OR u.username LIKE :search OR CAST(p.id AS CHAR) LIKE :search OR t.referenciaPasarela LIKE :search)";
            $params["search"] = '%' . $search . '%';
        }

        if ($estado !== '' && $estado !== 'ALL') {
            $conditions[] = "p.estado = :estado";
            $params["estado"] = $estado;
        }

        if ($fechaInicio !== '') {
            $conditions[] = "DATE(p.fecha) >= :fechaInicio";
            $params["fechaInicio"] = $fechaInicio;
        }

        if ($fechaFin !== '') {
            $conditions[] = "DATE(p.fecha) <= :fechaFin";
            $params["fechaFin"] = $fechaFin;
        }

        $whereClause = implode(" AND ", $conditions);

        $sql = "SELECT COUNT(*) AS total
                FROM pedidos p
                INNER JOIN usuario u ON u.usercod = p.usercod
                LEFT JOIN transacciones t ON t.pedidoId = p.id
                WHERE {$whereClause};";

        $row = self::obtenerUnRegistro($sql, $params);
        return intval($row["total"] ?? 0);
    }

    /**
     * Obtiene pedido para vista admin sin restringir por usercod.
     */
    public static function getPedidoAdmin($pedidoId)
    {
        $sql = "SELECT p.id, p.usercod, p.total, p.estado, p.fecha,
                       u.useremail, u.username,
                       t.metodoPago, t.referenciaPasarela, t.fecha AS fechaTrx
                FROM pedidos p
                INNER JOIN usuario u ON u.usercod = p.usercod
                LEFT JOIN transacciones t ON t.pedidoId = p.id
                WHERE p.id = :pedidoId;";

        return self::obtenerUnRegistro($sql, array("pedidoId" => $pedidoId));
    }

    /**
     * Obtiene detalle para vista admin sin restringir por usercod.
     */
    public static function getDetallePedidoAdmin($pedidoId)
    {
        $sql = "SELECT pd.id, pd.pedidoId, pd.productId, pd.cantidad, pd.precioUnitario,
                       (pd.cantidad * pd.precioUnitario) AS subtotal,
                       p.productName, p.productImgUrl
                FROM pedido_detalle pd
                INNER JOIN products p ON p.productId = pd.productId
                WHERE pd.pedidoId = :pedidoId
                ORDER BY pd.id ASC;";

        return self::obtenerRegistros($sql, array("pedidoId" => $pedidoId));
    }
}
