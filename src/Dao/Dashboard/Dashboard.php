<?php
namespace Dao\Dashboard;

class Dashboard extends \Dao\Table
{
    public static function getResumenGeneral()
    {
        $sql = "SELECT
                    (SELECT COUNT(*) FROM pedidos WHERE estado = 'APR') AS totalPedidos,
                    (SELECT COALESCE(SUM(total), 0) FROM pedidos WHERE estado = 'APR') AS totalIngresos,
                    (SELECT COUNT(*) FROM usuario) AS totalClientes,
                    (SELECT COUNT(*) FROM products WHERE productStatus = 'ACT') AS totalProductos";
        return self::obtenerUnRegistro($sql, []);
    }

    public static function getVentasPorDia($dias = 7)
    {
        $dias = (int)$dias;
        $sql = "SELECT
                    DATE(fecha) AS dia,
                    COUNT(*) AS pedidos,
                    COALESCE(SUM(total), 0) AS ingresos
                FROM pedidos
                WHERE estado = 'APR'
                    AND fecha >= DATE_SUB(CURDATE(), INTERVAL {$dias} DAY)
                GROUP BY DATE(fecha)
                ORDER BY dia ASC;";
        return self::obtenerRegistros($sql, []);
    }

    public static function getProductosMasVendidos($limite = 5)
    {
        $limite = (int)$limite;
        $sql = "SELECT
                    p.productName,
                    SUM(pd.cantidad) AS totalVendido,
                    SUM(pd.cantidad * pd.precioUnitario) AS ingresos
                FROM pedido_detalle pd
                INNER JOIN products p ON p.productId = pd.productId
                INNER JOIN pedidos pe ON pe.id = pd.pedidoId AND pe.estado = 'APR'
                GROUP BY pd.productId, p.productName
                ORDER BY totalVendido DESC
                LIMIT {$limite};";
        return self::obtenerRegistros($sql, []);
    }

    public static function getStockBajo($umbral = 10)
    {
        $umbral = (int)$umbral;
        $sql = "SELECT productId, productName, productStock, categoryId
                FROM products
                WHERE productStatus IN ('ACT', 'AGO') AND productStock <= :umbral
                ORDER BY productStock ASC;";
        return self::obtenerRegistros($sql, ['umbral' => $umbral]);
    }

    private function __construct() {}
    private function __clone() {}
}
