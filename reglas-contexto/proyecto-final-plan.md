# Proyecto Final — Negocios Web
## Tienda de Suplementos (contexto: Gimnasio) — Categoría: Productos Inventariables
### Documento de planificación técnica y asignación de responsabilidades

**Framework base:** Simple PHP MVC OOP
**Repositorio:** GitHub público
**Equipo:** 6 integrantes

Ver también `REGLAS-PROYECTO.md` (convenciones de código, obligatorio leerlo antes de escribir la primera línea) y `CONTEXTO-IA.md` (para pegar en herramientas de IA).

---

## 1. Alcance del proyecto

El sistema es una tienda en línea de suplementos deportivos, operada bajo la marca de un gimnasio, bajo el modelo de **Productos Inventariables**. El sistema NO incluirá reservas de clases ni gestión de cupos del gimnasio — eso pertenece a la categoría "Servicio con capacidad instalada limitada" y está fuera del alcance para evitar duplicar lógica de negocio que la rúbrica no exige.

El proyecto cubre, de punta a punta: catálogo de productos, carrito de compras, autenticación y control de acceso, pasarela de pago simulada (PayPal Sandbox), histórico de transacciones por usuario, y todos los entregables administrativos (repo público, dump de base de datos, archivo de integrantes, video de sustentación).

---

## 2. División de responsabilidades — Resumen

| # | Integrante | Módulo(s) | Criterio de evaluación que cubre |
|---|---|---|---|
| 1 | Edward | **A.** Arquitectura MVC + **B.** Catálogo | Uso de MVC (20 pts) + parte de Catálogo/Carrito (20 pts) |
| 2 | Compañero/a 2 | **C.** Carrito de compras | Parte de Catálogo/Carrito (20 pts) |
| 3 | Compañero/a 3 | **D.** Esquema de seguridad | Esquema de Seguridad (20 pts) |
| 4 | Compañero/a 4 | **E.** Pasarela de pagos | Pasarela de Pagos (20 pts) |
| 5 | Compañero/a 5 | **F.** Histórico de transacciones | Histórico de Transacciones (10 pts) |
| 6 | Compañero/a 6 | **G.** QA, integración, DevOps, documentación y video | Presentación en vivo (10 pts) + soporte transversal a todos los criterios |

Cada módulo se detalla a continuación con: objetivo, features mínimas (BASE), features de valor agregado (EXTRA), resultado esperado, dependencias con otros módulos y tablas de base de datos que le pertenecen.

---

## 3. Módulo A — Arquitectura MVC
**Responsable: Edward**

### Objetivo
Levantar el esqueleto del framework Simple PHP MVC OOP, dejarlo funcional, y ser el punto de integración de todo lo que produzcan los otros 5 módulos (Edward es el único que mergea hacia `main`, ver `REGLAS-PROYECTO.md` sección 9).

### Features BASE
1. Crear el repositorio usando el botón "Use this template" en https://github.com/obetancourthunicah/SimplePHP_MVC_OOP_template, ejecutar `composer install`, configurar `parameters.env` (incluyendo `BASE_DIR` y credenciales de BD fuera del control de versiones). Ver `REGLAS-PROYECTO.md` sección 0 — no usar la carpeta `putra` del zip como base del repo, es solo referencia de patrón.
2. Implementar `IController`, `PublicController` y `PrivateController`, incluyendo el manejo real de `PrivateNoAuthException` y `PrivateNoLoggedException` (no solo declararlas — deben lanzarse y capturarse correctamente).
3. Definir el `Dao`/`Table` base genérico con métodos CRUD reutilizables (`obtenerRegistros`, `obtenerUnRegistro`, `executeNonQuery` — ver `REGLAS-PROYECTO.md` sección 4) que el resto de Daos específicos (Products, Cart/Carretilla, Pedidos, etc.) van a extender.
4. Configurar `Renderer` y la carpeta `templates` con una estructura de layout compartido (header, footer, nav) para que todas las vistas de los demás módulos hereden el mismo look & feel sin duplicar HTML.
5. Landing page funcional según la historia de usuario del material del curso: diseño atractivo, navegación clara, sección de destacados/novedades y "Ofertas del Día" (con datos mockeados inicialmente, luego conectados al catálogo real).
6. Diseño responsive/mobile-first desde el layout base, para que todos los módulos lo hereden gratis.
7. Definir y documentar en el README el flujo de trabajo de Git: rama individual por persona (no por feature), commits manuales dentro de la propia rama, y todo merge hacia `main` pasa exclusivamente por Edward (ver `REGLAS-PROYECTO.md` sección 9 para el detalle completo, incluyendo los comandos de Git permitidos).
8. Diseñar y publicar el **esquema completo de base de datos** (ver sección 9) antes de que el resto del equipo empiece a codear sus módulos — esto es la dependencia crítica de la que dependen los 5 compañeros restantes.

### Features EXTRA (para sobresalir)
- **Dashboard administrativo** con métricas: productos más vendidos, ventas por día/semana, alertas de stock bajo. Se alimenta de datos que ya existen en `pedidos`/`pedido_detalle` (módulo E y F), usando Chart.js para las gráficas.
- **Manejo centralizado de errores** (página 404/500 personalizada, logging de excepciones no controladas) para que la demo en vivo no se caiga con un error crudo de PHP frente al catedrático.

### Resultado esperado
Un repositorio corriendo desde `index.php`, con landing page funcional, estructura de carpetas ya nombrada y lista para que los 5 compañeros trabajen en paralelo sin pisarse, y un dashboard admin operativo como diferenciador.

### Dependencias
- Ninguna hacia adentro (es la base). Todos los demás módulos dependen de que este módulo entregue el esqueleto y el esquema de BD antes de poder avanzar.
- Coordinación directa y constante con el Módulo D (Seguridad), porque `PrivateController` y el manejo de sesión son responsabilidad compartida.

### Tablas de BD que le pertenecen
Ninguna tabla de negocio propia — es dueño de la infraestructura (`Dao.php`, `Table.php`) que todos los demás Daos usan.

---

## 4. Módulo B — Catálogo de Productos
**Responsable: Edward**

### Objetivo
Construir el catálogo completo de suplementos: administración de productos, navegación por categorías, búsqueda, y visualización clara de disponibilidad de stock.

### Features BASE
1. CRUD de productos desde un backoffice restringido a rol `admin` (crear, editar, desactivar producto — no eliminar físicamente, solo cambiar estado).
2. Tabla `categories` con soporte de subcategorías (campo `parentCategoryId`), por ejemplo: Proteínas → Whey, Vegana, Caseína.
3. Ficha de producto individual: imágenes, descripción, precio, stock disponible, categoría, estado visible (`Disponible` / `Agotado`) según lo visto en el material del curso.
4. Listado de catálogo con paginación, filtro por categoría y por rango de precio.
5. Buscador por nombre/texto libre.
6. Sección "Ofertas del Día" y "Destacados/Novedades" en la landing, conectada a datos reales mediante las tablas `sales` (rango de fecha de oferta con `salePrice`) y `highlights` (rango de fecha de producto destacado) — este patrón ya está resuelto en tu proyecto de práctica (`mvc_nw_2026`), reutilízalo tal cual en vez de rehacerlo.
7. Manejo correcto de disponibilidad: si el stock llega a 0, el producto se marca automáticamente como `Agotado` y se bloquea la opción de agregar al carrito desde la vista.
8. Diseño responsive de las tarjetas de producto y de la ficha individual.

### Features EXTRA (para sobresalir)
- **Sistema de reseñas y calificación (1-5 estrellas + comentario)**, habilitado únicamente para usuarios que ya compraron ese producto específico (se valida contra `pedido_detalle` del módulo E/F). Esto demuestra dominio de integridad referencial, no solo un CRUD más.
- **Alertas de stock bajo** visibles en el backoffice (ligado al dashboard del Módulo A).

### Resultado esperado
Un catálogo navegable, filtrable y con administración funcional desde el backoffice, con disponibilidad de stock reflejada en tiempo real y reseñas verificadas como diferenciador.

### Dependencias
- Depende del esqueleto y del `Dao` base del Módulo A.
- El Módulo C (Carrito) depende de que este módulo exponga correctamente el stock disponible por producto.
- El Módulo F depende de este módulo para poder validar reseñas contra compras reales.

### Tablas de BD que le pertenecen
`products`, `categories`, `sales`, `highlights`, y `reviews` si se implementa el extra.

---

## 5. Módulo C — Carrito de Compras
**Responsable: Compañero/a 2**

### Objetivo
Implementar un carrito de compras robusto que funcione tanto para visitantes anónimos como para usuarios autenticados, con validación real de inventario.

### Features BASE
1. Carrito anónimo persistido en la tabla `carretillaanon` (identificado por `anoncod`, no `session_id` genérico — sigue el patrón exacto del framework, ver `REGLAS-PROYECTO.md` sección 7), y carrito autenticado en `carretilla` (identificado por `usercod`).
2. **Importante**: este framework no usa un campo de "estado" para saber si una fila del carrito sigue vigente — usa una ventana de tiempo (TTL) sobre `crrfching`. Implementa `CartFns::getAuthTimeDelta()` / `::getUnAuthTimeDelta()` tal como están, no inventes un campo `activo`/`expirado` en la tabla.
3. Conversión automática de carrito anónimo a carrito autenticado en el momento del login, haciendo *merge* de los items sin duplicar productos ya existentes en el carrito del usuario.
4. Agregar producto al carrito, editar cantidad, eliminar producto, ver subtotal actualizado en tiempo real (AJAX o recarga parcial, según lo que permita el framework).
5. Opción "Guardar para más tarde" (mover item del carrito a una lista de deseos simple).
6. **Validación de stock en dos momentos obligatorios**: (a) al momento de agregar al carrito, y (b) otra vez justo antes de confirmar el checkout — para evitar el escenario de sobreventa descrito en el caso de estudio del supermercado visto en clase.
7. Cálculo de totales incluyendo impuesto (ISV 15% Honduras) y cualquier cargo simulado de envío.
8. Mensaje claro cuando un producto en el carrito tiene inventario limitado o cambió de precio/disponibilidad desde que se agregó.
9. Página de resumen de carrito con opción de continuar comprando o proceder al checkout.

### Features EXTRA (para sobresalir)
- **Recordatorio de carrito abandonado**: un proceso (cron simple o verificación al iniciar sesión) que marca carritos inactivos por más de 24 horas y muestra un banner in-app ("Tienes productos esperando en tu carrito") la próxima vez que el usuario visita el sitio. No requiere infraestructura de correo real para cumplir el objetivo pedagógico.

### Resultado esperado
Un carrito que no pierde datos al recargar, que maneja correctamente la transición anónimo→autenticado, y que nunca permite comprar más unidades de las que hay en stock.

### Dependencias
- Depende de que el Módulo B exponga el stock actualizado de cada producto.
- El Módulo E (Pagos) depende de que este módulo entregue un carrito validado y con totales correctos al momento del checkout.
- Depende del manejo de sesión que define el Módulo D.

### Tablas de BD que le pertenecen
`carretilla` (autenticado), `carretillaanon` (anónimo). Ver `REGLAS-PROYECTO.md` sección 7 — este carrito no usa una tabla de estado, usa ventana de tiempo (TTL).

---

## 6. Módulo D — Esquema de Seguridad
**Responsable: Compañero/a 3**

### Objetivo
Garantizar que la autenticación, autorización y manejo de credenciales sigan las mejores prácticas vistas en clase, y que el acceso al backoffice esté correctamente restringido por rol.

### Features BASE
1. Registro y login de usuarios con contraseñas almacenadas con **hash + salt** (usar `password_hash()` / `password_verify()` de PHP — no reinventar el algoritmo de hashing).
2. Comparación de contraseñas siempre vía hash, nunca en texto plano ni en logs.
3. **RBAC granular por función** (no un simple flag cliente/admin): cada controlador privado se registra como una "función" en la tabla `funciones` y se autoriza contra `funciones_roles`/`roles_usuarios` — sigue el patrón exacto de `Security::isAuthorized()` (ver `REGLAS-PROYECTO.md` sección 5). El `PrivateController` del Módulo A ya invoca esta verificación en su constructor.
4. Regeneración del `session_id` inmediatamente después de un login exitoso (previene session fixation).
5. Timeout de sesión por inactividad configurable.
6. **Prepared statements en absolutamente todas las queries** del sistema (auditar también los Daos de los otros módulos, no solo el propio).
7. Bloqueo temporal de cuenta tras un número definido de intentos fallidos de login, con registro de cada intento en una tabla de auditoría.
8. Reglas de contraseña: longitud mínima (8 caracteres), combinación de mayúsculas/minúsculas/números, validadas tanto en frontend como en backend.
9. Separación clara de rutas: todo lo de backoffice bajo un prefijo/controlador controlado, front público en otro namespace.

### Features EXTRA (para sobresalir)
- **Autenticación de doble factor (2FA / TOTP)** para el login del rol `admin` exclusivamente (Google Authenticator compatible), aplicando el contenido de MFA visto en el material del curso, sin agregar fricción al flujo de compra del cliente regular.

### Resultado esperado
Ningún endpoint de backoffice accesible sin sesión válida y rol correcto; contraseñas irreversibles en la base de datos; y un registro auditable de intentos de acceso sospechosos.

### Dependencias
- Trabaja en conjunto directo con el Módulo A (comparten `PrivateController` y manejo de sesión).
- Todos los demás módulos dependen de que este entregue el modelo de `usuario` y roles tempranamente, ya que `pedidos`, `carretilla` y `reviews` referencian `usercod`.

### Tablas de BD que le pertenecen
`usuario`, `roles`, `roles_usuarios`, `funciones`, `funciones_roles`, `bitacora` (y `two_factor_secrets` si se implementa el extra de 2FA).

---

## 7. Módulo E — Pasarela de Pagos
**Responsable: Compañero/a 4**

### Objetivo
Simular un proceso de pago real usando el sandbox de PayPal, dejando registrada cada transacción de forma consistente e idempotente.

### Features BASE
1. Integración con **PayPal Sandbox** en modalidad diferida (el cliente es redirigido a PayPal para ingresar sus datos — no se captura número de tarjeta en el propio sitio, lo cual simplifica enormemente la defensa del criterio de seguridad frente al catedrático).
2. Flujo completo: al confirmar checkout se crea un registro en `pedidos` con estado `PND` (pendiente, usando los códigos de 3 letras de `REGLAS-PROYECTO.md` sección 1.3) → redirección a PayPal → captura del resultado (aprobado / rechazado / cancelado) vía callback/retorno → actualización del estado del pedido → creación del registro correspondiente en `transacciones`. **Nota:** el código de referencia del curso arma y captura la orden en PayPal pero no guarda nada en base de datos — este paso de persistencia lo agregan ustedes sobre ese mismo flujo (ver `REGLAS-PROYECTO.md` sección 6).
3. **Idempotencia**: si el usuario recarga la página de confirmación o PayPal reintenta el callback, no debe generarse una transacción ni una orden duplicada.
4. Pantalla de confirmación de compra con número de orden, resumen de productos y monto total.
5. Manejo explícito del caso de pago rechazado o cancelado, devolviendo al usuario a un estado consistente (el carrito no debe vaciarse si el pago falla).
6. Cálculo correcto y consistente entre el total mostrado en el carrito y el monto enviado a PayPal (evitar discrepancias por redondeo).

### Features EXTRA (para sobresalir)
- **Email de confirmación de compra** vía PHPMailer + SMTP (Gmail o Mailtrap para ambiente de pruebas), enviando el detalle de la orden justo después de un pago aprobado — es una práctica explícitamente mencionada en el material del curso como mejora de la experiencia de pago.

### Resultado esperado
Un checkout que termina en una transacción registrada y trazable, sin duplicados, con manejo correcto de los tres desenlaces posibles (aprobado/rechazado/cancelado).

### Dependencias
- Depende de que el Módulo C entregue un carrito ya validado con totales correctos.
- El Módulo F depende de las tablas `pedidos`/`transacciones` que este módulo genera.

### Tablas de BD que le pertenecen
`pedidos`, `pedido_detalle`, `transacciones`. Ninguna de estas existe en el código de referencia — este módulo debe crearlas (ver `REGLAS-PROYECTO.md` sección 6, el flujo de PayPal del curso no persiste nada por sí solo).

---

## 8. Módulo F — Histórico de Transacciones
**Responsable: Compañero/a 5**

### Objetivo
Dar a cada usuario visibilidad completa de su historial de compras, y a los administradores una vista consolidada de todas las transacciones del sistema.

### Features BASE
1. Vista de usuario autenticado con el listado de sus órdenes: fecha, productos, monto total y estado (pendiente/aprobado/rechazado).
2. Vista de detalle de cada orden individual, con desglose línea por línea (producto, cantidad, precio unitario, subtotal).
3. Ordenamiento del historial por fecha (más reciente primero) con paginación si la lista crece.
4. Manejo correcto de estados vacíos ("Aún no tienes compras registradas") sin errores de UI.

### Features EXTRA (para sobresalir)
- **Exportación del historial personal a PDF o CSV** desde la vista de usuario.
- **Vista administrativa de todas las transacciones del sistema**, con filtros por fecha, estado y usuario — esta vista se puede compartir/conectar con el dashboard del Módulo A para no duplicar trabajo.

### Resultado esperado
Cualquier usuario puede ver y auditar su propio historial de compras sin ayuda de un administrador, y el equipo tiene una vista centralizada para verificar transacciones durante la demo en vivo.

### Dependencias
- Depende directamente de las tablas `pedidos`, `pedido_detalle` y `transacciones` que produce el Módulo E.
- Su extra de vista administrativa se coordina con el dashboard del Módulo A para evitar construir dos paneles distintos con la misma información.

### Tablas de BD que le pertenecen
No genera tablas propias — consume `pedidos`, `pedido_detalle`, `transacciones` (solo lectura).

---

## 9. Módulo G — QA, Integración, DevOps, Documentación y Video
**Responsable: Compañero/a 6**

Este rol no es "el que sobra" — es el que garantiza que los otros 5 módulos realmente funcionen juntos y que el equipo no pierda puntos por entregables administrativos incompletos (que sí están en la rúbrica del enunciado, aunque no tengan puntaje propio de criterio técnico, su ausencia puede invalidar la entrega completa).

### Features BASE
1. **Pruebas de flujo completo end-to-end**: registro → login → navegar catálogo → agregar al carrito → checkout → pago → ver historial. Ejecutar este flujo después de cada integración grande y documentar bugs encontrados en issues de GitHub.
2. **Apoyar a Edward en la gestión del flujo de Git**: recordar a los compañeros que solo pueden commitear dentro de su propia rama (nunca PR ni merge hacia `main`), y ayudar a detectar conflictos entre módulos antes de que lleguen a Edward para integrar (especialmente entre A/D que comparten `PrivateController`, y entre C/E que comparten el flujo de checkout).
3. Generar el **script/dump de la base de datos** (export completo de estructura y, si se pide, datos de prueba) para el entregable final.
4. Redactar y mantener actualizado el **README** del repositorio (instrucciones de instalación, variables de entorno, estructura del proyecto).
5. Crear el archivo `.txt` con nombres completos y números de cuenta de los 6 integrantes.
6. Coordinar la grabación del **video de sustentación** (máximo 15 minutos: 10 min repartidos entre los 6 mostrando su criterio de evaluación, 5 min de funcionamiento en vivo), incluyendo guion/orden de intervención y edición final para subir a YouTube o Vimeo en modo público.
7. Verificar antes de la entrega que el repositorio de GitHub sea efectivamente público y accesible sin necesidad de invitación.
8. Verificar consistencia de nombres de tabla entre scripts SQL y Daos antes de dar por cerrado cada módulo — el propio código de referencia del curso trae un typo real (`carretillaanon` en el script vs `carretillaanom` en el Dao); confirmar que el Módulo C no heredó ese mismo error.

### Herramienta recomendada
Existe un generador de scaffolding en el proyecto de práctica de Edward (`Controllers/Generator/Generator.php`) que crea Controller + Dao + Vista base a partir de la estructura de cualquier tabla (`DESC tabla`). Cualquier módulo que necesite arrancar un CRUD nuevo debería usarlo primero en vez de copiar/pegar boilerplate a mano.

### Features EXTRA (para sobresalir)
- **Suite de pruebas automatizadas mínima** (aunque sea con PHPUnit para 3-5 casos críticos: hash de contraseña, validación de stock en carrito, cálculo de totales) — pocos equipos en un curso de este nivel entregan pruebas automatizadas reales, y es un diferenciador fácil de defender frente al catedrático.
- **Checklist de seguridad pre-entrega**: recorrido manual verificando que no haya credenciales hardcodeadas, que `.env` esté en `.gitignore`, que no haya rutas de admin accesibles sin autenticación (probando manualmente con URLs directas).

### Resultado esperado
Un repositorio íntegro, documentado, con historial de Git limpio, base de datos exportable, entregables administrativos completos, y un video de sustentación bien editado y dentro del tiempo permitido.

### Dependencias
- Depende de que los 5 módulos técnicos avancen para poder probarlos.
- Coordina directamente con todos los demás para el guion del video.

### Tablas de BD que le pertenecen
Ninguna — su output es el dump completo del esquema ya construido por los demás.

---

## 10. Esquema de base de datos consolidado

**Actualizado tras revisar el código real de clase (`putra` / `mvc_nw_2026`).** Ver `REGLAS-PROYECTO.md` sección 10 para el detalle de qué cambió y por qué.

```
-- Seguridad (nomenclatura exacta del framework del curso)
usuario (usercod PK, useremail, username, userpswd, userfching, userpswdest, userpswdexp, userest, useractcod, userpswdchg, usertipo)
roles (rolescod PK, rolesdsc, rolesest)
roles_usuarios (usercod, rolescod, roleuserest, roleuserfch, roleuserexp)
funciones (fncod PK, fndsc, fnest, fntyp)
funciones_roles (rolescod, fncod, fnrolest, fnexp)
bitacora (bitacoracod PK, bitacorafch, bitprograma, bitdescripcion, bitobservacion, bitTipo, bitusuario)
two_factor_secrets (id, usercod, secret, activado)                              -- extra Módulo D

-- Catálogo
categories (categoryId PK, categoryName, categoryDescription, parentCategoryId NULL)
products (productId PK, productName, productDescription, productPrice, productImgUrl, productStock, productStatus, categoryId)
sales (id, productId, salePrice, saleStart, saleEnd)                            -- ofertas del día
highlights (id, productId, highlightStart, highlightEnd)                        -- destacados
reviews (id, productId, usercod, calificacion, comentario, created_at)          -- extra Módulo B

-- Carrito (patrón TTL, sin campo de estado — ver reglas sección 7)
carretilla (usercod, productId, crrctd, crrprc, crrfching)                      -- carrito autenticado
carretillaanon (anoncod, productId, crrctd, crrprc, crrfching)                  -- carrito anónimo

-- Órdenes y pagos (NO existen en el código de referencia — las crea el Módulo E, ver reglas sección 6)
pedidos (id, usercod, total, estado, fecha)
pedido_detalle (id, pedidoId, productId, cantidad, precioUnitario)
transacciones (id, pedidoId, metodoPago, referenciaPasarela, estado, monto, fecha)
```


---

## 11. Tabla final — Requisitos MÍNIMOS (BASE) por módulo

| Módulo | Responsable | Requisito mínimo |
|---|---|---|
| A | Edward | Esqueleto MVC funcional (`IController`, `PublicController`, `PrivateController`, excepciones reales) |
| A | Edward | `Dao`/`Table` base genérico reutilizable por todos los módulos |
| A | Edward | `Renderer` + layout compartido (header/footer/nav) |
| A | Edward | Landing page con destacados y ofertas del día |
| A | Edward | Diseño responsive/mobile-first en el layout base |
| A | Edward | Flujo de Git documentado: ramas individuales por persona, todo merge hacia `main` pasa por Edward |
| A | Edward | Esquema completo de base de datos publicado antes de que el resto del equipo empiece a codear |
| B | Edward | CRUD de productos restringido a rol admin |
| B | Edward | Categorías y subcategorías |
| B | Edward | Ficha de producto con imágenes, precio, stock y estado |
| B | Edward | Listado con paginación, filtro por categoría y precio |
| B | Edward | Buscador por texto |
| B | Edward | Sección de destacados/ofertas conectada a datos reales |
| B | Edward | Marcado automático "Agotado" cuando stock = 0 |
| C | Compañero/a 2 | Carrito anónimo persistido en `carretillaanon` por `anoncod` |
| C | Compañero/a 2 | Conversión automática anónimo → autenticado sin duplicar items |
| C | Compañero/a 2 | Agregar/editar/eliminar items con subtotal en tiempo real |
| C | Compañero/a 2 | Opción "Guardar para más tarde" |
| C | Compañero/a 2 | Validación de stock al agregar y al hacer checkout |
| C | Compañero/a 2 | Cálculo de totales con impuesto y envío simulado |
| D | Compañero/a 3 | Registro/login con hash + salt (`password_hash`/`password_verify`) |
| D | Compañero/a 3 | RBAC granular por función (`funciones`/`roles_usuarios`/`funciones_roles`) validado en `PrivateController` |
| D | Compañero/a 3 | Regeneración de `session_id` tras login |
| D | Compañero/a 3 | Timeout de sesión por inactividad |
| D | Compañero/a 3 | Prepared statements en todas las queries del sistema |
| D | Compañero/a 3 | Bloqueo temporal tras intentos fallidos + registro en auditoría |
| D | Compañero/a 3 | Reglas de contraseña fuerte validadas en frontend y backend |
| E | Compañero/a 4 | Integración con PayPal Sandbox (modalidad diferida) |
| E | Compañero/a 4 | Flujo completo orden pendiente → pago → actualización de estado |
| E | Compañero/a 4 | Idempotencia (sin duplicar orden/transacción en recarga) |
| E | Compañero/a 4 | Pantalla de confirmación con número de orden y resumen |
| E | Compañero/a 4 | Manejo correcto de pago rechazado/cancelado |
| F | Compañero/a 5 | Vista de historial de órdenes por usuario autenticado |
| F | Compañero/a 5 | Detalle desglosado de cada orden |
| F | Compañero/a 5 | Ordenamiento por fecha con paginación |
| F | Compañero/a 5 | Manejo de estado vacío sin errores |
| G | Compañero/a 6 | Pruebas de flujo end-to-end documentadas |
| G | Compañero/a 6 | Gestión del flujo de Git y revisión de PRs |
| G | Compañero/a 6 | Dump/export de la base de datos |
| G | Compañero/a 6 | README completo del repositorio |
| G | Compañero/a 6 | Archivo `.txt` con integrantes y números de cuenta |
| G | Compañero/a 6 | Video de sustentación (≤15 min) publicado en modo público |
| G | Compañero/a 6 | Repositorio GitHub confirmado como público y accesible |

---

## 12. Tabla final — Requisitos EXTRA (para sobresalir) por módulo

| Módulo | Responsable | Feature extra |
|---|---|---|
| A | Edward | Dashboard administrativo con métricas (ventas por día, productos más vendidos, stock bajo) vía Chart.js |
| A | Edward | Manejo centralizado de errores (páginas 404/500 personalizadas + logging) |
| B | Edward | Sistema de reseñas y calificación (1-5 estrellas) validado contra compras reales |
| B | Edward | Alertas de stock bajo integradas al dashboard admin |
| C | Compañero/a 2 | Recordatorio de carrito abandonado (banner in-app tras 24h de inactividad) |
| D | Compañero/a 3 | Autenticación de doble factor (2FA / TOTP) exclusiva para el rol admin |
| E | Compañero/a 4 | Email de confirmación de compra vía PHPMailer + SMTP |
| F | Compañero/a 5 | Exportación del historial personal a PDF/CSV |
| F | Compañero/a 5 | Vista administrativa consolidada de todas las transacciones con filtros |
| G | Compañero/a 6 | Suite de pruebas automatizadas mínima (PHPUnit, 3-5 casos críticos) |
| G | Compañero/a 6 | Checklist de seguridad pre-entrega (credenciales, `.gitignore`, rutas admin) |

