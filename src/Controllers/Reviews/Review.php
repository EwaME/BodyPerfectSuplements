<?php
namespace Controllers\Reviews;

use Controllers\PublicController;

class Review extends PublicController
{
    public function run(): void
    {
        if (!\Utilities\Security::isLogged()) {
            \Utilities\Site::redirectTo("index.php?page=Sec_Login");
        }

        $productId = isset($_POST['productId']) ? (int)$_POST['productId'] : 0;
        if (!$productId || !$this->isPostBack()) {
            \Utilities\Site::redirectTo("index.php?page=Products_Products");
        }

        $usercod = \Utilities\Security::getUserId();
        $calificacion = isset($_POST['calificacion']) ? (int)$_POST['calificacion'] : 0;
        $comentario = trim($_POST['comentario'] ?? '');

        $redirect = "index.php?page=Products_Detail&id={$productId}";

        if ($calificacion < 1 || $calificacion > 5) {
            \Utilities\Site::redirectToWithMsg($redirect, "Selecciona una calificación entre 1 y 5 estrellas.");
        }
        if (!\Dao\Reviews\Reviews::yaCompro($productId, $usercod)) {
            \Utilities\Site::redirectToWithMsg($redirect, "Solo puedes reseñar productos que hayas comprado.");
        }
        if (\Dao\Reviews\Reviews::yaRevisado($productId, $usercod)) {
            \Utilities\Site::redirectToWithMsg($redirect, "Ya dejaste una reseña para este producto.");
        }

        \Dao\Reviews\Reviews::insertar($productId, $usercod, $calificacion, $comentario);
        \Utilities\Site::redirectToWithMsg($redirect, "¡Gracias por tu reseña!");
    }
}
