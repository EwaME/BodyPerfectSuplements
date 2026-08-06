<?php
namespace Controllers\Products;

use Controllers\PublicController;

class Products extends PublicController
{
    public function run(): void
    {
        $page = isset($_GET['p']) ? max(1, (int)$_GET['p'])        : 1;
        $search = isset($_GET['q']) ? trim($_GET['q'])                : '';
        $catId = isset($_GET['cat']) && $_GET['cat']      !== '' ? (int)$_GET['cat']      : null;
        $minPrice = isset($_GET['minPrice']) && $_GET['minPrice'] !== '' ? (float)$_GET['minPrice'] : null;
        $maxPrice = isset($_GET['maxPrice']) && $_GET['maxPrice'] !== '' ? (float)$_GET['maxPrice'] : null;

        $perPage = 10;
        $productos = \Dao\Products\Products::getListaProductos($catId, $search, $page, $perPage, $minPrice, $maxPrice);
        $total = \Dao\Products\Products::countListaProductos($catId, $search, $minPrice, $maxPrice);
        $categorias = \Dao\Products\Products::getCategories();
        $totalPages = (int)ceil($total / $perPage);
        $maxPriceSlider = \Dao\Products\Products::getMaxPrice();

        foreach ($productos as &$p) {
            $p['isAgotado'] = ($p['productStock'] <= 0 || $p['productStatus'] === 'AGO');
            $p['hasSale'] = ($p['salePrice'] !== null && $p['salePrice'] > 0) ? 1 : 0;
        }
        unset($p);

        foreach ($categorias as &$cat) {
            $cat['isActive'] = ($cat['categoryId'] == $catId) ? 1 : 0;
        }
        unset($cat);

        \Views\Renderer::render("products/catalog", [
            'productos' => $productos,
            'categorias' => $categorias,
            'total' => $total,
            'page' => $page,
            'totalPages' => $totalPages,
            'search' => htmlspecialchars($search),
            'catId' => $catId ?? '',
            'minPrice' => $minPrice ?? '',
            'maxPrice' => $maxPrice ?? '',
            'maxPriceSlider'=> $maxPriceSlider,
            'sliderMin' => $minPrice !== null ? (int)$minPrice : 0,
            'sliderMax' => $maxPrice !== null ? (int)$maxPrice : $maxPriceSlider,
            'hasPrev' => ($page > 1) ? 1 : 0,
            'hasNext' => ($page < $totalPages) ? 1 : 0,
            'prevPage' => $page - 1,
            'nextPage' => $page + 1,
        ]);
    }
}
