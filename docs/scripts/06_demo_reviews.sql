-- Módulo B: Reseñas de ejemplo
-- Usa usuarios y productos ya existentes en la BD (no hardcodea IDs)
-- INSERT IGNORE omite si ya existe la combinación productId+usercod

USE ecommerce;

SET @u1 = (SELECT usercod FROM usuario ORDER BY usercod LIMIT 1);
SET @u2 = (SELECT usercod FROM usuario ORDER BY usercod LIMIT 1 OFFSET 1);
SET @u3 = (SELECT usercod FROM usuario ORDER BY usercod LIMIT 1 OFFSET 2);
SET @u4 = (SELECT usercod FROM usuario ORDER BY usercod LIMIT 1 OFFSET 3);

SET @p1 = (SELECT productId FROM products WHERE productStatus = 'ACT' ORDER BY productId LIMIT 1);
SET @p2 = (SELECT productId FROM products WHERE productStatus = 'ACT' ORDER BY productId LIMIT 1 OFFSET 1);
SET @p3 = (SELECT productId FROM products WHERE productStatus = 'ACT' ORDER BY productId LIMIT 1 OFFSET 2);
SET @p4 = (SELECT productId FROM products WHERE productStatus = 'ACT' ORDER BY productId LIMIT 1 OFFSET 3);
SET @p5 = (SELECT productId FROM products WHERE productStatus = 'ACT' ORDER BY productId LIMIT 1 OFFSET 4);
SET @p6 = (SELECT productId FROM products WHERE productStatus = 'ACT' ORDER BY productId LIMIT 1 OFFSET 5);

-- Reseñas: u1 comenta varios productos
INSERT IGNORE INTO reviews (productId, usercod, calificacion, comentario, created_at) VALUES
(@p1, @u1, 5, 'Increíble proteína, se mezcla perfectamente y el sabor es excelente. Noté ganancias musculares en 3 semanas.', '2026-06-10 09:15:00'),
(@p2, @u1, 4, 'Muy buena calidad, llega rápido y el empaque es seguro. La recomiendo para quienes empiezan.', '2026-06-18 14:30:00'),
(@p3, @u1, 5, 'Producto de primera, exactamente lo que buscaba. El precio es justo para la cantidad que trae.', '2026-07-02 11:00:00');

-- Reseñas: u2 comenta productos distintos
INSERT IGNORE INTO reviews (productId, usercod, calificacion, comentario, created_at) VALUES
(@p1, @u2, 4, 'Buen producto en general. El sabor podría mejorar un poco pero los resultados son reales.', '2026-06-25 08:45:00'),
(@p4, @u2, 5, 'Lo mejor que he comprado aquí. Energía constante durante el entrenamiento, sin crashes.', '2026-07-05 16:20:00'),
(@p5, @u2, 3, 'Cumple con lo prometido pero hay mejores opciones en el mercado. Igual lo volvería a comprar.', '2026-07-12 10:00:00');

-- Reseñas: u3
INSERT IGNORE INTO reviews (productId, usercod, calificacion, comentario, created_at) VALUES
(@p2, @u3, 5, 'Excelente servicio y producto de calidad. El stock siempre está disponible, muy buena tienda.', '2026-07-08 13:10:00'),
(@p3, @u3, 4, 'Buena relación calidad-precio. Lo uso hace dos meses y los resultados hablan solos.', '2026-07-15 09:30:00'),
(@p6, @u3, 5, 'Uno de los mejores suplementos que he probado. Se nota la diferencia desde la primera semana.', '2026-07-20 17:45:00');

-- Reseñas: u4
INSERT IGNORE INTO reviews (productId, usercod, calificacion, comentario, created_at) VALUES
(@p4, @u4, 4, 'Muy buena creatina, se nota el aumento de fuerza en pocos días. 100% recomendado.', '2026-07-18 11:00:00'),
(@p5, @u4, 5, 'Compré esto por recomendación de mi entrenador y no me arrepiento. Producto auténtico.', '2026-07-22 15:30:00'),
(@p1, @u4, 5, 'La proteína tiene muy buen perfil de aminoácidos. Me ayudó a recuperarme más rápido.', '2026-07-28 08:00:00');
