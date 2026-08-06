<?php

namespace Controllers\Checkout;

use Controllers\PublicController;

class Checkout extends PublicController
{
    public function run(): void
    {
        if (!\Utilities\Security::isLogged()) {
            \Utilities\Site::redirectTo("index.php?page=Sec_Login");
        }

        $usercod = \Utilities\Security::getUserId();
        $carrito = \Dao\Cart\Cart::getCarrito($usercod, null);

        if (empty($carrito["items"])) {
            \Utilities\Site::redirectToWithMsg("index.php?page=Checkout_Cart", "Tu carrito está vacío.");
        }

        if ($this->isPostBack()) {
            $problemas = \Dao\Cart\Cart::validarCarrito($usercod, null);
            if (!empty($problemas)) {
                $mensajes = array_column($problemas, "mensaje");
                \Utilities\Site::redirectToWithMsg("index.php?page=Checkout_Cart", implode(" ", $mensajes));
            }

            $lineas = array();
            $total = 0;
            foreach ($carrito["items"] as $item) {
                $precioUnitario = (float) str_replace(",", "", $item["crrprc"]);
                $cantidad = $item["crrctd"];
                $lineas[] = array(
                    "productId" => $item["productId"],
                    "productName" => $item["productName"],
                    "cantidad" => $cantidad,
                    "precioUnitario" => $precioUnitario,
                );
                $total += round($precioUnitario * $cantidad, 2);
            }

            $pedidoId = \Dao\Checkout\Pedidos::crearPedido($usercod, $total);
            foreach ($lineas as $linea) {
                \Dao\Checkout\Pedidos::agregarDetalle(
                    $pedidoId,
                    $linea["productId"],
                    $linea["cantidad"],
                    $linea["precioUnitario"]
                );
            }
            $_SESSION["pedidoId"] = $pedidoId;

            $scheme = (!empty($_SERVER["HTTPS"]) && $_SERVER["HTTPS"] !== "off") ? "https" : "http";
            $baseUrl = $scheme . "://" . $_SERVER["HTTP_HOST"] . \Utilities\Context::getContextByKey("BASE_DIR");

            $PayPalOrder = new \Utilities\Paypal\PayPalOrder(
                (string) $pedidoId,
                $baseUrl . "/index.php?page=Checkout_Error",
                $baseUrl . "/index.php?page=Checkout_Accept"
            );

            foreach ($lineas as $linea) {
                $precioUsd = \Utilities\PayPal\PayPalFns::lempirasToUsd($linea["precioUnitario"]);
                $PayPalOrder->addItem(
                    $linea["productName"],
                    $linea["productName"],
                    "PRD" . $linea["productId"],
                    $precioUsd,
                    0,
                    $linea["cantidad"],
                    "PHYSICAL_GOODS"
                );
            }

            $environment = \Utilities\Context::getContextByKey("PAYPAL_CLIENT_ENV") === "PRD" ? "live" : "sandbox";
            $PayPalRestApi = new \Utilities\PayPal\PayPalRestApi(
                \Utilities\Context::getContextByKey("PAYPAL_CLIENT_ID"),
                \Utilities\Context::getContextByKey("PAYPAL_CLIENT_SECRET"),
                $environment
            );
            try {
                $PayPalRestApi->getAccessToken();
                $response = $PayPalRestApi->createOrder($PayPalOrder);
            } catch (\RuntimeException $e) {
                \Dao\Checkout\Pedidos::actualizarEstado($pedidoId, 'CAN');
                unset($_SESSION["pedidoId"]);
                \Utilities\Site::redirectToWithMsg(
                    "index.php?page=Checkout_Cart",
                    "No se pudo conectar con PayPal. Verifica las credenciales en parameters.env."
                );
            }

            $_SESSION["orderid"] = $response->id;
            \Dao\Checkout\Pedidos::crearTransaccion($pedidoId, $response->id, $total);

            foreach ($response->links as $link) {
                if ($link->rel == "approve") {
                    \Utilities\Site::redirectTo($link->href);
                }
            }
            die();
        }

        \Views\Renderer::render("paypal/checkout", $carrito);
    }
}
