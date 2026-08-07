<?php
namespace Controllers\Products;

use Controllers\PrivateController;

class Admin extends PrivateController
{
    public function run(): void
    {
        $ok = $_GET['ok'] ?? '';
        $search = trim($_GET['q'] ?? '');
        $status = $_GET['status'] ?? '';
        $page = max(1, (int)($_GET['p'] ?? 1));
        $perPage = 15;

        $productos = \Dao\Products\Products::getListaAdmin($search, $status, $page, $perPage);
        $total = \Dao\Products\Products::countListaAdmin($search, $status);
        $totalPages = max(1, (int)ceil($total / $perPage));

        foreach ($productos as &$p) {
            $p['isACT'] = ($p['productStatus'] === 'ACT') ? 1 : 0;
            $p['isINA'] = ($p['productStatus'] === 'INA') ? 1 : 0;
            $p['isAGO'] = ($p['productStatus'] === 'AGO') ? 1 : 0;
        }
        unset($p);

        \Views\Renderer::render("products/list", [
            'productos' => $productos,
            'ok' => $ok,
            'search' => htmlspecialchars($search),
            'filterStatus'=> $status,
            'total' => $total,
            'page' => $page,
            'totalPages' => $totalPages,
            'hasPrev' => ($page > 1) ? 1 : 0,
            'hasNext' => ($page < $totalPages) ? 1 : 0,
            'prevPage' => $page - 1,
            'nextPage' => $page + 1,
            'isFilterACT' => ($status === 'ACT') ? 1 : 0,
            'isFilterINA' => ($status === 'INA') ? 1 : 0,
            'isFilterAGO' => ($status === 'AGO') ? 1 : 0,
            'isFilterAll' => ($status === '') ? 1 : 0,
        ]);
    }
}
