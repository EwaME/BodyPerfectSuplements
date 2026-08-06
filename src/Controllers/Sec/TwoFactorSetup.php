<?php
namespace Controllers\Sec;

/**
 * Pantalla privada (solo rol ADM, ver seeds de funciones/funciones_roles)
 * para activar o desactivar el segundo factor (TOTP) de la propia cuenta.
 * No se le pide 2FA al cliente regular — es exclusivo del backoffice.
 */
class TwoFactorSetup extends \Controllers\PrivateController
{
    public function run() :void
    {
        $usercod = \Utilities\Security::getUserId();
        $usuario = \Utilities\Security::getUser();
        $estadoActual = \Dao\Security\TwoFactor::getByUsuario($usercod);
        $activado = $estadoActual && (int)$estadoActual["activado"] === 1;

        $error = "";
        $ok = isset($_GET["ok"]) ? $_GET["ok"] : "";

        if ($this->isPostBack()) {
            $accion = isset($_POST["accion"]) ? $_POST["accion"] : "";

            if ($accion === "desactivar" && $activado) {
                \Dao\Security\TwoFactor::desactivar($usercod);
                \Dao\Security\Security::registrarBitacora(
                    \Dao\Security\BitacoraTipo::AUDITORIA,
                    self::class,
                    "2FA desactivado por el usuario",
                    null,
                    $usercod
                );
                \Utilities\Security::clearPendingTwoFactorSecret();
                \Utilities\Site::redirectTo("index.php?page=sec_twofactorsetup&ok=disabled");
            } elseif ($accion === "activar" && !$activado) {
                $codigo = trim($_POST["txtCodigo"] ?? "");
                $secretPendiente = \Utilities\Security::getPendingTwoFactorSecret();

                if ($secretPendiente !== "" && \Utilities\Security\TOTP::verifyCode($secretPendiente, $codigo)) {
                    \Dao\Security\TwoFactor::guardarYActivar($usercod, $secretPendiente);
                    \Dao\Security\Security::registrarBitacora(
                        \Dao\Security\BitacoraTipo::AUDITORIA,
                        self::class,
                        "2FA activado por el usuario",
                        null,
                        $usercod
                    );
                    \Utilities\Security::clearPendingTwoFactorSecret();
                    \Utilities\Site::redirectTo("index.php?page=sec_twofactorsetup&ok=enabled");
                } else {
                    $error = "Código incorrecto. Escanea el código QR o ingresa la clave manual en tu app y vuelve a intentar.";
                }
            }
        }

        $secretParaMostrar = "";
        $otpauthUrl = "";
        if (!$activado) {
            $secretParaMostrar = \Utilities\Security::getPendingTwoFactorSecret();
            if ($secretParaMostrar === "") {
                $secretParaMostrar = \Utilities\Security\TOTP::generarSecreto();
                \Utilities\Security::setPendingTwoFactorSecret($secretParaMostrar);
            }
            $otpauthUrl = \Utilities\Security\TOTP::getProvisioningUri(
                $usuario["userEmail"],
                "BodyPerfect Suplementos",
                $secretParaMostrar
            );
        }

        \Utilities\Site::addLink("public/css/security.css");
        \Views\Renderer::render("security/twofactor_setup", array(
            "activado" => $activado ? 1 : 0,
            "secret" => $secretParaMostrar,
            "otpauthUrl" => $otpauthUrl,
            "error" => $error,
            "ok" => $ok,
        ));
    }
}
?>
