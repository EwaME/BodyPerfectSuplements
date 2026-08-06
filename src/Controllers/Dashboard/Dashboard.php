<?php
namespace Controllers\Dashboard;

use Controllers\PrivateController;

class Dashboard extends PrivateController
{
    public function run(): void
    {
        $resumen      = \Dao\Dashboard\Dashboard::getResumenGeneral();
        $ventasDia    = \Dao\Dashboard\Dashboard::getVentasPorDia(7);
        $masVendidos  = \Dao\Dashboard\Dashboard::getProductosMasVendidos(5);
        $stockBajo    = \Dao\Dashboard\Dashboard::getStockBajo(10);

        // Preparar datos para Chart.js (JSON)
        $labelsVentas   = [];
        $dataIngresos   = [];
        $dataPedidos    = [];
        foreach ($ventasDia as $v) {
            $labelsVentas[] = $v['dia'];
            $dataIngresos[] = (float)$v['ingresos'];
            $dataPedidos[]  = (int)$v['pedidos'];
        }

        $labelsTop  = [];
        $dataTop    = [];
        foreach ($masVendidos as $mv) {
            $labelsTop[] = $mv['productName'];
            $dataTop[]   = (int)$mv['totalVendido'];
        }

        \Views\Renderer::render("dashboard/dashboard", [
            'totalPedidos'    => $resumen['totalPedidos']   ?? 0,
            'totalIngresos'   => number_format((float)($resumen['totalIngresos'] ?? 0), 2),
            'totalClientes'   => $resumen['totalClientes']  ?? 0,
            'totalProductos'  => $resumen['totalProductos'] ?? 0,
            'stockBajo'       => $stockBajo,
            'hayStockBajo'    => count($stockBajo) > 0 ? 1 : 0,
            'jsonLabelsVentas'  => json_encode($labelsVentas),
            'jsonDataIngresos'  => json_encode($dataIngresos),
            'jsonDataPedidos'   => json_encode($dataPedidos),
            'jsonLabelsTop'     => json_encode($labelsTop),
            'jsonDataTop'       => json_encode($dataTop),
            'hayVentas'         => count($ventasDia) > 0 ? 1 : 0,
            'hayMasVendidos'    => count($masVendidos) > 0 ? 1 : 0,
        ]);
    }
}
