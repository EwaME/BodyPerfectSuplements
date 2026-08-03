<?php
namespace Controllers\Products;

use Controllers\PrivateController;

class Toggle extends PrivateController
{
    public function run(): void
    {
        $productId = isset($_GET['id'])     ? (int)$_GET['id']    : 0;
        $newStatus = isset($_GET['status']) ? $_GET['status']      : '';

        if ($productId && in_array($newStatus, ['ACT', 'INA'])) {
            \Dao\Products\Products::toggleStatus($productId, $newStatus);
        }

        \Utilities\Site::redirectTo('index.php?page=Products_Products');
    }
}
