# Reglas del Proyecto — Convenciones de Código
## Basado en el código real trabajado en clase (putra / mvc_nw_2026)

Este documento define cómo debe escribirse el código para que los 6 módulos encajen sin fricción. No son opiniones — son las convenciones que ya existen en el framework que el catedrático les dio (`putra`) y en tu propio proyecto de práctica (`mvc_nw_2026`), extraídas directamente del código, no inventadas.

**Los otros dos documentos (`proyecto-final-plan.md` y `CONTEXTO-IA.md`) tenían una discrepancia real con esto y ya fueron corregidos** — ver sección 10.

---

## 0. De dónde sale el framework — y qué es exactamente `putra`

Cada integrante crea su propio repositorio usando el botón **"Use this template"** en:
**https://github.com/obetancourthunicah/SimplePHP_MVC_OOP_template**

Eso genera un repo limpio con solo el esqueleto (`Controllers`, `Dao`, `Utilities`, `Views` vacíos) — no trae Security, Cart ni PayPal resueltos. **No cloneen la carpeta `putra` del zip directamente como base de su repo** — esa carpeta trae su propio historial de Git (`.git`) de otra persona, y arrastrarlo mezcla commits ajenos con los suyos.

`putra` (y el proyecto de práctica `mvc_nw_2026`) son **material de referencia** para entender cómo se resuelven Security, Cart y PayPal dentro de este framework — de ahí sale todo lo documentado en las secciones 5, 6 y 7 de este archivo. Antes de copiar clases completas de ahí tal cual, confirma con el catedrático si el curso espera que las repliquen como patrón propio o si hay restricciones sobre reusar ese código punto por punto.

---

## 1. Convención de nombres

### 1.1 Namespaces y carpetas
- `Controllers\<Modulo>\<Accion>` — un controlador por acción, agrupado en subcarpeta por módulo. Ejemplos reales: `Controllers\Sec\Login`, `Controllers\Products\Products`, `Controllers\Checkout\Checkout`.
- `Dao\<Modulo>\<Entidad>` — un Dao por entidad, agrupado por módulo. Ejemplos reales: `Dao\Security\Security`, `Dao\Products\Products`, `Dao\Cart\Cart`.
- `Utilities\<Modulo>\<Clase>` cuando la utilidad es específica de un módulo (ej. `Utilities\Cart\CartFns`, `Utilities\PayPal\PayPalRestApi`); directo bajo `Utilities\` cuando es transversal (`Utilities\Security`, `Utilities\Validators`, `Utilities\Site`).
- Vistas en `src/Views/templates/<modulo_minuscula>/<nombre>.view.tpl`, mismo agrupamiento que el controlador.

### 1.2 Tablas y columnas SQL — mixto español/inglés, y así se queda
El framework del curso **no tiene una sola convención de idioma** — y no van a inventar una nueva. Sigan el patrón exacto que ya existe:
- Tablas de seguridad/negocio en español, con columnas abreviadas con prefijo de la tabla: `usuario` (usercod, useremail, username, userpswd, userfching, userpswdest, userpswdexp, userest, useractcod, userpswdchg, usertipo), `roles` (rolescod, rolesdsc, rolesest), `roles_usuarios`, `funciones` (fncod, fndsc, fnest, fntyp), `funciones_roles`, `bitacora` (bitacoracod, bitacorafch, bitprograma, bitdescripcion, bitobservacion, bitTipo, bitusuario).
- Tabla de catálogo en inglés, camelCase: `products` (productId, productName, productDescription, productPrice, productImgUrl, productStock, productStatus).
- Tabla de carrito en español: `carretilla` (usercod, productId, crrctd, crrprc, crrfching) para autenticados; `carretillaanon` (anoncod, productId, crrctd, crrprc, crrfching) para anónimos.

**No hay que traducir nada ni "limpiar" la inconsistencia** — replicar el patrón tal cual está en el código del profesor reduce el riesgo de que algo no calce con el framework base.

### 1.3 Códigos de estado — siempre `char(3)`, nunca booleanos ni texto libre
```
ACT = Activo
INA = Inactivo
BLQ = Bloqueado
SUS = Suspendido
```
Definidos como constantes en una clase que extiende `Utilities\Enum` (ver `Dao\Security\Estados`). Cualquier tabla nueva que necesite un campo de estado debe usar este mismo patrón de 3 letras, no `true/false` ni `"activo"/"inactivo"` en texto libre.

---

## 2. Enrutamiento

El router (`Utilities\Site::getPageRequest()`) convierte `index.php?page=Modulo_Controlador` en la clase `Controllers\Modulo\Controlador` reemplazando `_` por `\`. Por eso:

- El parámetro `page` en URLs y en `nav.config.json` sigue el patrón `Namespace_Clase` exacto (ej. `Sec_Login`, `Products_Products`, `Checkout_Checkout`).
- Cada entrada de menú nuevo va en `nav.config.json`, bajo `"public"` o `"private"` según corresponda, con `id`, `nav_url` y `nav_label`.
- Las rutas privadas (backoffice) requieren que el controlador extienda `PrivateController`; las públicas, `PublicController`.

---

## 3. Motor de plantillas (no es Blade, no es Twig)

El `Renderer` del curso usa su propia sintaxis. No usen sintaxis de otros motores — no va a funcionar.

| Sintaxis | Uso |
|---|---|
| `{{variable}}` | Imprime una variable del contexto actual |
| `{{~variable}}` | Imprime una variable del contexto raíz (root) |
| `{{&variable}}` | Imprime una variable del contexto padre (parent) |
| `{{if variable}} ... {{endif variable}}` | Condicional (el nombre debe repetirse en el cierre) |
| `{{ifnot variable}} ... {{endifnot variable}}` | Condicional negado |
| `{{foreach lista}} ... {{endfor lista}}` | Iteración, usa `{{this}}` para el ítem actual |
| `{{with objeto}} ... {{endwith objeto}}` | Cambia el contexto activo a una sub-clave |
| `{{include ruta/archivo}}` | Incluye otra plantilla `.view.tpl` |
| `{{{page_content}}}` | Solo en layouts: marca dónde se inserta la vista hija |

Ejemplo real de un formulario con validación (`security/login.view.tpl`):
```
<input value="{{txtEmail}}" />
{{if errorEmail}}
  <div class="error">{{errorEmail}}</div>
{{endif errorEmail}}
```

---

## 4. Capa de datos (Dao)

- Toda clase de acceso a datos extiende `\Dao\Table`, nunca instancia PDO directamente.
- Métodos siempre **estáticos**.
- Tres métodos heredados de `Table` para usar siempre, nunca queries manuales fuera de ellos:
  - `self::obtenerRegistros($sql, $params)` → varias filas (array).
  - `self::obtenerUnRegistro($sql, $params)` → una fila.
  - `self::executeNonQuery($sql, $params)` → INSERT/UPDATE/DELETE.
- **Todos los parámetros van bindeados** (`:nombre` en el SQL + array asociativo) — así ya vienen protegidos contra SQL injection sin que cada quien tenga que acordarse de escapar nada.
- Nombres de método en español y descriptivos del negocio, no genéricos: `getUsuarioByEmail`, `getListaProductos`, `getProductosDestacados`, `insertProduct` — mezcla de español/inglés está bien, sigan el patrón ya visto por módulo (el Dao de seguridad es más en español, el de productos mezcla inglés en los nombres de columna con español en la lógica).

---

## 5. Seguridad y sesión

- La sesión de login vive en `$_SESSION["login"]` como array: `isLogged`, `userId`, `userName`, `userEmail`. Usar siempre `Utilities\Security::login()`, `::logout()`, `::isLogged()`, `::getUserId()` — no leer `$_SESSION` directamente desde otros módulos.
- Contraseñas: `hash_hmac("sha256", $password, PWD_HASH)` como salt (secreto en `parameters.env`), y el resultado se pasa a `password_hash()` (bcrypt). Verificación con `password_verify()` sobre el mismo salt. **Nadie reimplementa este flujo distinto** — usar `Dao\Security\Security::_hashPassword` / `::verifyPassword` como están.
- Autorización **granular por función**, no solo por rol binario cliente/admin: cada controlador privado valida contra la tabla `funciones` usando su propio nombre de clase como código de función (`Security::isAuthorized($userId, $this->name, 'CTR')`). Los ítems de menú se filtran igual, con tipo `'MNU'`. Si necesitan una función nueva, se registra en `funciones` y se asigna a un rol en `funciones_roles` — no hardcodear `if ($rol == 'admin')` disperso en el código.
- Validaciones de formulario centralizadas en `Utilities\Validators` (regex de email y de contraseña ya están ahí — reutilizar, no rehacer).

---

## 6. Pasarela de pago (PayPal)

- Integración **directa vía cURL a la REST API v2 de PayPal**, sin SDK de Composer. Clases ya existentes: `Utilities\PayPal\PayPalOrder` (arma el JSON del pedido) y `Utilities\PayPal\PayPalRestApi` (`getAccessToken`, `createOrder`, `captureOrder`).
- Credenciales en `parameters.env`: `PAYPAL_CLIENT_ID`, `PAYPAL_CLIENT_SECRET`, `PAYPAL_CLIENT_ENV`.
- Flujo de 3 controladores separados, cada uno su propio archivo: `Checkout` (arma la orden y redirige a PayPal), `Accept` (captura el pago cuando PayPal redirige de vuelta, valida `token` contra `$_SESSION["orderid"]`), `Error` (cancelación/rechazo).

### Gap que el material de clase NO cubre — tienen que resolverlo ustedes
El código de referencia arma y captura la orden en PayPal, pero **no persiste nada en base de datos**. Guarda el `orderid` solo en `$_SESSION`. Eso no alcanza para los requisitos 6 y 7 del enunciado (guardar la transacción + histórico). El módulo de pagos (E) tiene que agregar, sobre este mismo flujo:
1. Crear el registro de orden/transacción en BD **antes** de redirigir a PayPal (estado `pendiente`).
2. Actualizar ese registro en `Accept.php` con el resultado real de `captureOrder()` (aprobado/rechazado) — ahí es donde hoy solo se imprime el JSON de respuesta y se descarta.
3. Usar los códigos de estado de 3 letras (sección 1.3) para el estado de la orden, no texto libre.

---

## 7. Carrito de compras

El patrón real **no usa una tabla `cart` con estado** — usa una ventana de tiempo (TTL) para decidir si una reserva de carrito sigue "viva":

- `carretilla` (autenticado) y `carretillaanon` (anónimo) guardan directamente usuario/anónimo + producto + cantidad + precio + fecha de inserción (`crrfching`).
- La disponibilidad real de un producto se calcula restando, del stock, la suma de `crrctd` de **todas las filas cuya `crrfching` esté dentro de la ventana vigente** (`Utilities\Cart\CartFns::getAuthTimeDelta()` = 6 horas para autenticados, `::getUnAuthTimeDelta()` = 10 minutos para anónimos). Filas más viejas que esa ventana se consideran expiradas y no reservan stock, aunque sigan físicamente en la tabla.
- **Ojo con un typo real que existe en el código base**: el script SQL crea la tabla como `carretillaanon`, pero el Dao la consulta como `carretillaanom` (con M). Revisen esto antes de copiar — no repliquen el error, usen un solo nombre consistente y verifíquenlo en ambos lados (script y Dao) antes de dar por bueno ese módulo.
- Fórmula de disponibilidad (ya vista en el contenido de clase, aplica igual aquí): `Cantidad Disponible = Stock en Inventario − Cantidad Reservada dentro de la ventana vigente`.

---

## 8. Herramienta interna: generador de scaffolding

En `mvc_nw_2026/src/Controllers/Generator/Generator.php` ya existe un generador que lee la estructura de cualquier tabla con `DESC tabla` y genera Controller + Dao + Vista base automáticamente. **Úsenlo** para arrancar cada módulo nuevo (Módulo C, F, etc.) en vez de copiar/pegar boilerplate a mano — ahorra tiempo y garantiza que el esqueleto generado ya sigue las convenciones de esta guía.

---

## 9. Control de versiones — reglas estrictas, no negociables

**Ramas individuales por persona, NO por feature.** Cada integrante tiene una única rama con su nombre (`edward`, `<nombre2>`, `<nombre3>`, etc.) y trabaja ahí todo lo que le corresponde, sin importar cuántos módulos o features toque. No se crean ramas `feature/carrito`, `feature/seguridad`, etc.

**Todo merge pasa por Edward, sin excepción.**
- Los 5 compañeros pueden hacer **únicamente**: `commit` dentro de su propia rama. Nunca Pull Request, nunca `merge` hacia `main`, nunca merge de ningún tipo hacia la rama de otro compañero.
- Cuando alguien termina algo que necesita integrarse, avisa a Edward. Edward es quien decide cuándo y cómo se integra a `main`.
- `main` es intocable para cualquiera que no sea Edward.

**Comandos de Git permitidos — cualquier otro está prohibido:**
```
git status
git add
git commit
git push
git pull
git merge origin/main
```
`git merge origin/main` (traer los cambios de `main` hacia la propia rama para mantenerse actualizado) es el único `merge` permitido para los 5 compañeros — nunca al revés. Nada de `git checkout -b` libre, `git rebase`, `git cherry-pick`, `git reset --hard`, ni ningún comando fuera de esta lista sin autorización explícita de Edward.

**El commit siempre es manual — nunca automático.** Si estás usando un asistente de IA (Claude Code u otro) para ayudarte a programar, ese asistente **nunca debe ejecutar `git commit` por su cuenta**. El asistente puede preparar los cambios, hasta hacer `git add` si se le pide, pero el `commit` lo escribe y ejecuta la persona, a mano, revisando qué está commiteando. Esto aplica a los 6 integrantes por igual, incluido Edward.

**Otras reglas:**
- No commitear `parameters.env` con credenciales reales — el `.gitignore` del framework ya lo excluye, no lo fuercen con `git add -f`.
- Mensajes de commit descriptivos en español, en modo imperativo: "Agrega validación de stock en carrito", no "cambios" o "fix".

---

## 10. Correcciones aplicadas a los otros documentos

Al revisar el código real del zip, encontré discrepancias entre lo que había documentado antes (basado solo en el contenido teórico del PDF) y lo que el framework de la clase realmente implementa. Ya corregí `proyecto-final-plan.md` y `CONTEXTO-IA.md` en los siguientes puntos:

| Documentado antes | Corregido a |
|---|---|
| Tabla `users` en inglés con roles `cliente`/`admin` | Tabla `usuario` en español + esquema completo de `roles`/`funciones`/`roles_usuarios`/`funciones_roles` (RBAC granular por función, no por rol binario) |
| Carrito con tablas `cart`/`cart_items` y campo de estado | Tablas `carretilla`/`carretillaanon` con reserva por ventana de tiempo (TTL), sin campo de estado |
| Auditoría en tabla `audit_log` genérica | Tabla `bitacora` con la nomenclatura exacta del curso |
| Se asumía que el flujo de PayPal ya persistía la transacción | Se documenta explícitamente que el flujo de referencia NO persiste nada — es un gap real que el Módulo E debe cerrar |

**Recomendación práctica: adopta esta convención tal cual, no la mejores.** Es tentador limpiarla (todo en inglés, todo consistente) porque así trabajas normalmente en OB Solutions — pero el catedrático va a esperar reconocer el patrón que él mismo enseñó. Desviarse aquí no suma puntos de arquitectura, solo agrega riesgo de que algo no calce con el framework base el día de la demo.
