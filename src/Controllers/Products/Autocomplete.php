<?php
namespace Controllers\Products;

use Controllers\PublicController;

class Autocomplete extends PublicController
{
    public function run(): void
    {
        header('Content-Type: application/json; charset=utf-8');
        $q = isset($_GET['q']) ? trim($_GET['q']) : '';
        if (strlen($q) < 2) {
            echo json_encode([]);
            exit;
        }
        $results = \Dao\Products\Products::searchAutocomplete($q, 5);
        echo json_encode($results);
        exit;
    }
}
