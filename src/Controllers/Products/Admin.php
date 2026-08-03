<?php
namespace Controllers\Products;

use Controllers\PrivateController;

class Admin extends PrivateController
{
    public function run(): void
    {
        $ok        = isset($_GET['ok']) ? $_GET['ok'] : '';
        $productos = \Dao\Products\Products::getListaAdmin();

        foreach ($productos as &$p) {
            $p['isACT'] = ($p['productStatus'] === 'ACT') ? 1 : 0;
            $p['isINA'] = ($p['productStatus'] === 'INA') ? 1 : 0;
            $p['isAGO'] = ($p['productStatus'] === 'AGO') ? 1 : 0;
        }
        unset($p);

        \Views\Renderer::render("products/list", [
            'productos' => $productos,
            'ok'        => $ok,
        ]);
    }
}
