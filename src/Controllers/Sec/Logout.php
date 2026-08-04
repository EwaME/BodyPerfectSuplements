<?php
namespace Controllers\Sec;
class Logout extends \Controllers\PublicController
{
    public function run():void
    {
        if (\Utilities\Security::isLogged()) {
            \Dao\Security\Security::registrarBitacora(
                \Dao\Security\BitacoraTipo::LOGOUT,
                self::class,
                "Cierre de sesión",
                "ip=" . ($_SERVER["REMOTE_ADDR"] ?? "desconocida"),
                \Utilities\Security::getUserId()
            );
        }
        \Utilities\Security::logout();
        \Utilities\Site::redirectTo("index.php");
    }
}

?>
