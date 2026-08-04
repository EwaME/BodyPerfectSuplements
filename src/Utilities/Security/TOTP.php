<?php

namespace Utilities\Security;

/**
 * Implementación mínima de TOTP (RFC 6238) sobre HMAC-SHA1 (RFC 4226),
 * compatible con Google Authenticator y apps equivalentes. No depende de
 * ninguna librería de Composer — el proyecto no trae SDK de 2FA instalado.
 */
class TOTP
{
    const PERIODO_SEGUNDOS = 30;
    const DIGITOS = 6;
    const ALGORITMO = "sha1";
    const ALFABETO_BASE32 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ234567";

    public static function generarSecreto($longitudBytes = 20)
    {
        return self::base32Encode(random_bytes($longitudBytes));
    }

    /**
     * URI otpauth:// estándar para escanear con Google Authenticator (o
     * ingresar la clave manualmente si no hay lector de QR disponible).
     */
    public static function getProvisioningUri($email, $issuer, $secret)
    {
        $label = rawurlencode($issuer . ":" . $email);
        $query = http_build_query(array(
            "secret" => $secret,
            "issuer" => $issuer,
            "algorithm" => "SHA1",
            "digits" => self::DIGITOS,
            "period" => self::PERIODO_SEGUNDOS,
        ));
        return "otpauth://totp/" . $label . "?" . $query;
    }

    public static function getCode($secret, $timeSlice = null)
    {
        if ($timeSlice === null) {
            $timeSlice = (int)floor(time() / self::PERIODO_SEGUNDOS);
        }

        $secretBinario = self::base32Decode($secret);
        $tiempoBinario = str_pad(pack("N", $timeSlice), 8, "\0", STR_PAD_LEFT);
        $hash = hash_hmac(self::ALGORITMO, $tiempoBinario, $secretBinario, true);

        $offset = ord(substr($hash, -1)) & 0x0F;
        $trozo = substr($hash, $offset, 4);
        $valor = unpack("N", $trozo)[1] & 0x7FFFFFFF;

        $modulo = 10 ** self::DIGITOS;
        return str_pad((string)($valor % $modulo), self::DIGITOS, "0", STR_PAD_LEFT);
    }

    /**
     * Verifica un código con una ventana de tolerancia (por defecto 1 paso
     * hacia atrás/adelante = 30s) para absorber pequeños desfases de reloj
     * entre el servidor y el teléfono del usuario.
     */
    public static function verifyCode($secret, $codigo, $tolerancia = 1)
    {
        $codigo = trim((string)$codigo);
        if (!preg_match('/^\d{6}$/', $codigo)) {
            return false;
        }
        if (empty($secret)) {
            return false;
        }

        $sliceActual = (int)floor(time() / self::PERIODO_SEGUNDOS);
        for ($i = -$tolerancia; $i <= $tolerancia; $i++) {
            $calculado = self::getCode($secret, $sliceActual + $i);
            if (hash_equals($calculado, $codigo)) {
                return true;
            }
        }
        return false;
    }

    private static function base32Encode($binario)
    {
        $bits = "";
        foreach (str_split($binario) as $byte) {
            $bits .= str_pad(decbin(ord($byte)), 8, "0", STR_PAD_LEFT);
        }

        $bits = str_pad($bits, (int)(ceil(strlen($bits) / 5) * 5), "0", STR_PAD_RIGHT);

        $codificado = "";
        foreach (str_split($bits, 5) as $trozo) {
            $codificado .= self::ALFABETO_BASE32[bindec($trozo)];
        }
        return $codificado;
    }

    private static function base32Decode($base32)
    {
        $base32 = strtoupper((string)$base32);
        $base32 = preg_replace('/[^A-Z2-7]/', '', $base32);

        $bits = "";
        foreach (str_split($base32) as $caracter) {
            $posicion = strpos(self::ALFABETO_BASE32, $caracter);
            if ($posicion === false) {
                continue;
            }
            $bits .= str_pad(decbin($posicion), 5, "0", STR_PAD_LEFT);
        }

        $bytes = "";
        foreach (str_split($bits, 8) as $octeto) {
            if (strlen($octeto) < 8) {
                continue;
            }
            $bytes .= chr(bindec($octeto));
        }
        return $bytes;
    }

    private function __construct()
    {
    }
    private function __clone()
    {
    }
}
?>
