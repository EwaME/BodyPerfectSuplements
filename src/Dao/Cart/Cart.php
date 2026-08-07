<?php

namespace Dao\Cart;

class Cart extends \Dao\Table
{
    public static function getProductosDisponibles()
    {
        $sqlAllProductosActivos = "SELECT * from products where productStatus in ('ACT');";
        $productosDisponibles = self::obtenerRegistros($sqlAllProductosActivos, array());

        $deltaAutorizada = \Utilities\Cart\CartFns::getAuthTimeDelta();
        $sqlCarretillaAutorizada = "select productId, sum(crrctd) as reserved
            from carretilla where TIME_TO_SEC(TIMEDIFF(now(), crrfching)) <= :delta
            group by productId;";
        $prodsCarretillaAutorizada = self::obtenerRegistros(
            $sqlCarretillaAutorizada,
            array("delta" => $deltaAutorizada)
        );

        $deltaNAutorizada = \Utilities\Cart\CartFns::getUnAuthTimeDelta();
        $sqlCarretillaNAutorizada = "select productId, sum(crrctd) as reserved
            from carretillaanon where TIME_TO_SEC(TIMEDIFF(now(), crrfching)) <= :delta
            group by productId;";
        $prodsCarretillaNAutorizada = self::obtenerRegistros(
            $sqlCarretillaNAutorizada,
            array("delta" => $deltaNAutorizada)
        );
        $productosCurados = array();
        foreach ($productosDisponibles as $producto) {
            if (!isset($productosCurados[$producto["productId"]])) {
                $productosCurados[$producto["productId"]] = $producto;
            }
        }
        foreach ($prodsCarretillaAutorizada as $producto) {
            if (isset($productosCurados[$producto["productId"]])) {
                $productosCurados[$producto["productId"]]["productStock"] -= $producto["reserved"];
            }
        }
        foreach ($prodsCarretillaNAutorizada as $producto) {
            if (isset($productosCurados[$producto["productId"]])) {
                $productosCurados[$producto["productId"]]["productStock"] -= $producto["reserved"];
            }
        }
        $productosDisponibles = null;
        $prodsCarretillaAutorizada = null;
        $prodsCarretillaNAutorizada = null;
        return $productosCurados;
    }

    public static function getProductoDisponible($productId)
    {
        $sqlAllProductosActivos = "SELECT * from products where productStatus in ('ACT') and productId=:productId;";
        $productosDisponibles = self::obtenerRegistros($sqlAllProductosActivos, array("productId" => $productId));

        $deltaAutorizada = \Utilities\Cart\CartFns::getAuthTimeDelta();
        $sqlCarretillaAutorizada = "select productId, sum(crrctd) as reserved
            from carretilla where productId=:productId and TIME_TO_SEC(TIMEDIFF(now(), crrfching)) <= :delta
            group by productId;";
        $prodsCarretillaAutorizada = self::obtenerRegistros(
            $sqlCarretillaAutorizada,
            array("productId" => $productId, "delta" => $deltaAutorizada)
        );

        $deltaNAutorizada = \Utilities\Cart\CartFns::getUnAuthTimeDelta();
        $sqlCarretillaNAutorizada = "select productId, sum(crrctd) as reserved
            from carretillaanon where productId = :productId and TIME_TO_SEC(TIMEDIFF(now(), crrfching)) <= :delta
            group by productId;";
        $prodsCarretillaNAutorizada = self::obtenerRegistros(
            $sqlCarretillaNAutorizada,
            array("productId" => $productId, "delta" => $deltaNAutorizada)
        );
        $productosCurados = array();
        foreach ($productosDisponibles as $producto) {
            if (!isset($productosCurados[$producto["productId"]])) {
                $productosCurados[$producto["productId"]] = $producto;
            }
        }
        foreach ($prodsCarretillaAutorizada as $producto) {
            if (isset($productosCurados[$producto["productId"]])) {
                $productosCurados[$producto["productId"]]["productStock"] -= $producto["reserved"];
            }
        }
        foreach ($prodsCarretillaNAutorizada as $producto) {
            if (isset($productosCurados[$producto["productId"]])) {
                $productosCurados[$producto["productId"]]["productStock"] -= $producto["reserved"];
            }
        }
        $productosDisponibles = null;
        $prodsCarretillaAutorizada = null;
        $prodsCarretillaNAutorizada = null;
        return $productosCurados;
    }

    public static function getProducto($productId)
    {
        $sqlAllProductosActivos = "SELECT * from products where productId=:productId;";
        $productosDisponibles = self::obtenerRegistros($sqlAllProductosActivos, array("productId" => $productId));
        return $productosDisponibles;
    }

    private static function getMiCantidadEnCarretilla($usercod, $anoncod, $productId)
    {
        if ($usercod > 0) {
            $sql = "select crrctd from carretilla where usercod = :usercod and productId = :productId;";
            $fila = self::obtenerUnRegistro($sql, array("usercod" => $usercod, "productId" => $productId));
        } else {
            $sql = "select crrctd from carretillaanon where anoncod = :anoncod and productId = :productId;";
            $fila = self::obtenerUnRegistro($sql, array("anoncod" => $anoncod, "productId" => $productId));
        }
        return $fila ? (int)$fila["crrctd"] : 0;
    }

    public static function addItem($usercod, $anoncod, $productId, $cantidad)
    {
        $cantidad = (int)$cantidad;
        if ($cantidad <= 0) {
            return array("ok" => false, "error" => "La cantidad debe ser mayor a cero.");
        }

        $producto = self::getProductoDisponible($productId);
        $producto = $producto[$productId] ?? null;
        if (!$producto || $producto["productStatus"] !== "ACT") {
            return array("ok" => false, "error" => "El producto no está disponible.");
        }

        $miCantidadActual = self::getMiCantidadEnCarretilla($usercod, $anoncod, $productId);
        $disponible = (int)$producto["productStock"] + $miCantidadActual;
        $cantidadFinal = $miCantidadActual + $cantidad;
        if ($cantidadFinal > $disponible) {
            return array(
                "ok" => false,
                "error" => "Solo hay " . $disponible . " unidad(es) disponible(s) de " . $producto["productName"] . "."
            );
        }

        $crrprc = $producto["productPrice"];
        if ($usercod > 0) {
            $sql = "insert into carretilla (usercod, productId, crrctd, crrprc, crrfching)
                values (:usercod, :productId, :cantidad, :crrprc, now())
                on duplicate key update crrctd = crrctd + :cantidad2, crrfching = now();";
            self::executeNonQuery($sql, array(
                "usercod" => $usercod,
                "productId" => $productId,
                "cantidad" => $cantidad,
                "cantidad2" => $cantidad,
                "crrprc" => $crrprc,
            ));
        } else {
            $sql = "insert into carretillaanon (anoncod, productId, crrctd, crrprc, crrfching)
                values (:anoncod, :productId, :cantidad, :crrprc, now())
                on duplicate key update crrctd = crrctd + :cantidad2, crrfching = now();";
            self::executeNonQuery($sql, array(
                "anoncod" => $anoncod,
                "productId" => $productId,
                "cantidad" => $cantidad,
                "cantidad2" => $cantidad,
                "crrprc" => $crrprc,
            ));
        }
        return array("ok" => true, "error" => null);
    }

    public static function updateCantidad($usercod, $anoncod, $productId, $cantidad)
    {
        $cantidad = (int)$cantidad;
        if ($cantidad <= 0) {
            return self::removeItem($usercod, $anoncod, $productId);
        }

        $producto = self::getProductoDisponible($productId);
        $producto = $producto[$productId] ?? null;
        if (!$producto) {
            return array("ok" => false, "error" => "El producto no está disponible.");
        }

        $miCantidadActual = self::getMiCantidadEnCarretilla($usercod, $anoncod, $productId);
        $disponible = (int)$producto["productStock"] + $miCantidadActual;
        if ($cantidad > $disponible) {
            return array(
                "ok" => false,
                "error" => "Solo hay " . $disponible . " unidad(es) disponible(s) de " . $producto["productName"] . "."
            );
        }

        if ($usercod > 0) {
            $sql = "update carretilla set crrctd = :cantidad, crrfching = now()
                where usercod = :usercod and productId = :productId;";
            self::executeNonQuery($sql, array("cantidad" => $cantidad, "usercod" => $usercod, "productId" => $productId));
        } else {
            $sql = "update carretillaanon set crrctd = :cantidad, crrfching = now()
                where anoncod = :anoncod and productId = :productId;";
            self::executeNonQuery($sql, array("cantidad" => $cantidad, "anoncod" => $anoncod, "productId" => $productId));
        }
        return array("ok" => true, "error" => null);
    }

    public static function removeItem($usercod, $anoncod, $productId)
    {
        if ($usercod > 0) {
            $sql = "delete from carretilla where usercod = :usercod and productId = :productId;";
            self::executeNonQuery($sql, array("usercod" => $usercod, "productId" => $productId));
        } else {
            $sql = "delete from carretillaanon where anoncod = :anoncod and productId = :productId;";
            self::executeNonQuery($sql, array("anoncod" => $anoncod, "productId" => $productId));
        }
        return array("ok" => true, "error" => null);
    }

    public static function getCarrito($usercod, $anoncod)
    {
        if ($usercod > 0) {
            $delta = \Utilities\Cart\CartFns::getAuthTimeDelta();
            $sql = "select c.productId, c.crrctd, c.crrprc, p.productName, p.productImgUrl, p.productStock, p.productStatus, p.productPrice
                from carretilla c
                inner join products p on p.productId = c.productId
                where c.usercod = :owner and TIME_TO_SEC(TIMEDIFF(now(), c.crrfching)) <= :delta
                order by c.crrfching desc;";
        } else {
            $delta = \Utilities\Cart\CartFns::getUnAuthTimeDelta();
            $sql = "select c.productId, c.crrctd, c.crrprc, p.productName, p.productImgUrl, p.productStock, p.productStatus, p.productPrice
                from carretillaanon c
                inner join products p on p.productId = c.productId
                where c.anoncod = :owner and TIME_TO_SEC(TIMEDIFF(now(), c.crrfching)) <= :delta
                order by c.crrfching desc;";
        }
        $items = self::obtenerRegistros($sql, array("owner" => $usercod > 0 ? $usercod : $anoncod, "delta" => $delta));

        $inventarioLimiteUnidades = 5;

        $subtotal = 0;
        foreach ($items as &$item) {
            $item["crrctd"] = (int)$item["crrctd"];
            $item["crrprc"] = (float)$item["crrprc"];
            $item["lineaTotal"] = round($item["crrctd"] * $item["crrprc"], 2);
            $item["agotado"] = ($item["productStatus"] !== "ACT" || $item["productStock"] <= 0);
            $item["inventarioLimitado"] = (!$item["agotado"] && $item["productStock"] <= $inventarioLimiteUnidades);
            $item["precioActual"] = (float)$item["productPrice"];
            $item["precioCambio"] = (!$item["agotado"] && abs($item["precioActual"] - $item["crrprc"]) >= 0.01);
            $subtotal += $item["lineaTotal"];
        }
        unset($item);

        $isvRate = \Utilities\Cart\CartFns::getIsvRate();
        $isv = round($subtotal * $isvRate, 2);
        $envio = count($items) > 0 ? \Utilities\Cart\CartFns::getEnvioSimulado() : 0.0;
        $total = round($subtotal + $isv + $envio, 2);

        foreach ($items as &$item) {
            $item["crrprc"] = \Utilities\Cart\CartFns::formatMoney($item["crrprc"]);
            $item["lineaTotal"] = \Utilities\Cart\CartFns::formatMoney($item["lineaTotal"]);
            $item["precioActual"] = \Utilities\Cart\CartFns::formatMoney($item["precioActual"]);
        }
        unset($item);

        return array(
            "items" => $items,
            "subtotal" => \Utilities\Cart\CartFns::formatMoney($subtotal),
            "isv" => \Utilities\Cart\CartFns::formatMoney($isv),
            "envio" => \Utilities\Cart\CartFns::formatMoney($envio),
            "total" => \Utilities\Cart\CartFns::formatMoney($total),
        );
    }

    public static function mergeAnonToAuth($anoncod, $usercod)
    {
        if (empty($anoncod) || !$usercod) {
            return;
        }
        $sql = "select productId, crrctd from carretillaanon where anoncod = :anoncod;";
        $itemsAnon = self::obtenerRegistros($sql, array("anoncod" => $anoncod));

        $sqlDelete = "delete from carretillaanon where anoncod = :anoncod;";
        self::executeNonQuery($sqlDelete, array("anoncod" => $anoncod));

        foreach ($itemsAnon as $itemAnon) {
            self::addItem($usercod, null, $itemAnon["productId"], $itemAnon["crrctd"]);
        }
    }

    public static function validarCarrito($usercod, $anoncod)
    {
        if ($usercod > 0) {
            $delta = \Utilities\Cart\CartFns::getAuthTimeDelta();
            $sql = "select productId, crrctd from carretilla
                where usercod = :owner and TIME_TO_SEC(TIMEDIFF(now(), crrfching)) <= :delta;";
        } else {
            $delta = \Utilities\Cart\CartFns::getUnAuthTimeDelta();
            $sql = "select productId, crrctd from carretillaanon
                where anoncod = :owner and TIME_TO_SEC(TIMEDIFF(now(), crrfching)) <= :delta;";
        }
        $items = self::obtenerRegistros($sql, array("owner" => $usercod > 0 ? $usercod : $anoncod, "delta" => $delta));

        $problemas = array();
        foreach ($items as $item) {
            $productId = $item["productId"];
            $cantidad = (int)$item["crrctd"];

            $producto = self::getProductoDisponible($productId);
            $producto = $producto[$productId] ?? null;
            if (!$producto || $producto["productStatus"] !== "ACT") {
                $problemas[] = array(
                    "productId" => $productId,
                    "mensaje" => "Un producto de tu carrito ya no está disponible.",
                );
                continue;
            }

            $miCantidadActual = self::getMiCantidadEnCarretilla($usercod, $anoncod, $productId);
            $disponible = (int)$producto["productStock"] + $miCantidadActual;
            if ($cantidad > $disponible) {
                $problemas[] = array(
                    "productId" => $productId,
                    "mensaje" => "Solo hay " . $disponible . " unidad(es) disponible(s) de " . $producto["productName"] . "."
                );
            }
        }
        return $problemas;
    }
}
