<?php

namespace Dao\Security;

class TwoFactor extends \Dao\Table
{
    static public function getByUsuario($usercod)
    {
        $sqlstr = "SELECT * FROM `two_factor_secrets` WHERE `usercod` = :usercod LIMIT 1;";
        return self::obtenerUnRegistro($sqlstr, array("usercod" => $usercod));
    }

    static public function isActivado($usercod)
    {
        $fila = self::getByUsuario($usercod);
        return $fila && (int)$fila["activado"] === 1;
    }

    static public function guardarYActivar($usercod, $secret)
    {
        $existente = self::getByUsuario($usercod);
        if ($existente) {
            $sql = "UPDATE `two_factor_secrets` SET `secret` = :secret, `activado` = 1
                WHERE `usercod` = :usercod;";
            return self::executeNonQuery($sql, array("secret" => $secret, "usercod" => $usercod));
        }

        $sql = "INSERT INTO `two_factor_secrets` (`usercod`, `secret`, `activado`)
            VALUES (:usercod, :secret, 1);";
        return self::executeNonQuery($sql, array("usercod" => $usercod, "secret" => $secret));
    }

    static public function desactivar($usercod)
    {
        $sql = "UPDATE `two_factor_secrets` SET `activado` = 0 WHERE `usercod` = :usercod;";
        return self::executeNonQuery($sql, array("usercod" => $usercod));
    }

    private function __construct()
    {
    }
    private function __clone()
    {
    }
}
?>
