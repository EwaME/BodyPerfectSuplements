<?php
namespace Controllers\Products;

use Controllers\PublicController;

class Detail extends PublicController
{
    public function run(): void
    {
        $productId = isset($_GET['id']) ? (int)$_GET['id'] : 0;
        if (!$productId) {
            \Utilities\Site::redirectTo('index.php?page=Products_Products');
        }

        $producto = \Dao\Products\Products::getProductoById($productId);
        if (!$producto || $producto['productStatus'] === 'INA') {
            \Utilities\Site::redirectTo('index.php?page=Products_Products');
        }

        $producto['isAgotado'] = ($producto['productStock'] <= 0 || $producto['productStatus'] === 'AGO') ? 1 : 0;
        $producto['hasSale'] = ($producto['hasSale'] == 1) ? 1 : 0;

        $reviews = \Dao\Reviews\Reviews::getByProduct($productId);
        $promedio = \Dao\Reviews\Reviews::getPromedio($productId);

        $isLogged = \Utilities\Security::isLogged();
        $usercod = $isLogged ? \Utilities\Security::getUserId() : 0;
        $puedeResenar = $isLogged
            && \Dao\Reviews\Reviews::yaCompro($productId, $usercod)
            && !\Dao\Reviews\Reviews::yaRevisado($productId, $usercod);

        $msgReview = '';
        if ($isLogged && \Dao\Reviews\Reviews::yaRevisado($productId, $usercod)) {
            $msgReview = 'ya_revisado';
        } elseif ($isLogged && !\Dao\Reviews\Reviews::yaCompro($productId, $usercod)) {
            $msgReview = 'no_compro';
        }

        foreach ($reviews as &$r) {
            $r['estrellas'] = str_repeat('★', (int)$r['calificacion'])
                            . str_repeat('☆', 5 - (int)$r['calificacion']);
        }
        unset($r);

        \Views\Renderer::render("products/detail", array_merge($producto, [
            'reviews' => $reviews,
            'hayReviews' => count($reviews) > 0 ? 1 : 0,
            'totalReviews' => (int)($promedio['total'] ?? 0),
            'promedio' => number_format((float)($promedio['promedio'] ?? 0), 1),
            'puedeResenar' => $puedeResenar ? 1 : 0,
            'isMsgYaRevisado' => ($msgReview === 'ya_revisado') ? 1 : 0,
            'isMsgNoCompro' => ($msgReview === 'no_compro') ? 1 : 0,
            'isLogged' => $isLogged ? 1 : 0,
        ]));
    }
}
