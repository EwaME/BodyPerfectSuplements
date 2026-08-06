# BodyPerfect Suplementos — Tienda en Línea

Proyecto final de Negocios Web. Tienda de suplementos deportivos bajo el modelo de **Productos Inventariables**, construida sobre el framework Simple PHP MVC OOP.

---

## Equipo

| # | Integrante | Módulo(s) |
|---|---|---|
| 1 | Edward | A — Arquitectura MVC + B — Catálogo de Productos |
| 2 | Compañero/a 2 | C — Carrito de Compras |
| 3 | Compañero/a 3 | D — Esquema de Seguridad |
| 4 | Compañero/a 4 | E — Pasarela de Pagos |
| 5 | Compañero/a 5 | F — Histórico de Transacciones |
| 6 | Compañero/a 6 | G — QA, Integración, Documentación y Video |

---

## Instalación

### Requisitos
- PHP 7.4+
- MySQL 5.7+ / MariaDB 10.3+
- Composer
- Servidor web (XAMPP recomendado)

### Pasos

1. Clonar el repositorio dentro de la carpeta del servidor web:
   ```
   C:\xampp\htdocs\BodyPerfect\
   ```

2. Instalar dependencias:
   ```bash
   composer install
   ```

3. Copiar y configurar variables de entorno:
   ```bash
   # Renombrar renameTo_parameters.env a parameters.env
   # Editar los valores según el entorno local
   ```

   Variables clave en `parameters.env`:
   ```
   BASE_DIR = /BodyPerfect
   DB_SERVER = 127.0.0.1
   DB_USER = root
   DB_PSWD =
   DB_DATABASE = ecommerce
   PWD_HASH = BodyPerfect2026SecretHash
   ```

4. Crear/actualizar la base de datos con el script maestro:
   ```bash
   mysql -u root ecommerce < sql/schema.sql
   ```
   Es **idempotente**: crea todo desde cero si la base está vacía, y si ya
   tenías algo creado, solo agrega lo que falte (tablas y filas nuevas) sin
   duplicar ni borrar nada existente. Correrlo de nuevo después de un
   `git pull` es la forma de quedar al día con el esquema y el catálogo
   más reciente del equipo.

   > Los scripts en `docs/scripts/00_*.sql` a `05_*.sql` quedan como
   > referencia histórica (documentan cómo se construyó cada módulo paso
   > a paso) pero **no son idempotentes** — no los vuelvas a correr sobre
   > una base que ya los tiene, van a fallar con "table already exists".
   > Para instalar o actualizar, usá siempre `sql/schema.sql`.

   Opcional — reseñas de ejemplo (requiere usuarios y productos ya creados):
   ```bash
   mysql -u root ecommerce < docs/scripts/06_demo_reviews.sql
   ```

5. Generar el usuario administrador inicial:
   ```bash
   php sql/seed_admin.php
   ```
   Copiar el SQL generado y ejecutarlo en la base de datos.

6. Abrir en el navegador:
   ```
   http://localhost/BodyPerfect/index.php
   ```

---

## Credenciales de prueba

| Rol | Email | Contraseña |
|---|---|---|
| Administrador | admin@bodyperfect.com | Admin1234! |

---

## Estructura de directorios

```
BodyPerfect/
├── docs/
│   └── scripts/           Scripts SQL en orden de ejecución
├── public/
│   ├── css/               Hojas de estilo compiladas
│   ├── css_src/           Fuentes LESS
│   └── imgs/              Imágenes (hero, productos)
├── sql/
│   └── seed_admin.php     Generador de usuario admin inicial
├── src/
│   ├── Controllers/
│   │   ├── Checkout/      Carrito, Checkout, Accept, Error
│   │   ├── History/       Historial de compras (usuario y admin)
│   │   ├── Products/      CRUD de productos y catálogo público
│   │   └── Sec/           Login, Logout, Register, 2FA
│   ├── Dao/
│   │   ├── Cart/          Lógica de carrito (TTL)
│   │   ├── Checkout/      Pedidos y transacciones
│   │   ├── History/       Consultas de historial
│   │   ├── Products/      Consultas de catálogo
│   │   └── Security/      Usuarios, roles, bitácora, 2FA
│   ├── Utilities/
│   │   ├── Cart/          CartFns (TTL, ISV, envío)
│   │   ├── PayPal/        REST API de PayPal Sandbox
│   │   └── Security/      TOTP para 2FA
│   └── Views/
│       └── templates/     Plantillas .view.tpl por módulo
├── reglas-contexto/       Documentación interna del proyecto
├── nav.config.json        Configuración del menú de navegación
├── parameters.env         Variables de entorno (no commitear)
├── composer.json
└── index.php              Punto de entrada único
```

---

## Flujo de trabajo Git

### Regla fundamental
**Edward es el único que puede hacer merge hacia `main`.** Los demás integrantes trabajan exclusivamente en su rama personal y nunca tocan `main`.

### Ramas
Cada integrante tiene una sola rama con su nombre:
```
main          ← solo Edward hace merge aquí
edward        ← Módulos A y B
<nombre2>     ← Módulo C
<nombre3>     ← Módulo D
<nombre4>     ← Módulo E
<nombre5>     ← Módulo F
<nombre6>     ← Módulo G
```

No se crean ramas por feature (`feature/carrito`, `feature/login`, etc.). Una rama por persona, todo su trabajo va ahí.

### Comandos permitidos para los 5 compañeros
```bash
git status
git add <archivo>
git commit -m "Descripción en español, modo imperativo"
git push
git pull
git merge origin/main   # para traer cambios de main a tu rama
```

Cualquier otro comando (`rebase`, `cherry-pick`, `reset --hard`, `checkout -b`) requiere autorización de Edward.

### Proceso de integración
1. El integrante termina su trabajo en su rama y hace `push`.
2. Avisa a Edward que su módulo está listo para integrar.
3. Edward revisa, resuelve conflictos si hay y hace el merge a `main`.
4. Todos los demás hacen `git merge origin/main` para actualizar su rama.

### Commits
- Siempre manuales, nunca automáticos (ni por herramientas de IA).
- Mensajes en español, modo imperativo: `"Agrega validación de stock en carrito"`, no `"cambios"` o `"fix"`.
- **Nunca commitear `parameters.env`** — ya está en `.gitignore`. No forzar con `git add -f`.

---

## Notas técnicas

- **Contraseñas:** `hash_hmac(sha256, password, PWD_HASH)` + `password_hash()` bcrypt. Nunca texto plano.
- **RBAC:** Cada controlador privado se autoriza contra la tabla `funciones` usando su nombre de clase. Los ítems del menú usan tipo `MNU`, los controladores usan tipo `CTR`.
- **Carrito:** Patrón TTL — sin campo de estado. La disponibilidad se calcula restando las reservas vigentes dentro de la ventana de tiempo (6h autenticado, 10min anónimo).
- **PayPal:** Integración directa a REST API v2, modalidad sandbox. Credenciales en `parameters.env`.
- **2FA:** TOTP compatible con Google Authenticator. Activable desde el menú "Seguridad 2FA", solo para administradores.
