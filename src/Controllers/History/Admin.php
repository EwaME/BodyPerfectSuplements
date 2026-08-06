<?php

namespace Controllers\History;

use Controllers\PrivateController;
use Views\Renderer;

class Admin extends PrivateController
{
    public function run(): void
    {
        $search = isset($_GET["q"]) ? trim($_GET["q"]) : "";
        $estado = isset($_GET["estado"]) ? trim($_GET["estado"]) : "";
        $fechaInicio = isset($_GET["fechaInicio"]) ? trim($_GET["fechaInicio"]) : "";
        $fechaFin = isset($_GET["fechaFin"]) ? trim($_GET["fechaFin"]) : "";
        $page = isset($_GET["p"]) ? max(1, (int)$_GET["p"]) : 1;
        $perPage = 10;

        $transacciones = \Dao\History\History::getAllTransaccionesAdmin($search, $estado, $fechaInicio, $fechaFin, $page, $perPage);
        $total = \Dao\History\History::countAllTransaccionesAdmin($search, $estado, $fechaInicio, $fechaFin);
        $totalPages = (int)ceil($total / $perPage);

        foreach ($transacciones as &$t) {
            if ($t["estado"] === "APR") {
                $t["estadoBadge"] = "bp-badge-act";
                $t["estadoText"] = "Aprobado";
            } elseif ($t["estado"] === "PND") {
                $t["estadoBadge"] = "bp-badge-pnd";
                $t["estadoText"] = "Pendiente";
            } elseif ($t["estado"] === "RCH") {
                $t["estadoBadge"] = "bp-badge-ina";
                $t["estadoText"] = "Rechazado";
            } else {
                $t["estadoBadge"] = "bp-badge-ago";
                $t["estadoText"] = "Cancelado";
            }
        }
        unset($t);

        $viewData = array(
            "transacciones" => $transacciones,
            "hasTransacciones" => count($transacciones) > 0,
            "total" => $total,
            "page" => $page,
            "totalPages" => $totalPages,
            "search" => htmlspecialchars($search),
            "estado" => $estado,
            "fechaInicio" => $fechaInicio,
            "fechaFin" => $fechaFin,
            "isFilterAll" => ($estado === "" || $estado === "ALL"),
            "isFilterAPR" => ($estado === "APR"),
            "isFilterPND" => ($estado === "PND"),
            "isFilterRCH" => ($estado === "RCH"),
            "hasPrev" => ($page > 1),
            "hasNext" => ($page < $totalPages),
            "prevPage" => $page - 1,
            "nextPage" => $page + 1,
        );

        Renderer::render("history/admin", $viewData);
    }
}
