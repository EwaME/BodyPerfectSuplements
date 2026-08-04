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
                \Utilities\Site::redirectToWithMsg("index.php?page=History_History", "Pedido no encontrado para exportar.");
            }
            $detalle = \Dao\History\History::getDetallePedidoUsuario($pedidoId, $usercod);

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
        } else {
            // Exportar lista del historial
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
