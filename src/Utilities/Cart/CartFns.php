<?php 
namespace Utilities\Cart;

class CartFns {

    public static function getAuthTimeDelta()
    {
        return 21600; // 6 * 60 * 60; // horas * minutos * segundo
        // No puede ser mayor a 34 días
    }

    public static function getUnAuthTimeDelta()
    {
        return 600 ;// 10 * 60; //h , m, s
        // No puede ser mayor a 34 días
    }

    public static function getAnonId()
    {
        if (!empty($_COOKIE["bp_anoncod"])) {
            return $_COOKIE["bp_anoncod"];
        }
        $anoncod = bin2hex(random_bytes(32));
        setcookie(
            "bp_anoncod",
            $anoncod,
            [
                "expires" => time() + (34 * 24 * 60 * 60),
                "path" => "/",
                "httponly" => true,
                "samesite" => "Lax",
            ]
        );
        $_COOKIE["bp_anoncod"] = $anoncod;
        return $anoncod;
    }

    public static function getIsvRate()
    {
        return 0.15; // ISV Honduras 15%
    }

    public static function getEnvioSimulado()
    {
        return 50.00; // Envío simulado fijo
    }

    public static function formatMoney($amount)
    {
        return number_format((float)$amount, 2);
    }
}

?>
