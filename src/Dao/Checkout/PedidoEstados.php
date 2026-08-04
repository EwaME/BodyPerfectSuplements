<?php

namespace Dao\Checkout;

final class PedidoEstados extends \Utilities\Enum
{
    const PENDIENTE = "PND";
    const APROBADO = "APR";
    const RECHAZADO = "RCH";
    const CANCELADO = "CAN";
}
?>
