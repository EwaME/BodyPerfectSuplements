<?php

namespace Controllers\History;

use Controllers\PrivateController;
use Utilities\Security;
use Views\Renderer;

class History extends PrivateController
{
    public function run(): void
    {
        $usercod = Security::getUserId();

        $page = isset($_GET["p"]) ? max(1, (int)$_GET["p"]) : 1;
        $estado = isset($_GET["estado"]) ? trim($_GET["estado"]) : "";
        $perPage = 8;

        $pedidos = \Dao\History\History::getTransaccionesPorUsuario($usercod, $page, $perPage, $estado);
        $total = \Dao\History\History::countTransaccionesPorUsuario($usercod, $estado);
        $totalPages = (int)ceil($total / $perPage);

        foreach ($pedidos as &$p) {
            $p["isPND"] = ($p["estado"] === "PND");
            $p["isAPR"] = ($p["estado"] === "APR");
            $p["isRCH"] = ($p["estado"] === "RCH");
            $p["isCAN"] = ($p["estado"] === "CAN");

            if ($p["estado"] === "APR") {
                $p["estadoBadge"] = "badge-success";
                $p["estadoText"] = "Aprobado";
            } elseif ($p["estado"] === "PND") {
                $p["estadoBadge"] = "badge-warning";
                $p["estadoText"] = "Pendiente";
            } elseif ($p["estado"] === "RCH") {
                $p["estadoBadge"] = "badge-danger";
                $p["estadoText"] = "Rechazado";
            } else {
                $p["estadoBadge"] = "badge-secondary";
                $p["estadoText"] = "Cancelado";
            }
        }
        unset($p);

        $viewData = array(
            "pedidos" => $pedidos,
            "hasPedidos" => count($pedidos) > 0,
            "total" => $total,
            "page" => $page,
            "totalPages" => $totalPages,
            "estado" => $estado,
            "isFilterAll" => ($estado === "" || $estado === "ALL"),
            "isFilterAPR" => ($estado === "APR"),
            "isFilterPND" => ($estado === "PND"),
            "isFilterRCH" => ($estado === "RCH"),
            "hasPrev" => ($page > 1),
            "hasNext" => ($page < $totalPages),
            "prevPage" => $page - 1,
            "nextPage" => $page + 1,
        );

        Renderer::render("history/history", $viewData);
    }
}
