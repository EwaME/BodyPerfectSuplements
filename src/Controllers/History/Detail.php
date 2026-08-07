<?php

namespace Controllers\History;

use Controllers\PrivateController;
use Utilities\Security;
use Views\Renderer;

class Detail extends PrivateController
{
    public function run(): void
    {
        $pedidoId = isset($_GET["id"]) ? (int)$_GET["id"] : 0;
        $usercod = Security::getUserId();

        if ($pedidoId <= 0) {
            \Utilities\Site::redirectToWithMsg("index.php?page=History_History", "ID de pedido no válido.");
        }

        $pedido = \Dao\History\History::getPedidoUsuario($pedidoId, $usercod);
        if (!$pedido) {
            $pedido = \Dao\History\History::getPedidoAdmin($pedidoId);
            $detalle = \Dao\History\History::getDetallePedidoAdmin($pedidoId);
        } else {
            $detalle = \Dao\History\History::getDetallePedidoUsuario($pedidoId, $usercod);
        }

        if (!$pedido) {
            \Utilities\Site::redirectToWithMsg("index.php?page=History_History", "No se encontró el pedido solicitado.");
        }

        $pedido["isPND"] = ($pedido["estado"] === "PND");
        $pedido["isAPR"] = ($pedido["estado"] === "APR");
        $pedido["isRCH"] = ($pedido["estado"] === "RCH");
        $pedido["isCAN"] = ($pedido["estado"] === "CAN");

        if ($pedido["estado"] === "APR") {
            $pedido["estadoBadge"] = "badge-success";
            $pedido["estadoText"] = "Aprobado";
        } elseif ($pedido["estado"] === "PND") {
            $pedido["estadoBadge"] = "badge-warning";
            $pedido["estadoText"] = "Pendiente";
        } elseif ($pedido["estado"] === "RCH") {
            $pedido["estadoBadge"] = "badge-danger";
            $pedido["estadoText"] = "Rechazado";
        } else {
            $pedido["estadoBadge"] = "badge-secondary";
            $pedido["estadoText"] = "Cancelado";
        }

        $subtotalGeneral = 0;
        foreach ($detalle as &$item) {
            $subtotalGeneral += floatval($item["subtotal"]);
        }
        unset($item);

        $fromAdmin = isset($_GET["from"]) && $_GET["from"] === "admin";
        $isOwner = \Dao\History\History::getPedidoUsuario($pedidoId, $usercod);

        if ($fromAdmin || !$isOwner) {
            $returnUrl = "index.php?page=History_Admin";
            $returnText = "Volver al Panel Admin";
        } else {
            $returnUrl = "index.php?page=History_History";
            $returnText = "Volver a Mis Compras";
        }

        $viewData = array(
            "pedido" => $pedido,
            "detalle" => $detalle,
            "subtotalGeneral" => number_format($subtotalGeneral, 2),
            "returnUrl" => $returnUrl,
            "returnText" => $returnText
        );

        Renderer::render("history/detail", $viewData);
    }
}
