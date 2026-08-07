<?php

namespace Controllers\Checkout;

use Controllers\PublicController;

class Cart extends PublicController
{
    public function run(): void
    {
        $usercod = \Utilities\Security::isLogged() ? \Utilities\Security::getUserId() : 0;
        $anoncod = $usercod > 0 ? null : \Utilities\Cart\CartFns::getAnonId();

        $action = $_GET["action"] ?? "";
        $productId = isset($_GET["id"]) ? (int)$_GET["id"] : 0;

        if ($action === "checkout") {
            $carritoActual = \Dao\Cart\Cart::getCarrito($usercod, $anoncod);
            if (empty($carritoActual["items"])) {
                \Utilities\Site::redirectToWithMsg("index.php?page=Checkout_Cart", "Tu carrito está vacío.");
            }
            $problemas = \Dao\Cart\Cart::validarCarrito($usercod, $anoncod);
            if (!empty($problemas)) {
                $mensajes = array_column($problemas, "mensaje");
                \Utilities\Site::redirectToWithMsg("index.php?page=Checkout_Cart", implode(" ", $mensajes));
            }
            \Utilities\Site::redirectTo("index.php?page=Checkout_Checkout");
        }

        if ($action === "add" && $productId) {
            $cantidad = isset($_GET["qty"]) ? (int)$_GET["qty"] : 1;
            $resultado = \Dao\Cart\Cart::addItem($usercod, $anoncod, $productId, $cantidad);
            if (!$resultado["ok"]) {
                \Utilities\Site::redirectToWithMsg("index.php?page=Products_Products", $resultado["error"]);
            }
            $this->unsave($productId);
            \Utilities\Site::redirectTo("index.php?page=Checkout_Cart");
        }

        if ($action === "update" && $productId && $this->isPostBack()) {
            $cantidad = isset($_POST["cantidad"]) ? (int)$_POST["cantidad"] : 1;
            $resultado = \Dao\Cart\Cart::updateCantidad($usercod, $anoncod, $productId, $cantidad);
            if (!$resultado["ok"]) {
                \Utilities\Site::redirectToWithMsg("index.php?page=Checkout_Cart", $resultado["error"]);
            }
            \Utilities\Site::redirectTo("index.php?page=Checkout_Cart");
        }

        if ($action === "remove" && $productId) {
            \Dao\Cart\Cart::removeItem($usercod, $anoncod, $productId);
            \Utilities\Site::redirectTo("index.php?page=Checkout_Cart");
        }

        if ($action === "save" && $productId) {
            \Dao\Cart\Cart::removeItem($usercod, $anoncod, $productId);
            $this->save($productId);
            \Utilities\Site::redirectTo("index.php?page=Checkout_Cart");
        }

        if ($action === "discard" && $productId) {
            $this->unsave($productId);
            \Utilities\Site::redirectTo("index.php?page=Checkout_Cart");
        }

        if ($action === "unsave" && $productId) {
            $producto = \Dao\Cart\Cart::getProductoDisponible($productId);
            $producto = $producto[$productId] ?? null;
            if ($producto) {
                \Dao\Cart\Cart::addItem($usercod, $anoncod, $productId, 1);
            }
            $this->unsave($productId);
            \Utilities\Site::redirectTo("index.php?page=Checkout_Cart");
        }

        $carrito = \Dao\Cart\Cart::getCarrito($usercod, $anoncod);
        $carrito["guardados"] = $this->getGuardados();

        \Views\Renderer::render("checkout/cart", $carrito);
    }

    private function getGuardados(): array
    {
        if (!isset($_SESSION["bp_guardados"]) || !is_array($_SESSION["bp_guardados"])) {
            $_SESSION["bp_guardados"] = array();
        }
        $productIds = array_keys($_SESSION["bp_guardados"]);
        if (empty($productIds)) {
            return array();
        }
        $guardados = array();
        foreach ($productIds as $productId) {
            $producto = \Dao\Cart\Cart::getProducto($productId);
            if ($producto) {
                $producto[0]["productPrice"] = \Utilities\Cart\CartFns::formatMoney($producto[0]["productPrice"]);
                $guardados[] = $producto[0];
            }
        }
        return $guardados;
    }

    private function save($productId): void
    {
        if (!isset($_SESSION["bp_guardados"]) || !is_array($_SESSION["bp_guardados"])) {
            $_SESSION["bp_guardados"] = array();
        }
        $_SESSION["bp_guardados"][$productId] = true;
    }

    private function unsave($productId): void
    {
        unset($_SESSION["bp_guardados"][$productId]);
    }
}
