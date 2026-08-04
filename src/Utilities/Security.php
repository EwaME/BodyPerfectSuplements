<?php

namespace Utilities;

use Dao\Security\Security as DaoSecurity;
class Security {
    private function __construct()
    {
        
    }
    private function __clone()
    {
        
    }
    public static function logout()
    {
        unset($_SESSION["login"]);
    }
    public static function login($userId, $userName, $userEmail)
    {
        $_SESSION["login"] = array(
            "isLogged" => true,
            "userId" => $userId,
            "userName" => $userName,
            "userEmail" => $userEmail,
            "lastActivity" => time()
        );
    }
    /**
     * Ademas de indicar si hay sesion activa, aplica el timeout por
     * inactividad (SESSION_TIMEOUT_MINUTES): si la ultima actividad
     * registrada excede ese limite, cierra la sesion automaticamente.
     */
    public static function isLogged():bool
    {
        if (!isset($_SESSION["login"]) || !$_SESSION["login"]["isLogged"]) {
            return false;
        }

        $timeoutMinutos = (int)\Utilities\Context::getContextByKey("SESSION_TIMEOUT_MINUTES");
        if ($timeoutMinutos <= 0) {
            $timeoutMinutos = 20;
        }
        $lastActivity = isset($_SESSION["login"]["lastActivity"])
            ? $_SESSION["login"]["lastActivity"]
            : time();

        if ((time() - $lastActivity) > ($timeoutMinutos * 60)) {
            self::logout();
            return false;
        }

        $_SESSION["login"]["lastActivity"] = time();
        return true;
    }
    public static function getUser()
    {
        if (isset($_SESSION["login"])) {
            return $_SESSION["login"];
        }
        return false;
    }
    public static function getUserId()
    {
        if (isset($_SESSION["login"])) {
            return $_SESSION["login"]["userId"];
        }
        return 0;
    }
    public static function isAuthorized($userId, $function, $type = 'FNC'):bool
    {
        if (\Utilities\Context::getContextByKey("DEVELOPMENT") == "1") {
            $functionInDb = DaoSecurity::getFeature($function);
            if (!$functionInDb) {
                DaoSecurity::addNewFeature($function, $function, "ACT", $type);
            }
        }
        return DaoSecurity::getFeatureByUsuario($userId, $function);
    }
    public static function isInRol($userId, $rol):bool
    {
        if (\Utilities\Context::getContextByKey("DEVELOPMENT") == "1") {
            $rolInDb = DaoSecurity::getRol($rol);
            if (!$rolInDb) {
                DaoSecurity::addNewRol($rol, $rol, "ACT");
            }
        }
        return DaoSecurity::isUsuarioInRol($userId, $rol);
    }

    /**
     * Estado intermedio de login cuando falta el segundo factor: la
     * contraseña ya se validó pero \Utilities\Security::login() todavía
     * NO se ha llamado, así que no cuenta como sesión autenticada.
     */
    public static function setPendingTwoFactorUser($userId)
    {
        $_SESSION["pending2fa"] = array("userId" => $userId);
    }
    public static function getPendingTwoFactorUser()
    {
        return isset($_SESSION["pending2fa"]["userId"]) ? $_SESSION["pending2fa"]["userId"] : 0;
    }
    public static function clearPendingTwoFactor()
    {
        unset($_SESSION["pending2fa"]);
    }

    /**
     * Secreto TOTP generado pero aún no confirmado por el usuario durante
     * el enrolamiento (Controllers\Sec\TwoFactorSetup).
     */
    public static function setPendingTwoFactorSecret($secret)
    {
        $_SESSION["pending2faSecret"] = $secret;
    }
    public static function getPendingTwoFactorSecret()
    {
        return isset($_SESSION["pending2faSecret"]) ? $_SESSION["pending2faSecret"] : "";
    }
    public static function clearPendingTwoFactorSecret()
    {
        unset($_SESSION["pending2faSecret"]);
    }
}
