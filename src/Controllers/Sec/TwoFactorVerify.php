<?php
namespace Controllers\Sec;

/**
 * Paso intermedio de login para usuarios ADM con 2FA activado. Login.php
 * ya validó la contraseña y dejó el usercod pendiente vía
 * Utilities\Security::setPendingTwoFactorUser(), SIN completar el login
 * (Utilities\Security::login todavía no se llamó).
 */
class TwoFactorVerify extends \Controllers\PublicController
{
    private $errorCode = "";

    public function run() :void
    {
        $usercod = \Utilities\Security::getPendingTwoFactorUser();
        if (!$usercod) {
            \Utilities\Site::redirectTo("index.php?page=sec_login");
        }

        if ($this->isPostBack()) {
            $codigo = trim($_POST["txtCodigo"] ?? "");

            if (\Utilities\Validators::IsEmpty($codigo)) {
                $this->errorCode = "Debes ingresar el código de tu app de autenticación.";
            } else {
                $secretRow = \Dao\Security\TwoFactor::getByUsuario($usercod);
                if ($secretRow
                    && (int)$secretRow["activado"] === 1
                    && \Utilities\Security\TOTP::verifyCode($secretRow["secret"], $codigo)
                ) {
                    $this->completarLogin($usercod);
                } else {
                    $this->errorCode = "Código incorrecto o expirado.";
                    \Dao\Security\Security::registrarBitacora(
                        \Dao\Security\BitacoraTipo::ERROR,
                        self::class,
                        "Código 2FA incorrecto durante login",
                        "ip=" . ($_SERVER["REMOTE_ADDR"] ?? "desconocida"),
                        $usercod
                    );
                }
            }
        }

        $dataView = get_object_vars($this);
        \Views\Renderer::render("security/twofactor_verify", $dataView);
    }

    private function completarLogin($usercod)
    {
        $dbUser = \Dao\Security\Security::getUsuarioById($usercod);
        if (!$dbUser) {
            \Utilities\Site::redirectTo("index.php?page=sec_login");
        }

        \Utilities\Security::clearPendingTwoFactor();
        session_regenerate_id(true);

        \Utilities\Security::login($dbUser["usercod"], $dbUser["username"], $dbUser["useremail"]);
        \Dao\Security\Security::registrarBitacora(
            \Dao\Security\BitacoraTipo::LOGIN,
            self::class,
            "Login exitoso con verificación 2FA",
            "ip=" . ($_SERVER["REMOTE_ADDR"] ?? "desconocida"),
            $dbUser["usercod"]
        );

        if (!empty($_COOKIE["bp_anoncod"])) {
            \Dao\Cart\Cart::mergeAnonToAuth($_COOKIE["bp_anoncod"], $dbUser["usercod"]);
        }
        \Utilities\Nav::invalidateNavData();
        \Utilities\Site::redirectTo("index.php");
    }
}
?>
