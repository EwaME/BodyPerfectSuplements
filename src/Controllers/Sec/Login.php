<?php
namespace Controllers\Sec;
class Login extends \Controllers\PublicController
{
    private $txtEmail = "";
    private $txtPswd = "";
    private $errorEmail = "";
    private $errorPswd = "";
    private $generalError = "";
    private $hasError = false;

    public function run() :void
    {
        if ($this->isPostBack()) {
            $this->txtEmail = $_POST["txtEmail"];
            $this->txtPswd = $_POST["txtPswd"];

            if (!\Utilities\Validators::IsValidEmail($this->txtEmail)) {
                $this->errorEmail = "¡Correo no tiene el formato adecuado!";
                $this->hasError = true;
            }
            if (\Utilities\Validators::IsEmpty($this->txtPswd)) {
                $this->errorPswd = "¡Debe ingresar una contraseña!";
                $this->hasError = true;
            }

            if (! $this->hasError && $this->estaBloqueadoPorIntentos()) {
                $this->generalError = "Demasiados intentos fallidos. Intenta de nuevo en unos minutos.";
                $this->hasError = true;
            }

            if (! $this->hasError) {
                if ($dbUser = \Dao\Security\Security::getUsuarioByEmail($this->txtEmail)) {
                    $credencialesInvalidas = false;

                    if ($dbUser["userest"] != \Dao\Security\Estados::ACTIVO) {
                        $credencialesInvalidas = true;
                    } elseif (!\Dao\Security\Security::verifyPassword($this->txtPswd, $dbUser["userpswd"])) {
                        $credencialesInvalidas = true;
                    }

                    if ($credencialesInvalidas) {
                        $this->generalError = "¡Credenciales son incorrectas!";
                        $this->hasError = true;
                        $this->registrarIntento(
                            \Dao\Security\BitacoraTipo::ERROR,
                            "Intento de login fallido",
                            $dbUser["usercod"]
                        );
                    } elseif ($this->requiereDobleFactor($dbUser)) {

                        session_regenerate_id(true);
                        \Utilities\Security::setPendingTwoFactorUser($dbUser["usercod"]);
                        \Utilities\Site::redirectTo("index.php?page=sec_twofactorverify");
                    } else {
                        $this->completarLogin($dbUser);
                    }
                } else {
                    $this->registrarIntento(
                        \Dao\Security\BitacoraTipo::ERROR,
                        "Intento de login con correo no registrado",
                        null
                    );
                    $this->generalError = "¡Credenciales son incorrectas!";
                    $this->hasError = true;
                }
            }
        }
        \Utilities\Site::addLink("public/css/security.css?v=" . (file_exists("public/css/security.css") ? filemtime("public/css/security.css") : time()));
        $dataView = get_object_vars($this);
        \Views\Renderer::render("security/login", $dataView);
    }

    private function estaBloqueadoPorIntentos() :bool
    {
        $maxIntentos = (int)\Utilities\Context::getContextByKey("LOGIN_MAX_ATTEMPTS");
        if ($maxIntentos <= 0) {
            $maxIntentos = 5;
        }
        $ventanaMinutos = (int)\Utilities\Context::getContextByKey("LOGIN_LOCKOUT_MINUTES");
        if ($ventanaMinutos <= 0) {
            $ventanaMinutos = 15;
        }

        $intentos = \Dao\Security\Security::contarIntentosFallidos($this->txtEmail, $ventanaMinutos, self::class);
        if ($intentos < $maxIntentos) {
            return false;
        }

        $this->registrarIntento(
            \Dao\Security\BitacoraTipo::AUDITORIA,
            "Login bloqueado temporalmente por exceso de intentos fallidos",
            null
        );
        return true;
    }

    private function requiereDobleFactor($dbUser) :bool
    {
        return $dbUser["usertipo"] === \Dao\Security\UsuarioTipo::ADMINITRADAOR
            && \Dao\Security\TwoFactor::isActivado($dbUser["usercod"]);
    }

    private function registrarIntento($bitTipo, $descripcion, $usercod)
    {
        \Dao\Security\Security::registrarBitacora(
            $bitTipo,
            self::class,
            $descripcion,
            "email=" . $this->txtEmail . ";ip=" . ($_SERVER["REMOTE_ADDR"] ?? "desconocida") . ";",
            $usercod
        );
    }

    private function completarLogin($dbUser)
    {

        session_regenerate_id(true);

        \Utilities\Security::login(
            $dbUser["usercod"],
            $dbUser["username"],
            $dbUser["useremail"]
        );
        $this->registrarIntento(\Dao\Security\BitacoraTipo::LOGIN, "Login exitoso", $dbUser["usercod"]);

        if (!empty($_COOKIE["bp_anoncod"])) {
            \Dao\Cart\Cart::mergeAnonToAuth($_COOKIE["bp_anoncod"], $dbUser["usercod"]);
        }
        \Utilities\Nav::invalidateNavData();
        if (\Utilities\Context::getContextByKey("redirto") !== "") {
            \Utilities\Site::redirectTo(
                \Utilities\Context::getContextByKey("redirto")
            );
        } else {
            \Utilities\Site::redirectTo("index.php");
        }
    }
}
?>
