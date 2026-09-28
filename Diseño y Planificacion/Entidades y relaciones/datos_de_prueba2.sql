-- =====================================================================
-- Sistema de gestión de insumos - Consultorio Santa María Josefa
-- Taller Base de Datos (AIEP, NRC PRO202) - Actividad A+S
-- Script 02: datos de prueba (FICTICIOS)
-- =====================================================================
--
-- CÓMO EJECUTARLO
-- Ejecutar DESPUÉS de 01_crear_base_de_datos.sql, en la misma base
-- (consultorio_santa_maria_josefa). Se puede ejecutar varias veces:
-- al inicio vacía las tablas y reinicia los identificadores.
--
-- IMPORTANTE - ORDEN DE CARGA
-- El stock de cada insumo (insumo.stock_actual) lo calculan los triggers.
-- Por eso los insumos se crean con stock 0 y el stock inicial entra por
-- ingresos (detalle_ingreso); luego los consumos y salidas lo van bajando.
-- Las fechas usan CURRENT_DATE, así que los insumos "próximos a vencer"
-- siguen así sin importar cuándo se cargue el script.
-- Todos los nombres, correos y teléfonos son inventados.
-- =====================================================================


-- ---------------------------------------------------------------------
-- 0. Limpieza previa (deja las tablas vacías y los IDs partiendo en 1)
-- ---------------------------------------------------------------------
TRUNCATE TABLE notificacion, alerta, canal_comunicacion,
               detalle_salida, salida_insumo,
               detalle_ingreso, ingreso_insumo,
               detalle_servicio, servicio,
               insumo, categoria_insumo, proveedor,
               staff, box, especialidad
RESTART IDENTITY CASCADE;


-- ---------------------------------------------------------------------
-- 1. Datos base
-- ---------------------------------------------------------------------

INSERT INTO especialidad (nombre_especialidad) VALUES
    ('Medicina General'),   -- 1
    ('Pediatría'),          -- 2
    ('Ginecología'),        -- 3
    ('Odontología');        -- 4

INSERT INTO box (numero_box, id_especialidad) VALUES
    ('Box 1', 1),           -- 1  Medicina General
    ('Box 2', 1),           -- 2  Medicina General
    ('Box 3', 2),           -- 3  Pediatría
    ('Box 4', 3),           -- 4  Ginecología
    ('Box 5', 4);           -- 5  Odontología

INSERT INTO staff (nombre, correo, telefono, id_especialidad) VALUES
    ('Camila Rojas',      'camila.rojas@ejemplo.cl',      '+56911111101', 1),  -- 1
    ('Felipe Contreras',  'felipe.contreras@ejemplo.cl',  '+56911111102', 1),  -- 2
    ('Valentina Soto',    'valentina.soto@ejemplo.cl',    '+56911111103', 2),  -- 3
    ('Javiera Muñoz',     'javiera.munoz@ejemplo.cl',     '+56911111104', 3),  -- 4
    ('Matías Vargas',     'matias.vargas@ejemplo.cl',     '+56911111105', 4),  -- 5
    ('Paula Herrera',     'paula.herrera@ejemplo.cl',     '+56911111106', 2);  -- 6

INSERT INTO proveedor (nombre_proveedor, correo, telefono) VALUES
    ('Distribuidora MediSur',      'ventas@medisur.ejemplo.cl',  '+56222220001'),  -- 1
    ('Insumos Clínicos del Sur',   'pedidos@insumossur.ejemplo.cl', '+56222220002'),  -- 2
    ('Farmacia Solidaria',         'contacto@farmaciasolidaria.ejemplo.cl', '+56222220003');  -- 3

INSERT INTO categoria_insumo (nombre_categoria) VALUES
    ('Material de curación'),        -- 1
    ('Material desechable'),         -- 2
    ('Indumentaria y protección'),   -- 3
    ('Higiene y desinfección');      -- 4

INSERT INTO canal_comunicacion (nombre_canal) VALUES
    ('Correo electrónico'),  -- 1
    ('WhatsApp');            -- 2


-- ---------------------------------------------------------------------
-- 2. Insumos (stock 0: el stock entra por los ingresos de la sección 3)
--    stock_minimo y fecha_vencimiento definidos para probar alertas:
--    - Alcohol gel y suero fisiológico vencen pronto
--    - Suero, alcohol gel, apósitos y algodón terminarán bajo su mínimo
-- ---------------------------------------------------------------------

INSERT INTO insumo (nombre_insumo, id_categoria, unidad_medida, stock_minimo, fecha_vencimiento, id_proveedor) VALUES
    ('Gasas estériles',            1, 'unidad',  50, CURRENT_DATE + 400, 1),  -- 1
    ('Jeringas 5 ml',              2, 'unidad',  40, CURRENT_DATE + 300, 1),  -- 2
    ('Guantes de látex talla M',   3, 'par',    100, CURRENT_DATE + 500, 1),  -- 3
    ('Alcohol gel',                4, 'frasco',   5, CURRENT_DATE + 25,  3),  -- 4  vence pronto
    ('Suero fisiológico 500 ml',   1, 'bolsa',   10, CURRENT_DATE + 15,  3),  -- 5  vence pronto
    ('Mascarillas quirúrgicas',    3, 'unidad', 100, CURRENT_DATE + 600, 1),  -- 6
    ('Algodón',                    1, 'paquete',  8, CURRENT_DATE + 350, 1),  -- 7
    ('Agujas 21G',                 2, 'unidad',  40, CURRENT_DATE + 450, 1),  -- 8
    ('Baja lenguas',               2, 'unidad', 100, NULL,               3),  -- 9  no vence
    ('Delantales desechables',     3, 'unidad',  20, NULL,               3),  -- 10 no vence
    ('Apósitos adhesivos',         1, 'caja',     6, CURRENT_DATE + 200, 2),  -- 11
    ('Guantes de nitrilo talla S', 3, 'par',     50, CURRENT_DATE + 520, 2);  -- 12


-- ---------------------------------------------------------------------
-- 3. Ingresos de insumos (suman stock por trigger)
-- ---------------------------------------------------------------------

INSERT INTO ingreso_insumo (id_proveedor, id_staff, tipo_origen, fecha, observacion) VALUES
    (1,    1, 'compra',   CURRENT_DATE - 45, 'Compra mensual de material clínico'),      -- 1
    (NULL, 2, 'donacion', CURRENT_DATE - 40, 'Donación de la parroquia y vecinos'),      -- 2
    (2,    1, 'compra',   CURRENT_DATE - 20, 'Compra de apósitos y guantes de nitrilo'); -- 3

INSERT INTO detalle_ingreso (id_ingreso, id_insumo, cantidad) VALUES
    -- Ingreso 1
    (1, 1, 300), (1, 2, 200), (1, 3, 500), (1, 6, 400), (1, 7, 30), (1, 8, 150),
    -- Ingreso 2 (donación)
    (2, 4, 20),  (2, 5, 30),  (2, 9, 300), (2, 10, 60),
    -- Ingreso 3
    (3, 11, 20), (3, 12, 200);


-- ---------------------------------------------------------------------
-- 4. Consultas realizadas (servicio) y los insumos que usaron
--    (restan stock por trigger)
-- ---------------------------------------------------------------------

INSERT INTO servicio (id_box, id_staff, fecha, motivo) VALUES
    (1, 1, CURRENT_DATE - 28, 'Control de salud general'),   -- 1
    (1, 1, CURRENT_DATE - 26, 'Curación de herida'),         -- 2
    (2, 2, CURRENT_DATE - 25, 'Toma de muestra'),            -- 3
    (3, 3, CURRENT_DATE - 24, 'Control niño sano'),          -- 4
    (3, 6, CURRENT_DATE - 22, 'Vacunación'),                 -- 5
    (4, 4, CURRENT_DATE - 21, 'Control ginecológico'),       -- 6
    (5, 5, CURRENT_DATE - 20, 'Limpieza dental'),            -- 7
    (1, 1, CURRENT_DATE - 18, 'Curación de herida'),         -- 8
    (2, 2, CURRENT_DATE - 16, 'Inyección intramuscular'),    -- 9
    (3, 3, CURRENT_DATE - 14, 'Control niño sano'),          -- 10
    (5, 5, CURRENT_DATE - 12, 'Extracción dental'),          -- 11
    (1, 1, CURRENT_DATE - 10, 'Curación de herida'),         -- 12
    (4, 4, CURRENT_DATE - 8,  'Toma de muestra'),            -- 13
    (2, 2, CURRENT_DATE - 6,  'Curación de herida'),         -- 14
    (3, 6, CURRENT_DATE - 4,  'Vacunación'),                 -- 15
    (5, 5, CURRENT_DATE - 3,  'Limpieza dental'),            -- 16
    (1, 1, CURRENT_DATE - 1,  'Control de salud general'),   -- 17
    (2, 2, CURRENT_DATE,      'Curación de herida');         -- 18

-- (id_servicio, id_insumo, cantidad)
INSERT INTO detalle_servicio (id_servicio, id_insumo, cantidad) VALUES
    (1, 3, 2), (1, 6, 2), (1, 9, 1), (1, 4, 2),
    (2, 1, 10), (2, 3, 2), (2, 5, 5), (2, 7, 4), (2, 11, 3),
    (3, 2, 1), (3, 8, 1), (3, 3, 2), (3, 4, 2),
    (4, 9, 1), (4, 6, 2), (4, 3, 2),
    (5, 2, 1), (5, 8, 1), (5, 4, 2), (5, 6, 2), (5, 3, 2),
    (6, 3, 2), (6, 4, 2), (6, 10, 1),
    (7, 12, 2), (7, 10, 1),
    (8, 1, 8), (8, 3, 2), (8, 5, 5), (8, 7, 4), (8, 11, 3),
    (9, 2, 1), (9, 8, 1), (9, 3, 2), (9, 7, 3),
    (10, 9, 1), (10, 6, 2), (10, 4, 2), (10, 3, 2),
    (11, 12, 2), (11, 10, 1), (11, 1, 4),
    (12, 1, 8), (12, 3, 2), (12, 5, 5), (12, 7, 4), (12, 11, 3),
    (13, 2, 1), (13, 8, 1), (13, 4, 2), (13, 3, 2), (13, 10, 1),
    (14, 1, 6), (14, 3, 2), (14, 5, 5), (14, 7, 4), (14, 11, 3),
    (15, 2, 1), (15, 8, 1), (15, 4, 2), (15, 6, 2), (15, 3, 2),
    (16, 12, 2), (16, 10, 1),
    (17, 9, 1), (17, 6, 2), (17, 4, 2), (17, 3, 2),
    (18, 1, 6), (18, 3, 2), (18, 5, 5), (18, 7, 4), (18, 11, 3);


-- ---------------------------------------------------------------------
-- 5. Salidas de insumos que no son consumo en consulta
--    (restan stock por trigger)
-- ---------------------------------------------------------------------

INSERT INTO salida_insumo (id_staff, fecha, motivo, observacion) VALUES
    (2, CURRENT_DATE - 7, 'merma',         'Jeringas y agujas dañadas al abrir el envase'),  -- 1
    (1, CURRENT_DATE - 2, 'ajuste_conteo', 'Conteo físico: faltaban gasas en bodega');       -- 2

INSERT INTO detalle_salida (id_salida, id_insumo, cantidad) VALUES
    (1, 2, 3), (1, 8, 2),
    (2, 1, 4);


-- ---------------------------------------------------------------------
-- 6. Ejemplos de alertas y notificaciones
--    (solo para probar las tablas; más adelante la consulta de alertas
--     las generará a partir del stock y las fechas de vencimiento)
-- ---------------------------------------------------------------------

INSERT INTO alerta (id_insumo, tipo_alerta, mensaje, fecha_generada, estado) VALUES
    (5, 'stock_minimo', 'Suero fisiológico 500 ml bajo el stock mínimo',  CURRENT_DATE, 'notificada'),  -- 1
    (4, 'vencimiento',  'Alcohol gel próximo a su fecha de vencimiento',  CURRENT_DATE, 'pendiente');   -- 2

INSERT INTO notificacion (id_alerta, id_canal, id_staff, id_proveedor, fecha_envio, estado_envio) VALUES
    (1, 1, NULL, 3, CURRENT_DATE, 'enviado'),   -- aviso al proveedor por correo
    (1, 2, 1,    NULL, CURRENT_DATE, 'enviado'); -- aviso al staff por WhatsApp


-- ---------------------------------------------------------------------
-- 7. Verificación: cantidad de filas por tabla y estado del stock
-- ---------------------------------------------------------------------

SELECT 'especialidad' AS tabla, COUNT(*) AS filas FROM especialidad
UNION ALL SELECT 'box',              COUNT(*) FROM box
UNION ALL SELECT 'staff',            COUNT(*) FROM staff
UNION ALL SELECT 'proveedor',        COUNT(*) FROM proveedor
UNION ALL SELECT 'categoria_insumo', COUNT(*) FROM categoria_insumo
UNION ALL SELECT 'insumo',           COUNT(*) FROM insumo
UNION ALL SELECT 'servicio',         COUNT(*) FROM servicio
UNION ALL SELECT 'detalle_servicio', COUNT(*) FROM detalle_servicio
UNION ALL SELECT 'ingreso_insumo',   COUNT(*) FROM ingreso_insumo
UNION ALL SELECT 'detalle_ingreso',  COUNT(*) FROM detalle_ingreso
UNION ALL SELECT 'salida_insumo',    COUNT(*) FROM salida_insumo
UNION ALL SELECT 'detalle_salida',   COUNT(*) FROM detalle_salida
UNION ALL SELECT 'alerta',           COUNT(*) FROM alerta
UNION ALL SELECT 'canal_comunicacion', COUNT(*) FROM canal_comunicacion
UNION ALL SELECT 'notificacion',     COUNT(*) FROM notificacion;

SELECT nombre_insumo,
       stock_actual,
       stock_minimo,
       fecha_vencimiento,
       CASE WHEN stock_actual <= stock_minimo THEN 'BAJO EL MÍNIMO' ELSE 'ok' END AS estado_stock
FROM insumo
ORDER BY id_insumo;
