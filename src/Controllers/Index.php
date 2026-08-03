<?php
namespace Controllers;

class Index extends PublicController
{
    public function run() :void
    {
        $destacados = \Dao\Products\Products::getDestacados();
        $ofertas    = \Dao\Products\Products::getOfertas();

        foreach ($destacados as &$p) {
            $p['isAgotado'] = ($p['productStock'] <= 0 || $p['productStatus'] === 'AGO') ? 1 : 0;
            $p['hasSale']   = isset($p['hasSale']) ? (int)$p['hasSale'] : 0;
        }
        unset($p);

        foreach ($ofertas as &$p) {
            $p['isAgotado'] = ($p['productStock'] <= 0 || $p['productStatus'] === 'AGO') ? 1 : 0;
            $p['hasSale']   = 1;
        }
        unset($p);

        $viewData = [
            'destacados' => $destacados,
            'ofertas'    => $ofertas,
        ];

        \Views\Renderer::render("index", $viewData);
    }
}
