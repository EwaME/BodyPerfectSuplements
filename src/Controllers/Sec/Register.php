<?php

namespace Controllers\Sec;

use Controllers\PublicController;
use \Utilities\Validators;
use Exception;

class Register extends PublicController
{
    private $txtNombre = "";
    private $txtEmail  = "";
    private $txtPswd   = "";
    private $errorNombre = "";
    private $errorEmail  = "";
    private $errorPswd   = "";
    private $hasErrors   = false;

    public function run() :void
    {
        if ($this->isPostBack()) {
            $this->txtNombre = trim($_POST["txtNombre"] ?? "");
            $this->txtEmail  = $_POST["txtEmail"]  ?? "";
            $this->txtPswd   = $_POST["txtPswd"]   ?? "";

            if ($this->txtNombre === "") {
                $this->errorNombre = "El nombre es requerido.";
                $this->hasErrors   = true;
            }
            if (!(Validators::IsValidEmail($this->txtEmail))) {
                $this->errorEmail = "El correo no tiene el formato adecuado";
                $this->hasErrors  = true;
            }
            if (!Validators::IsValidPassword($this->txtPswd)) {
                $this->errorPswd = "La contraseña debe tener al menos 8 caracteres una mayúscula, un número y un caracter especial.";
                $this->hasErrors = true;
            }

            if (!$this->hasErrors) {
                try {
                    if (\Dao\Security\Security::newUsuario($this->txtEmail, $this->txtPswd, $this->txtNombre)) {
                        $nuevoUsuario = \Dao\Security\Security::getUsuarioByEmail($this->txtEmail);
                        if ($nuevoUsuario) {
                            \Dao\Security\Security::asignarRol($nuevoUsuario["usercod"], "CLI");
                            \Dao\Security\Security::registrarBitacora(
                                \Dao\Security\BitacoraTipo::AUDITORIA,
                                self::class,
                                "Registro de nuevo usuario",
                                "ip=" . ($_SERVER["REMOTE_ADDR"] ?? "desconocida"),
                                $nuevoUsuario["usercod"]
                            );
                        }
                        \Utilities\Site::redirectToWithMsg("index.php?page=sec_login", "¡Usuario Registrado Satisfactoriamente!");
                    }
                } catch (Error $ex) {
                    die($ex);
                }
            }
        }
        \Utilities\Site::addLink("public/css/security.css?v=" . (file_exists("public/css/security.css") ? filemtime("public/css/security.css") : time()));
        $viewData = get_object_vars($this);
        \Views\Renderer::render("security/sigin", $viewData);
    }
}
?>
