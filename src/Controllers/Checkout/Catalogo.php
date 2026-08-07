<?php

 namespace Controllers\Checkout;

use Controllers\PrivateController;

class Catalogo extends PrivateController
{

    public function run():void
    {

        $producto = \Dao\Productos::getAll();
        $carretilla = \Dao\Carretilla::getAll(\Utilities\Security::getUserId());

        $carrAssoc = array();
        foreach($carretilla as $carr) {
            $carrAssoc[$carr["prdcod"]] = $carr;
        }

        foreach($producto as $prod) {
            if (isset($carrAssoc[$prod["prdcod"]])) {
                $prod["enCarretilla"] = true;
            } else {
                $prod["enCarretilla"] = false;
            }
        }
        \Views\Renderer::render("abc", array("productos" => $producto));
    }
}

?>
