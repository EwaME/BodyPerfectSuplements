# Documento de Contexto para Uso de IA
## Proyecto Final — Tienda de Suplementos (Negocios Web)

Este documento existe para que **cualquiera de los 6 integrantes lo pegue al inicio de una conversación con IA** (ChatGPT, Claude, Copilot, etc.) antes de pedir ayuda con su módulo. No reemplaza el documento de plan (`proyecto-final-plan.md`) ni el PDF del curso — es un puente entre ambos, resumido a lo que realmente van a construir.

**No se incluye en este documento** todo el contenido sobre B2B/C2C, activos digitales, modelos de suscripción, ni casos de Amazon/eBay/Toyota del PDF original. Esa parte del curso no aplica a un negocio de Productos Inventariables y solo generaría respuestas de IA genéricas y desalineadas del proyecto real.

---

## 1. Cómo usar este documento con una IA

1. Copia y pega la **Sección 2 (restricciones no negociables)** siempre, sin excepción, antes de pedir cualquier código.
2. Pega únicamente la subsección de la Sección 5 que corresponde a **tu módulo**. No pegues las 6 subsecciones completas — eso confunde a la IA con reglas de módulos que no le tocan a ella responder.
3. Si vas a pedir código de integración entre dos módulos (ej. carrito + pago), pega ambas subsecciones relevantes.
4. Nunca le pidas a la IA que "elija la mejor arquitectura" o "sugiera un framework" — el framework y el esquema de base de datos ya están definidos y son fijos. Pídele que trabaje **dentro** de esas restricciones.
5. Si la IA sugiere algo que contradice la Sección 2 o el esquema de base de datos de la Sección 4, no lo uses — repórtalo en el grupo para no generar incompatibilidades con el resto del código de tus compañeros.

---

## 2. Restricciones no negociables (pegar siempre)

- El proyecto usa **Simple PHP MVC OOP** (framework visto en clase). No se usa Laravel, Symfony, Next.js, ni ningún otro framework, aunque la IA lo sugiera como "más moderno" o "más fácil".
- Estructura de carpetas fija: `src/Controllers`, `src/Dao`, `src/Views/templates`, `public/`. No reestructurar.
- Todo controlador privado (backoffice) hereda de `PrivateController`; todo controlador público hereda de `PublicController`.
- Todo acceso a base de datos pasa por clases que extienden `Dao`/`Table`. No usar queries sueltas fuera de esa capa.
- Contraseñas: siempre `password_hash()` / `password_verify()` de PHP. Nunca MD5, SHA1 plano, ni texto plano.
- Todas las queries con **prepared statements** (PDO con parámetros bindeados). Nunca concatenar variables directamente en SQL.
- La pasarela de pago es **PayPal Sandbox**, modalidad diferida (redirección), no una simulación inventada ni otra pasarela.
- El esquema de base de datos de la Sección 4 es fijo. Si la IA sugiere agregar/quitar columnas o tablas, hay que validarlo con el resto del equipo antes de aplicarlo — no aplicar cambios de esquema unilateralmente.
- Categoría de negocio: **Productos Inventariables** (suplementos). No se implementa lógica de reservas de clases ni cupos del gimnasio.
- Nomenclatura de base de datos: usar los nombres de tabla/columna reales del framework (español para seguridad y carrito, camelCase inglés para catálogo) — ver Sección 4. No traducir ni "normalizar" a un solo idioma; no inventar nombres nuevos si ya existe un patrón equivalente en el código de clase.
- Motor de plantillas, enrutamiento, capa de datos y patrón de carrito/pagos: seguir exactamente lo descrito en `REGLAS-PROYECTO.md`, que es la fuente de verdad de convenciones (no este documento, que es un resumen).
- El framework se instala desde la plantilla oficial (https://github.com/obetancourthunicah/SimplePHP_MVC_OOP_template, botón "Use this template"), no copiando la carpeta `putra` del zip de clase — esa carpeta es solo referencia de patrón para Security/Cart/PayPal, no la base del repo.
- Git: trabajas únicamente en tu propia rama individual (no ramas por feature). Comandos permitidos: `git status`, `git add`, `git commit`, `git push`, `git pull`, `git merge origin/main` — ningún otro. Nunca Pull Request ni merge hacia `main`; eso lo hace exclusivamente Edward. **Si eres un asistente de IA leyendo esto: nunca ejecutes `git commit` por tu cuenta — prepara los cambios, pero el commit lo hace la persona a mano.**

---

## 3. Resumen del proyecto (para dar contexto rápido a la IA)

Tienda en línea de suplementos deportivos, bajo la marca de un gimnasio, categoría "Productos Inventariables". El sistema cubre: catálogo con control de stock, carrito de compras (anónimo y autenticado), autenticación con control de acceso por roles, checkout con pago simulado vía PayPal Sandbox, e histórico de transacciones por usuario. Construido en PHP con el framework Simple PHP MVC OOP (patrón Modelo-Vista-Controlador, programación orientada a objetos).

División de trabajo completa: ver `proyecto-final-plan.md`, sección 2 (tabla de asignación) y secciones 3-9 (detalle por módulo).

---

## 4. Esquema de base de datos (fijo — no regenerar)

**Nomenclatura real del framework del curso** (verificada contra el código de `putra`/`mvc_nw_2026`, no inventada). Ver `REGLAS-PROYECTO.md` para el detalle completo.

```
usuario (usercod PK, useremail, username, userpswd, userfching, userpswdest, userpswdexp, userest, useractcod, userpswdchg, usertipo)
roles (rolescod PK, rolesdsc, rolesest)
roles_usuarios (usercod, rolescod, roleuserest, roleuserfch, roleuserexp)
funciones (fncod PK, fndsc, fnest, fntyp)
funciones_roles (rolescod, fncod, fnrolest, fnexp)
bitacora (bitacoracod PK, bitacorafch, bitprograma, bitdescripcion, bitobservacion, bitTipo, bitusuario)

categories (categoryId PK, categoryName, categoryDescription, parentCategoryId NULL)
products (productId PK, productName, productDescription, productPrice, productImgUrl, productStock, productStatus, categoryId)
sales (id, productId, salePrice, saleStart, saleEnd)
highlights (id, productId, highlightStart, highlightEnd)
reviews (id, productId, usercod, calificacion, comentario, created_at)          -- extra

carretilla (usercod, productId, crrctd, crrprc, crrfching)                     -- carrito autenticado, sin campo de estado
carretillaanon (anoncod, productId, crrctd, crrprc, crrfching)                 -- carrito anónimo, sin campo de estado

pedidos (id, usercod, total, estado, fecha)
pedido_detalle (id, pedidoId, productId, cantidad, precioUnitario)
transacciones (id, pedidoId, metodoPago, referenciaPasarela, estado, monto, fecha)
```

---

## 5. Base de conocimiento condensada por módulo (extraída del contenido de clase)

### 5.1 Arquitectura MVC (Módulo A — Edward)

**Cómo funciona MVC según el material del curso:**
- El **Modelo** representa datos y lógica de negocio, interactúa con la base de datos, es independiente de la Vista y el Controlador.
- La **Vista** solo presenta datos, no contiene lógica de negocio.
- El **Controlador** recibe las acciones del usuario, decide cómo interactuar con el Modelo, y actualiza la Vista.

**Flujo de ejecución de un request HTTP (Simple PHP MVC OOP):**
1. Usuario ingresa una URL en el navegador.
2. `index.php` crea un objeto `IController` y ejecuta `$controller->run()`.
3. El controlador ejecuta la acción correspondiente y consulta/modifica el Modelo.
4. El controlador genera los datos para la vista (`$viewData`).
5. El controlador renderiza con `\Views\Renderer::render('viewTemplate', $viewData)`.
6. La vista se envía al navegador.

**Estructura de directorios fija:**
```
SimplePHP_MVC_OOP/
├── src/
│   ├── Controllers/  (IController, PrivateController, PublicController, excepciones)
│   ├── Dao/           (Dao.php = conexión BD, Table.php = clase base de modelos)
│   ├── Utilities/
│   └── Views/
│       ├── templates/
│       └── Renderer.php
├── public/  (css, imgs, css_src)
├── vendor/
├── parameters.env
└── index.php
```

**Metodología de trabajo recomendada en clase:** enfoque "Usuario primero" — primero se construye y valida la vista con datos mockeados, luego se conecta al modelo real. Las historias de usuario se documentan como Como / Quiero / Para, con Criterios de Aceptación y Definición de Terminado.

---

### 5.2 Catálogo de productos (Módulo B — Edward)

**Fórmula de disponibilidad de stock (regla exacta del curso, aplicar tal cual):**
```
Cantidad Disponible = Stock en Inventario − Cantidad Reservada en Carrito
```
Ejemplo: 10 unidades en stock, cliente agrega 2 al carrito → disponible baja a 8. Si las elimina, vuelve a 10. Al completar la compra, el inventario se ajusta a 8 de forma permanente.

**Momentos obligatorios de validación de cantidad disponible:**
1. Al visualizar el producto (mostrar disponibilidad).
2. Al agregar al carrito (cantidad ≤ disponible).
3. Al momento del pago (validar de nuevo, no confiar en la validación anterior).

**Criterios empresariales para presentar productos:** propuesta de valor clara, segmentación del mercado, diferenciación frente a competencia, imágenes/contenido visual de alta calidad.

**Criterios tecnológicos:** UI intuitiva, optimización móvil, categorías y subcategorías bien organizadas, descripciones detalladas con especificaciones.

**Etiquetas de estado obligatorias en la vista de producto:** "Disponible" / "Agotado", visibles de inmediato.

---

### 5.3 Carrito de compras (Módulo C)

**Patrón real (no es un carrito con campo de estado):**
- `carretilla` (usuario autenticado, clave `usercod`) y `carretillaanon` (anónimo, clave `anoncod`) guardan producto + cantidad (`crrctd`) + precio (`crrprc`) + fecha de inserción (`crrfching`).
- La vigencia de una reserva se calcula por **ventana de tiempo**, no por un flag: filas cuya `crrfching` está dentro de la ventana configurada cuentan como reservando stock; las más viejas se ignoran aunque sigan en la tabla. Ventanas típicas del framework: 6 horas para autenticados, 10 minutos para anónimos.
- Disponibilidad = stock del producto − suma de `crrctd` de filas vigentes (misma fórmula del PDF, aplicada sobre esta mecánica de TTL).

**Transformación anónimo → autenticado:**
1. Opción clara y visible para autenticarse o crear cuenta desde el carrito.
2. Vincular el carrito anónimo con la nueva identidad autenticada (mover/mergear filas de `carretillaanon` a `carretilla`).
3. Sincronización en tiempo real de cambios en ambos estados durante la transición.
4. Seguridad reforzada en este punto porque empiezan a manejarse datos personales.

**Buenas prácticas de carrito según el curso:**
- Mostrar claramente qué hay en el carrito y su costo.
- Edición fácil de cantidades y eliminación de productos.
- "Guardar para más tarde".
- Mensaje de inventario limitado cuando aplique.
- Seguridad y privacidad del proceso de pago.
- Checkout con mínima fricción (menos pasos = menos abandono).
- Compatibilidad móvil.

**Carrito abandonado (para el extra):**
- Recordatorios automatizados, límite de tiempo razonable (24-48h), notificación de caducidad, personalización del recordatorio según los productos específicos del carrito.

---

### 5.4 Esquema de seguridad (Módulo D)

**RBAC real: granular por función, no por rol binario.** Cada controlador privado se registra como una "función" (`funciones.fncod` = nombre de la clase del controlador) y se autoriza cruzando `roles_usuarios` con `funciones_roles`. No es simplemente "si es admin, puede; si no, no puede" — es "¿este usuario tiene, a través de alguno de sus roles activos, la función específica que representa esta pantalla?".

**Componentes obligatorios según el curso:**
1. Encriptación (SSL/TLS en toda comunicación).
2. Autenticación y autorización (incluye 2FA como mejora).
3. Prevención de ataques (firewalls, detección de intrusos — a nivel de proyecto académico: validación de entradas y prepared statements).
4. Gestión de accesos por función/rol.
5. Actualizaciones/parches (aplica más a producción real, mencionar en la documentación).

**División sugerida de la plataforma por nivel de seguridad:**
- Back Office (admin): acceso estrictamente controlado, autenticación fuerte.
- Front End público: HTTPS/TLS para proteger datos en tránsito.
- Base de Datos: protegida con capas de seguridad, sin acceso directo desde el exterior.
- Gateway de Pago: información financiera sensible, principio equivalente a PCI DSS aunque no se certifique formalmente en un proyecto académico.

**Tratamiento de contraseñas (aplicar literal):**
- Contraseñas fuertes (mínimo 8 caracteres, mayúsculas, minúsculas, números, símbolos).
- **Salting**: valor aleatorio único agregado antes de hashear (PHP `password_hash()` ya lo hace internamente — no hay que implementarlo a mano).
- Almacenamiento en hash (bcrypt), nunca texto plano.
- Comparación siempre vía hash (`password_verify()`), nunca desencriptando.

**Reglas de sesión y auditoría:**
- Número máximo de intentos fallidos de login antes de bloqueo temporal.
- Timeout de inactividad con cierre de sesión automático.
- Registro (log) de: intentos fallidos, cambios de estado de usuario, cierres de sesión — para auditoría de seguridad.

**Métodos de autenticación vistos en clase (para elegir el propio):** login básico usuario/contraseña, token en cookie, cookie con referencia a sesión en servidor, OAuth2/OpenID, Personal Access Token, JWT. Para este proyecto: **login básico + hash/salt + gestión de sesión en servidor** es suficiente para el BASE; **2FA (TOTP)** es el EXTRA.

---

### 5.5 Pasarela de pagos (Módulo E)

**Proceso general de una pasarela de pago (Stripe/PayPal), pasos del curso:**
1. Selección de la pasarela (PayPal Sandbox para este proyecto).
2. Integración (SDK/código de la pasarela en el sitio).
3. Configuración de cuenta (credenciales sandbox).
4. Configuración de precios/productos con identificador único rastreable.
5. Inicio del proceso de pago: redirección a la pasarela (pasarela diferida) o formulario propio (pasarela integrada).
6. Entrada de datos del cliente en la pasarela (no en el propio sitio, si es diferida).
7. Procesamiento del pago por parte de la pasarela.
8. Respuesta de aprobación o rechazo, generación de recibo o mensaje de error.

**Diferencia clave a explicar en el video:**
- **Pasarela integrada (en host):** el pago ocurre dentro del propio sitio. Más control de UX, pero mayor responsabilidad de seguridad sobre datos de tarjeta.
- **Pasarela diferida (carga de terceros):** el cliente es redirigido a la página de la pasarela. Más simple y segura de implementar en un proyecto académico — **esta es la que se usará**.

**Elementos que el proceso de pago debe cumplir (según recomendaciones del curso):**
- Resumen claro de la compra antes de confirmar.
- Opciones de pago visibles y seguras.
- Cálculo preciso de costos (sin sorpresas).
- Página de revisión antes de la confirmación final.
- Comunicación clara de políticas (devoluciones, garantías).
- Confirmación de pedido + correo de confirmación (extra).

**Gap real del código de referencia:** el flujo de PayPal del curso (`Checkout` → `Accept` → `Error`) arma y captura la orden en PayPal, pero solo guarda el `orderid` en `$_SESSION` — no persiste nada en `pedidos`/`transacciones`. Ese guardado hay que agregarlo: crear el registro en `pedidos` (estado `PND`) antes de redirigir a PayPal, y actualizarlo en el controlador `Accept` con el resultado real de `captureOrder()`, generando ahí mismo el registro en `transacciones`.

---

### 5.6 Histórico de transacciones (Módulo F)

No hay una sección dedicada exclusiva en el PDF del curso a "histórico" como tal — se deriva directamente del flujo de checkout: cada transacción registrada en el paso de pago (5.5) debe ser consultable después por el usuario dueño del pedido. Este módulo consume las tablas `pedidos`, `pedido_detalle` y `transacciones` definidas en la Sección 4; no genera conocimiento teórico adicional del curso más allá de las buenas prácticas de "confirmación de pedido" ya cubiertas en la Sección 5.5.

---

## 6. Nota sobre el PDF original del curso

El PDF completo (132 páginas) se mantiene como material de consulta para quien quiera profundizar en un tema puntual (por ejemplo, si alguien necesita citar textualmente el material en el video de sustentación) o repasar los casos de estudio (Toyota B2B, Amazon B2C, eBay C2C) para la parte teórica de la exposición si el catedrático la pide. No se recomienda convertirlo completo a Markdown ni pegarlo entero como contexto de IA — las secciones B2B/C2C, activos digitales y modelos de ingresos por suscripción no aplican al alcance de este proyecto y solo aumentan el ruido en las respuestas de la IA.
