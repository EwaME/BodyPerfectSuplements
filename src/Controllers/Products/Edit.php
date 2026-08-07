<?php
namespace Controllers\Products;

use Controllers\PrivateController;

class Edit extends PrivateController
{
    public function run(): void
    {
        $productId = isset($_GET['id']) ? (int)$_GET['id'] : 0;
        if (!$productId) {
            \Utilities\Site::redirectTo('index.php?page=Products_Admin');
        }

        $producto = \Dao\Products\Products::getProductoById($productId);
        if (!$producto) {
            \Utilities\Site::redirectTo('index.php?page=Products_Admin');
        }

        $errors = [];
        $form = $producto;

        if ($this->isPostBack()) {
            $form['productName'] = trim($_POST['productName'] ?? '');
            $form['productDescription'] = trim($_POST['productDescription'] ?? '');
            $form['productPrice'] = trim($_POST['productPrice'] ?? '');
            $form['productStock'] = (int)($_POST['productStock'] ?? 0);
            $form['productStatus'] = in_array($_POST['productStatus'] ?? '', ['ACT', 'INA', 'AGO']) ? $_POST['productStatus'] : 'ACT';
            $form['categoryId'] = isset($_POST['categoryId']) && $_POST['categoryId'] !== '' ? (int)$_POST['categoryId'] : null;

            $newImg = $this->uploadImage($errors);
            $form['productImgUrl'] = $newImg !== '' ? $newImg : trim($_POST['productImgUrlActual'] ?? '');

            if ($form['productName'] === '') {
                $errors['errorName'] = 'Nombre requerido.';
            }
            if (!is_numeric($form['productPrice']) || (float)$form['productPrice'] <= 0) {
                $errors['errorPrice'] = 'Precio debe ser mayor a 0.';
            }

            if (empty($errors)) {
                $form['productId'] = $productId;
                \Dao\Products\Products::updateProduct($form);
                \Utilities\Site::redirectTo('index.php?page=Products_Admin&ok=updated');
            }
        }

        $categorias = \Dao\Products\Products::getCategories();
        foreach ($categorias as &$cat) {
            $cat['isSelected'] = ($cat['categoryId'] == $form['categoryId']) ? 1 : 0;
        }
        unset($cat);

        \Views\Renderer::render("products/form", array_merge($form, $errors, [
            'categorias' => $categorias,
            'formTitle' => 'Editar Producto',
            'formAction' => 'index.php?page=Products_Edit&id=' . $productId,
            'isEdit' => 1,
            'isACT' => ($form['productStatus'] === 'ACT') ? 1 : 0,
        ]));
    }

    private function uploadImage(array &$errors): string
    {
        $file = $_FILES['productImg'] ?? null;
        if (!$file || $file['error'] === UPLOAD_ERR_NO_FILE) {
            return '';
        }
        if ($file['error'] !== UPLOAD_ERR_OK) {
            $errors['errorImg'] = 'Error al subir el archivo.';
            return '';
        }
        $allowed = ['image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp', 'image/gif' => 'gif'];
        $mime = mime_content_type($file['tmp_name']);
        if (!isset($allowed[$mime])) {
            $errors['errorImg'] = 'Solo se permiten imágenes JPG, PNG, WEBP o GIF.';
            return '';
        }
        if ($file['size'] > 5 * 1024 * 1024) {
            $errors['errorImg'] = 'La imagen no debe superar 5 MB.';
            return '';
        }
        $filename = uniqid('p', true) . '.' . $allowed[$mime];
        $dest = __DIR__ . '/../../../public/imgs/products/' . $filename;
        if (!move_uploaded_file($file['tmp_name'], $dest)) {
            $errors['errorImg'] = 'No se pudo guardar la imagen.';
            return '';
        }
        return $filename;
    }
}
