<?php

namespace Controllers\History;

use Controllers\PrivateController;
use Utilities\Security;

class Export extends PrivateController
{
    public function run(): void
    {
        $type = isset($_GET["type"]) ? trim($_GET["type"]) : "history";
        $usercod = Security::getUserId();

        if ($type === "detail") {
            $pedidoId = isset($_GET["id"]) ? (int)$_GET["id"] : 0;
            $pedido = \Dao\History\History::getPedidoUsuario($pedidoId, $usercod);
            if (!$pedido) {

                $pedido = \Dao\History\History::getPedidoAdmin($pedidoId);
                $detalle = \Dao\History\History::getDetallePedidoAdmin($pedidoId);
            } else {
                $detalle = \Dao\History\History::getDetallePedidoUsuario($pedidoId, $usercod);
            }

            if (!$pedido) {
                \Utilities\Site::redirectToWithMsg("index.php?page=History_History", "Pedido no encontrado para exportar.");
            }

            $filename = "pedido_" . $pedidoId . "_" . date("Ymd_His") . ".csv";
            header('Content-Type: text/csv; charset=utf-8');
            header('Content-Disposition: attachment; filename=' . $filename);

            $output = fopen('php://output', 'w');
            fputcsv($output, array('Pedido ID', 'Fecha', 'Estado', 'Producto', 'Cantidad', 'Precio Unitario (L)', 'Subtotal (L)'));

            foreach ($detalle as $row) {
                fputcsv($output, array(
                    $pedido["id"],
                    $pedido["fecha"],
                    $pedido["estado"],
                    $row["productName"],
                    $row["cantidad"],
                    $row["precioUnitario"],
                    $row["subtotal"]
                ));
            }
            fclose($output);
            exit();
        } elseif ($type === "admin") {

            $search = isset($_GET["q"]) ? trim($_GET["q"]) : "";
            $estado = isset($_GET["estado"]) ? trim($_GET["estado"]) : "";
            $fechaInicio = isset($_GET["fechaInicio"]) ? trim($_GET["fechaInicio"]) : "";
            $fechaFin = isset($_GET["fechaFin"]) ? trim($_GET["fechaFin"]) : "";

            $transacciones = \Dao\History\History::getAllTransaccionesAdmin($search, $estado, $fechaInicio, $fechaFin, 1, 10000);

            $filename = "reporte_transacciones_admin_" . date("Ymd_His") . ".csv";
            header('Content-Type: text/csv; charset=utf-8');
            header('Content-Disposition: attachment; filename=' . $filename);

            $output = fopen('php://output', 'w');
            fputcsv($output, array('Pedido ID', 'Cliente', 'Correo', 'Fecha', 'Metodo Pago', 'Referencia Pasarela', 'Total (L)', 'Estado', 'Total Items'));

            foreach ($transacciones as $t) {
                fputcsv($output, array(
                    $t["id"],
                    $t["username"],
                    $t["useremail"],
                    $t["fecha"],
                    $t["metodoPago"] ?? 'PAYPAL',
                    $t["referenciaPasarela"] ?? 'N/A',
                    $t["total"],
                    $t["estado"],
                    $t["totalItems"]
                ));
            }
            fclose($output);
            exit();
        } else {

            $estado = isset($_GET["estado"]) ? trim($_GET["estado"]) : "";
            $pedidos = \Dao\History\History::getTransaccionesPorUsuario($usercod, 1, 1000, $estado);

            $filename = "historial_transacciones_" . date("Ymd_His") . ".csv";
            header('Content-Type: text/csv; charset=utf-8');
            header('Content-Disposition: attachment; filename=' . $filename);

            $output = fopen('php://output', 'w');
            fputcsv($output, array('Pedido ID', 'Fecha', 'Metodo Pago', 'Referencia Pasarela', 'Total (L)', 'Estado', 'Total Items'));

            foreach ($pedidos as $p) {
                fputcsv($output, array(
                    $p["id"],
                    $p["fecha"],
                    $p["metodoPago"] ?? 'PAYPAL',
                    $p["referenciaPasarela"] ?? 'N/A',
                    $p["total"],
                    $p["estado"],
                    $p["totalItems"]
                ));
            }
            fclose($output);
            exit();
        }
    }
}
