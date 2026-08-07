<?php

namespace Utilities\PayPal;

class PayPalFns
{
    public static function getTasaCambioLempirasPorDolar()
    {
        return 24.60;
    }

    public static function lempirasToUsd($montoLempiras)
    {
        return round(((float) $montoLempiras) / self::getTasaCambioLempirasPorDolar(), 2);
    }
}
