<?php
namespace Dao\Products;

class Products extends \Dao\Table
{
    public static function getDestacados()
    {
        $sql = "SELECT p.*, cat.categoryName,
                    COALESCE(s.salePrice, 0) as salePrice,
                    CASE WHEN s.saleId IS NOT NULL THEN 1 ELSE 0 END as hasSale
                FROM products p
                LEFT JOIN categories cat ON p.categoryId = cat.categoryId
                INNER JOIN highlights h ON p.productId = h.productId
                    AND NOW() BETWEEN h.highlightStart AND h.highlightEnd
                LEFT JOIN sales s ON p.productId = s.productId
                    AND NOW() BETWEEN s.saleStart AND s.saleEnd
                WHERE p.productStatus = 'ACT'
                ORDER BY h.highlightId DESC;";
        return self::obtenerRegistros($sql, []);
    }

    public static function getOfertas()
    {
        $sql = "SELECT p.*, cat.categoryName, s.salePrice, 1 as hasSale
                FROM products p
                LEFT JOIN categories cat ON p.categoryId = cat.categoryId
                INNER JOIN sales s ON p.productId = s.productId
                    AND NOW() BETWEEN s.saleStart AND s.saleEnd
                WHERE p.productStatus = 'ACT'
                ORDER BY s.saleId DESC;";
        return self::obtenerRegistros($sql, []);
    }

    public static function getListaProductos($categoryId = null, $search = '', $page = 1, $itemsPerPage = 12, $minPrice = null, $maxPrice = null)
    {
        $where = "WHERE p.productStatus IN ('ACT', 'AGO')";
        $params = [];

        if ($categoryId) {
            $where .= " AND (p.categoryId = :categoryId
                         OR p.categoryId IN (
                             SELECT categoryId FROM categories WHERE parentCategoryId = :categoryId2
                         ))";
            $params['categoryId']  = $categoryId;
            $params['categoryId2'] = $categoryId;
        }

        if ($search !== '') {
            $where .= " AND (p.productName LIKE :search OR p.productDescription LIKE :search2)";
            $params['search']  = '%' . $search . '%';
            $params['search2'] = '%' . $search . '%';
        }

        if ($minPrice !== null) {
            $where .= " AND p.productPrice >= :minPrice";
            $params['minPrice'] = $minPrice;
        }

        if ($maxPrice !== null) {
            $where .= " AND p.productPrice <= :maxPrice";
            $params['maxPrice'] = $maxPrice;
        }

        // LIMIT/OFFSET se interpolan directamente porque son enteros sanitizados — no hay riesgo de inyección
        $offset = (int)(($page - 1) * $itemsPerPage);
        $limit  = (int)$itemsPerPage;

        $sql = "SELECT p.*, cat.categoryName,
                    COALESCE(s.salePrice, 0) as salePrice,
                    CASE WHEN s.saleId IS NOT NULL THEN 1 ELSE 0 END as hasSale
                FROM products p
                LEFT JOIN categories cat ON p.categoryId = cat.categoryId
                LEFT JOIN sales s ON p.productId = s.productId
                    AND NOW() BETWEEN s.saleStart AND s.saleEnd
                {$where}
                ORDER BY p.productName ASC
                LIMIT {$offset}, {$limit};";

        return self::obtenerRegistros($sql, $params);
    }

    public static function countListaProductos($categoryId = null, $search = '', $minPrice = null, $maxPrice = null)
    {
        $where  = "WHERE p.productStatus IN ('ACT', 'AGO')";
        $params = [];

        if ($categoryId) {
            $where .= " AND (p.categoryId = :categoryId
                         OR p.categoryId IN (
                             SELECT categoryId FROM categories WHERE parentCategoryId = :categoryId2
                         ))";
            $params['categoryId']  = $categoryId;
            $params['categoryId2'] = $categoryId;
        }

        if ($search !== '') {
            $where .= " AND (p.productName LIKE :search OR p.productDescription LIKE :search2)";
            $params['search']  = '%' . $search . '%';
            $params['search2'] = '%' . $search . '%';
        }

        if ($minPrice !== null) {
            $where .= " AND p.productPrice >= :minPrice";
            $params['minPrice'] = $minPrice;
        }

        if ($maxPrice !== null) {
            $where .= " AND p.productPrice <= :maxPrice";
            $params['maxPrice'] = $maxPrice;
        }

        $sql    = "SELECT COUNT(*) as total FROM products p {$where};";
        $result = self::obtenerUnRegistro($sql, $params);
        return $result ? (int)$result['total'] : 0;
    }

    public static function getProductoById($productId)
    {
        $sql = "SELECT p.*, cat.categoryName,
                    COALESCE(s.salePrice, 0) as salePrice,
                    CASE WHEN s.saleId IS NOT NULL THEN 1 ELSE 0 END as hasSale
                FROM products p
                LEFT JOIN categories cat ON p.categoryId = cat.categoryId
                LEFT JOIN sales s ON p.productId = s.productId
                    AND NOW() BETWEEN s.saleStart AND s.saleEnd
                WHERE p.productId = :productId
                LIMIT 1;";
        return self::obtenerUnRegistro($sql, ['productId' => $productId]);
    }

    public static function insertProduct($data)
    {
        $sql = "INSERT INTO products
                    (productName, productDescription, productPrice,
                     productImgUrl, productStock, productStatus, categoryId)
                VALUES
                    (:productName, :productDescription, :productPrice,
                     :productImgUrl, :productStock, :productStatus, :categoryId);";
        return self::executeNonQuery($sql, [
            'productName'        => $data['productName'],
            'productDescription' => $data['productDescription'],
            'productPrice'       => $data['productPrice'],
            'productImgUrl'      => $data['productImgUrl'],
            'productStock'       => $data['productStock'],
            'productStatus'      => $data['productStatus'],
            'categoryId'         => $data['categoryId'],
        ]);
    }

    public static function updateProduct($data)
    {
        $sql = "UPDATE products SET
                    productName        = :productName,
                    productDescription = :productDescription,
                    productPrice       = :productPrice,
                    productImgUrl      = :productImgUrl,
                    productStock       = :productStock,
                    productStatus      = :productStatus,
                    categoryId         = :categoryId
                WHERE productId = :productId;";
        return self::executeNonQuery($sql, [
            'productName'        => $data['productName'],
            'productDescription' => $data['productDescription'],
            'productPrice'       => $data['productPrice'],
            'productImgUrl'      => $data['productImgUrl'],
            'productStock'       => $data['productStock'],
            'productStatus'      => $data['productStatus'],
            'categoryId'         => $data['categoryId'],
            'productId'          => $data['productId'],
        ]);
    }

    public static function toggleStatus($productId, $newStatus)
    {
        $sql = "UPDATE products SET productStatus = :status WHERE productId = :productId;";
        return self::executeNonQuery($sql, ['status' => $newStatus, 'productId' => $productId]);
    }

    public static function descontarStock($productId, $cantidad)
    {
        $sql = "UPDATE products SET productStock = productStock - :cantidad WHERE productId = :productId;";
        return self::executeNonQuery($sql, ['cantidad' => $cantidad, 'productId' => $productId]);
    }

    public static function getMaxPrice()
    {
        $sql    = "SELECT CEIL(MAX(productPrice) / 100) * 100 as maxPrice FROM products WHERE productStatus IN ('ACT','AGO');";
        $result = self::obtenerUnRegistro($sql, []);
        return $result && $result['maxPrice'] ? (int)$result['maxPrice'] : 5000;
    }

    public static function searchAutocomplete($search, $limit = 5)
    {
        $limit = (int)$limit;
        $sql = "SELECT p.productId, p.productName, p.productPrice, p.productImgUrl,
                    cat.categoryName,
                    COALESCE(s.salePrice, 0) as salePrice,
                    CASE WHEN s.saleId IS NOT NULL THEN 1 ELSE 0 END as hasSale
                FROM products p
                LEFT JOIN categories cat ON p.categoryId = cat.categoryId
                LEFT JOIN sales s ON p.productId = s.productId
                    AND NOW() BETWEEN s.saleStart AND s.saleEnd
                WHERE p.productStatus = 'ACT'
                    AND (p.productName LIKE :search OR p.productDescription LIKE :search2)
                ORDER BY p.productName ASC
                LIMIT {$limit};";
        return self::obtenerRegistros($sql, [
            'search'  => '%' . $search . '%',
            'search2' => '%' . $search . '%',
        ]);
    }

    public static function getCategories()
    {
        $sql = "SELECT categoryId, categoryName, parentCategoryId
                FROM categories
                ORDER BY parentCategoryId IS NULL DESC, categoryName ASC;";
        return self::obtenerRegistros($sql, []);
    }

    public static function getListaAdmin($search = '', $status = '', $page = 1, $perPage = 15)
    {
        $where  = "WHERE 1=1";
        $params = [];

        if ($search !== '') {
            $where .= " AND (p.productName LIKE :search OR p.productDescription LIKE :search2)";
            $params['search']  = '%' . $search . '%';
            $params['search2'] = '%' . $search . '%';
        }
        if (in_array($status, ['ACT','INA','AGO'])) {
            $where .= " AND p.productStatus = :status";
            $params['status'] = $status;
        }

        $offset = (int)(($page - 1) * $perPage);
        $limit  = (int)$perPage;

        $sql = "SELECT p.*, cat.categoryName
                FROM products p
                LEFT JOIN categories cat ON p.categoryId = cat.categoryId
                {$where}
                ORDER BY p.productId DESC
                LIMIT {$offset}, {$limit};";
        return self::obtenerRegistros($sql, $params);
    }

    public static function countListaAdmin($search = '', $status = '')
    {
        $where  = "WHERE 1=1";
        $params = [];

        if ($search !== '') {
            $where .= " AND (p.productName LIKE :search OR p.productDescription LIKE :search2)";
            $params['search']  = '%' . $search . '%';
            $params['search2'] = '%' . $search . '%';
        }
        if (in_array($status, ['ACT','INA','AGO'])) {
            $where .= " AND p.productStatus = :status";
            $params['status'] = $status;
        }

        $sql    = "SELECT COUNT(*) as total FROM products p {$where};";
        $result = self::obtenerUnRegistro($sql, $params);
        return (int)($result['total'] ?? 0);
    }

    private function __construct() {}
    private function __clone()    {}
}
