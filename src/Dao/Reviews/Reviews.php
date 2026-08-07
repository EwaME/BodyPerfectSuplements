<?php
namespace Dao\Reviews;

class Reviews extends \Dao\Table
{
    public static function getByProduct($productId)
    {
        $sql = "SELECT r.id, r.calificacion, r.comentario, r.created_at, u.username
                FROM reviews r
                INNER JOIN usuario u ON u.usercod = r.usercod
                WHERE r.productId = :productId
                ORDER BY r.created_at DESC;";
        return self::obtenerRegistros($sql, ['productId' => $productId]);
    }

    public static function getPromedio($productId)
    {
        $sql = "SELECT COUNT(*) as total, COALESCE(AVG(calificacion), 0) as promedio
                FROM reviews WHERE productId = :productId;";
        return self::obtenerUnRegistro($sql, ['productId' => $productId]);
    }

    public static function yaRevisado($productId, $usercod)
    {
        $sql = "SELECT id FROM reviews WHERE productId = :productId AND usercod = :usercod LIMIT 1;";
        $fila = self::obtenerUnRegistro($sql, ['productId' => $productId, 'usercod' => $usercod]);
        return $fila !== false && $fila !== null;
    }

    public static function yaCompro($productId, $usercod)
    {
        $sql = "SELECT pd.id FROM pedido_detalle pd
                INNER JOIN pedidos p ON p.id = pd.pedidoId AND p.estado = 'APR'
                WHERE pd.productId = :productId AND p.usercod = :usercod
                LIMIT 1;";
        $fila = self::obtenerUnRegistro($sql, ['productId' => $productId, 'usercod' => $usercod]);
        return $fila !== false && $fila !== null;
    }

    public static function insertar($productId, $usercod, $calificacion, $comentario)
    {
        $sql = "INSERT INTO reviews (productId, usercod, calificacion, comentario)
                VALUES (:productId, :usercod, :calificacion, :comentario);";
        return self::executeNonQuery($sql, [
            'productId' => $productId,
            'usercod' => $usercod,
            'calificacion' => $calificacion,
            'comentario' => $comentario,
        ]);
    }

    private function __construct() {}
    private function __clone() {}
}
