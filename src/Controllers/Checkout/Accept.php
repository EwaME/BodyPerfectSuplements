<?php

namespace Controllers\Checkout;

use Controllers\PublicController;

class Accept extends PublicController
{
    public function run(): void
    {
        $dataview = array("pedido" => false, "detalle" => array());

        $token = $_GET["token"] ?? "";
        $session_token = $_SESSION["orderid"] ?? "";
        $pedidoId = $_SESSION["pedidoId"] ?? 0;

        if ($token !== "" && $token == $session_token && $pedidoId) {
            $pedido = \Dao\Checkout\Pedidos::getPedido($pedidoId);

            if ($pedido && $pedido["estado"] == \Dao\Checkout\PedidoEstados::PENDIENTE) {
                $environment = \Utilities\Context::getContextByKey("PAYPAL_CLIENT_ENV") === "PRD" ? "live" : "sandbox";
                $PayPalRestApi = new \Utilities\PayPal\PayPalRestApi(
                    \Utilities\Context::getContextByKey("PAYPAL_CLIENT_ID"),
                    \Utilities\Context::getContextByKey("PAYPAL_CLIENT_SECRET"),
                    $environment
                );
                $result = $PayPalRestApi->captureOrder($session_token);

                if ($result->status == "COMPLETED") {
                    \Dao\Checkout\Pedidos::actualizarEstado($pedidoId, \Dao\Checkout\PedidoEstados::APROBADO);

                    $detalleVendido = \Dao\Checkout\Pedidos::getDetalle($pedidoId);
                    foreach ($detalleVendido as $linea) {
                        \Dao\Products\Products::descontarStock($linea["productId"], $linea["cantidad"]);
                    }

                    $usercod = \Utilities\Security::getUserId();
                    $carritoActual = \Dao\Cart\Cart::getCarrito($usercod, null);
                    foreach ($carritoActual["items"] as $item) {
                        \Dao\Cart\Cart::removeItem($usercod, null, $item["productId"]);
                    }
                } else {
                    \Dao\Checkout\Pedidos::actualizarEstado($pedidoId, \Dao\Checkout\PedidoEstados::RECHAZADO);
                }

                $pedido = \Dao\Checkout\Pedidos::getPedido($pedidoId);
            }

            $dataview["pedido"] = $pedido;
            $dataview["detalle"] = \Dao\Checkout\Pedidos::getDetalle($pedidoId);
        }

        \Views\Renderer::render("paypal/accept", $dataview);
    }
}
