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
        $producto['hasSale']   = ($producto['hasSale'] == 1) ? 1 : 0;

        \Views\Renderer::render("products/detail", $producto);
    }
}
