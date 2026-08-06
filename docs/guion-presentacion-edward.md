# Guion de presentación — Edward (Módulo A + Módulo B)

**Duración estimada:** 2:30 - 3:00 min hablando a ritmo normal.

---

Buenas tardes, profesor, compañeros. Mi nombre es Edward y estuve a cargo de dos módulos del proyecto: la **Arquitectura MVC** del sistema completo, y el **Catálogo de Productos**.

Empezando por la arquitectura: BodyPerfect Suplementos está construido sobre el framework Simple PHP MVC OOP. Mi trabajo acá fue levantar el esqueleto que todo el equipo usó para trabajar en paralelo sin pisarse entre nosotros. Implementé el `IController` y las clases `PublicController` y `PrivateController`, con el manejo real de las excepciones de autorización — no solo declaradas, sino lanzadas y capturadas correctamente cuando alguien intenta entrar a una pantalla sin sesión activa o sin el rol correcto. También definí el `Dao` base genérico, con los métodos de CRUD reutilizables que después extendieron los Daos de Carrito, Pedidos e Historial. Y configuré el `Renderer` con la estructura de plantillas compartidas — header, footer, navegación — para que las vistas de los otros cinco módulos heredaran el mismo *look & feel* sin duplicar HTML.

Como parte de esto también diseñé y publiqué el esquema completo de base de datos antes de que el resto del equipo empezara a codear — esa era la dependencia crítica de la que dependían los demás cinco módulos — y definí el flujo de trabajo en Git: una rama por persona, y todo merge hacia `main` pasa por mí, para mantener el historial limpio y evitar conflictos.

Ahora, el segundo módulo: el **Catálogo de Productos**. Acá construí el CRUD completo de productos, restringido al rol administrador, con categorías y subcategorías — por ejemplo, Proteínas se divide en Whey, Vegana y Caseína. El catálogo público tiene paginación, filtro por categoría y por rango de precio, y buscador por texto libre. Cada producto muestra su disponibilidad en tiempo real: si el stock llega a cero, el sistema lo marca automáticamente como "Agotado" y bloquea la opción de agregarlo al carrito.

También conecté la landing page con datos reales: la sección de Destacados y Ofertas del Día no son datos de mentira — están conectadas a las tablas `highlights` y `sales`, con ventanas de fecha reales que definen cuándo un producto está destacado o en oferta.

Como valor agregado, además de lo mínimo pedido, construí un **dashboard administrativo** con gráficas de Chart.js — ingresos de los últimos 7 días, top de productos más vendidos y alertas de stock bajo — y un **sistema de reseñas** de 1 a 5 estrellas que solo se puede usar si el usuario realmente compró ese producto, validado contra su historial de pedidos.

Con esto le dejo la palabra a mi compañero/a, que va a hablar del módulo de Carrito de Compras.

---

## Notas para el orador
- Ajustá "compañero/a" al nombre real de quien sigue.
- Si el profesor pregunta por la BD: mencioná que el esquema es idempotente (`sql/schema.sql`), se puede correr sobre una base nueva o una ya existente sin romper nada.
- Si pregunta por seguridad del catálogo: el CRUD de productos valida el rol vía RBAC (`funciones`/`funciones_roles`) que define el Módulo D, no un flag simple de admin.
