<?php

$email = 'admin@bodyperfect.com';
$nombre = 'Administrador';
$rawPwd = 'Admin1234!';
$pwdHash = 'BodyPerfect2026SecretHash';

$salt = hash_hmac('sha256', $rawPwd, $pwdHash);
$hashed = password_hash($salt, PASSWORD_BCRYPT);
$actCod = hash('sha256', $email . time());
$pwdExp = date('Y-m-d H:i:s', strtotime('+90 days'));

echo "-- Ejecuta estos dos statements en tu BD:\n\n";

echo "INSERT INTO `usuario`\n";
echo "    (`useremail`, `username`, `userpswd`, `userfching`,\n";
echo "     `userpswdest`, `userpswdexp`, `userest`, `useractcod`, `userpswdchg`, `usertipo`)\n";
echo "VALUES\n";
echo "    ('{$email}', '{$nombre}',\n";
echo "     '{$hashed}',\n";
echo "     NOW(), 'ACT', '{$pwdExp}',\n";
echo "     'ACT', '{$actCod}', NOW(), 'ADM');\n\n";

echo "-- Asigna el rol ADM (reemplaza 1 por el usercod real si no es el primero):\n";
echo "INSERT INTO `roles_usuarios` (`usercod`, `rolescod`, `roleuserest`, `roleuserfch`)\n";
echo "SELECT usercod, 'ADM', 'ACT', NOW() FROM usuario WHERE useremail = '{$email}' LIMIT 1;\n";
