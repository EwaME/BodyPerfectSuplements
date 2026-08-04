<?php

namespace Controllers\Checkout;

use Controllers\PublicController;

class Error extends PublicController
{
    public function run(): void
    {
        $pedidoId = $_SESSION["pedidoId"] ?: 0;
        if ($pedidoId) {
            $pedido = \Dao\Checkout\Pedidos::getPedido($pedidoId);
            if ($pedido && $pedido["estado"] == \Dao\Checkout\PedidoEstados::PENDIENTE) {
                \Dao\Checkout\Pedidos::actualizarEstado($pedidoId, \Dao\Checkout\PedidoEstados::CANCELADO);
            }
        }
        \Views\Renderer::render("paypal/error", array());
    }
}
