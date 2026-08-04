<?php
namespace Dao\Checkout;

class Pedidos extends \Dao\Table
{
    public static function crearPedido($usercod, $total)
    {
        self::executeNonQuery(
            "insert into pedidos (usercod, total, estado) values (:usercod, :total, :estado);",
            array("usercod" => $usercod, "total" => $total, "estado" => PedidoEstados::PENDIENTE)
        );
        return (int) self::getConn()->lastInsertId();
    }

    public static function agregarDetalle($pedidoId, $productId, $cantidad, $precioUnitario)
    {
        self::executeNonQuery(
            "insert into pedido_detalle (pedidoId, productId, cantidad, precioUnitario)
             values (:pedidoId, :productId, :cantidad, :precioUnitario);",
            array("pedidoId" => $pedidoId, "productId" => $productId, "cantidad" => $cantidad, "precioUnitario" => $precioUnitario)
        );
    }

    public static function crearTransaccion($pedidoId, $referenciaPasarela, $monto)
    {
        self::executeNonQuery(
            "insert into transacciones (pedidoId, metodoPago, referenciaPasarela, estado, monto)
             values (:pedidoId, 'PAYPAL', :ref, :estado, :monto);",
            array(
                "pedidoId" => $pedidoId,
                "ref" => $referenciaPasarela,
                "estado" => PedidoEstados::PENDIENTE,
                "monto" => $monto,
            )
        );
    }

    public static function actualizarEstado($pedidoId, $estado)
    {
        self::executeNonQuery(
            "update pedidos set estado = :estado where id = :id;",
            array("estado" => $estado, "id" => $pedidoId)
        );
        self::executeNonQuery(
            "update transacciones set estado = :estado where pedidoId = :id;",
            array("estado" => $estado, "id" => $pedidoId)
        );
    }

    public static function getPedido($pedidoId)
    {
        return self::obtenerUnRegistro("select * from pedidos where id = :id;", array("id" => $pedidoId));
    }

    public static function getDetalle($pedidoId)
    {
        $sql = "select pd.productId, pd.cantidad, pd.precioUnitario, p.productName
                from pedido_detalle pd
                inner join products p on p.productId = pd.productId
                where pd.pedidoId = :id;";
        return self::obtenerRegistros($sql, array("id" => $pedidoId));
    }
}
