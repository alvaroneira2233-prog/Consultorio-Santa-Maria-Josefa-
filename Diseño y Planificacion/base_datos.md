
[01_crear_base_de_datos.sql](https://github.com/user-attachments/files/32714390/01_crear_base_de_datos.sql)

-- =====================================================================
-- Sistema de gestión de insumos - Consultorio Santa María Josefa
-- Taller Base de Datos (AIEP, NRC PRO202) - Actividad A+S
-- Script 01: creación de la base de datos, tablas y triggers de stock
-- Motor: PostgreSQL
-- =====================================================================
--
-- CÓMO EJECUTARLO
-- 1) Crear la base de datos (desde psql o pgAdmin, conectada a "postgres"):
--        CREATE DATABASE consultorio_santa_maria_josefa;
-- 2) Conectarse a ella:
--        \c consultorio_santa_maria_josefa
-- 3) Ejecutar este archivo completo. Se puede ejecutar más de una vez:
--    borra las tablas anteriores y las vuelve a crear (¡borra sus datos!).
-- =====================================================================


-- ---------------------------------------------------------------------
-- 0. Limpieza (orden inverso a la creación)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS notificacion        CASCADE;
DROP TABLE IF EXISTS alerta              CASCADE;
DROP TABLE IF EXISTS canal_comunicacion  CASCADE;
DROP TABLE IF EXISTS detalle_salida      CASCADE;
DROP TABLE IF EXISTS salida_insumo       CASCADE;
DROP TABLE IF EXISTS detalle_ingreso     CASCADE;
DROP TABLE IF EXISTS ingreso_insumo      CASCADE;
DROP TABLE IF EXISTS detalle_servicio    CASCADE;
DROP TABLE IF EXISTS servicio            CASCADE;
DROP TABLE IF EXISTS insumo              CASCADE;
DROP TABLE IF EXISTS categoria_insumo    CASCADE;
DROP TABLE IF EXISTS proveedor           CASCADE;
DROP TABLE IF EXISTS staff               CASCADE;
DROP TABLE IF EXISTS box                 CASCADE;
DROP TABLE IF EXISTS especialidad        CASCADE;

DROP FUNCTION IF EXISTS fn_stock_sumar();
DROP FUNCTION IF EXISTS fn_stock_restar();


-- ---------------------------------------------------------------------
-- 1. Tablas base (no dependen de otras)
-- ---------------------------------------------------------------------

CREATE TABLE especialidad (
    id_especialidad     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_especialidad VARCHAR(100) NOT NULL UNIQUE
);
COMMENT ON TABLE especialidad IS 'Especialidades médicas que atiende el consultorio';

CREATE TABLE proveedor (
    id_proveedor     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_proveedor VARCHAR(150) NOT NULL,
    correo           VARCHAR(150),
    telefono         VARCHAR(20)
);
COMMENT ON TABLE proveedor IS 'Proveedores de insumos';

CREATE TABLE categoria_insumo (
    id_categoria     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL UNIQUE
);
COMMENT ON TABLE categoria_insumo IS 'Clasificación de los insumos (médicos, indumentaria, etc.)';

CREATE TABLE canal_comunicacion (
    id_canal     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_canal VARCHAR(50) NOT NULL UNIQUE
);
COMMENT ON TABLE canal_comunicacion IS 'Canales por los que se envían las notificaciones (correo, WhatsApp, etc.)';


-- ---------------------------------------------------------------------
-- 2. Personas y espacios
-- ---------------------------------------------------------------------

CREATE TABLE box (
    id_box          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    numero_box      VARCHAR(20) NOT NULL UNIQUE,
    id_especialidad INTEGER NOT NULL REFERENCES especialidad (id_especialidad)
);
COMMENT ON TABLE box IS 'Boxes de atención; cada uno se asigna a una especialidad';

CREATE TABLE staff (
    id_staff        INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre          VARCHAR(150) NOT NULL,
    correo          VARCHAR(150),
    telefono        VARCHAR(20),
    id_especialidad INTEGER NOT NULL REFERENCES especialidad (id_especialidad)
);
COMMENT ON TABLE staff IS 'Personal del consultorio (profesionales y administrativos)';


-- ---------------------------------------------------------------------
-- 3. Insumos
-- ---------------------------------------------------------------------

CREATE TABLE insumo (
    id_insumo         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre_insumo     VARCHAR(150) NOT NULL,
    id_categoria      INTEGER NOT NULL REFERENCES categoria_insumo (id_categoria),
    unidad_medida     VARCHAR(30)  NOT NULL,
    -- stock_actual lo mantienen los triggers de más abajo (ver sección 6)
    stock_actual      INTEGER NOT NULL DEFAULT 0 CHECK (stock_actual >= 0),
    stock_minimo      INTEGER NOT NULL DEFAULT 0 CHECK (stock_minimo >= 0),
    fecha_vencimiento DATE,   -- puede ser nulo para insumos que no vencen (ej. indumentaria)
    id_proveedor      INTEGER NOT NULL REFERENCES proveedor (id_proveedor)
);
COMMENT ON TABLE insumo IS 'Insumos e indumentaria con su stock actual y mínimo';


-- ---------------------------------------------------------------------
-- 4. Movimientos de insumos: consumo (servicio), ingreso y salida
-- ---------------------------------------------------------------------

-- 4.1 Consumo en consultas
CREATE TABLE servicio (
    id_servicio INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_box      INTEGER NOT NULL REFERENCES box (id_box),
    id_staff    INTEGER NOT NULL REFERENCES staff (id_staff),
    fecha       DATE NOT NULL DEFAULT CURRENT_DATE,
    motivo      VARCHAR(200)
);
COMMENT ON TABLE servicio IS 'Consulta o atención realizada en un box por un miembro del staff';

CREATE TABLE detalle_servicio (
    id_servicio INTEGER NOT NULL REFERENCES servicio (id_servicio) ON DELETE CASCADE,
    id_insumo   INTEGER NOT NULL REFERENCES insumo (id_insumo),
    cantidad    INTEGER NOT NULL CHECK (cantidad > 0),
    PRIMARY KEY (id_servicio, id_insumo)
);
COMMENT ON TABLE detalle_servicio IS 'Insumos usados en cada consulta';

-- 4.2 Ingreso de insumos al almacenamiento general
CREATE TABLE ingreso_insumo (
    id_ingreso   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_proveedor INTEGER REFERENCES proveedor (id_proveedor),  -- puede ser nulo en una donación
    id_staff     INTEGER NOT NULL REFERENCES staff (id_staff),
    tipo_origen  VARCHAR(20) NOT NULL CHECK (tipo_origen IN ('compra', 'donacion')),
    fecha        DATE NOT NULL DEFAULT CURRENT_DATE,
    observacion  VARCHAR(300)
);
COMMENT ON TABLE ingreso_insumo IS 'Recepción de insumos (compra o donación)';

CREATE TABLE detalle_ingreso (
    id_ingreso INTEGER NOT NULL REFERENCES ingreso_insumo (id_ingreso) ON DELETE CASCADE,
    id_insumo  INTEGER NOT NULL REFERENCES insumo (id_insumo),
    cantidad   INTEGER NOT NULL CHECK (cantidad > 0),
    PRIMARY KEY (id_ingreso, id_insumo)
);
COMMENT ON TABLE detalle_ingreso IS 'Insumos recibidos en cada ingreso';

-- 4.3 Salida de insumos que no son consumo en consulta
CREATE TABLE salida_insumo (
    id_salida   INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_staff    INTEGER NOT NULL REFERENCES staff (id_staff),
    fecha       DATE NOT NULL DEFAULT CURRENT_DATE,
    motivo      VARCHAR(20) NOT NULL CHECK (motivo IN ('vencimiento', 'merma', 'ajuste_conteo')),
    observacion VARCHAR(300)
);
COMMENT ON TABLE salida_insumo IS 'Retiro de insumos por vencimiento, merma o ajuste de conteo físico';

CREATE TABLE detalle_salida (
    id_salida INTEGER NOT NULL REFERENCES salida_insumo (id_salida) ON DELETE CASCADE,
    id_insumo INTEGER NOT NULL REFERENCES insumo (id_insumo),
    cantidad  INTEGER NOT NULL CHECK (cantidad > 0),
    PRIMARY KEY (id_salida, id_insumo)
);
COMMENT ON TABLE detalle_salida IS 'Insumos que salen del stock en cada salida';


-- ---------------------------------------------------------------------
-- 5. Alertas y notificaciones
-- ---------------------------------------------------------------------

CREATE TABLE alerta (
    id_alerta      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_insumo      INTEGER NOT NULL REFERENCES insumo (id_insumo),
    tipo_alerta    VARCHAR(20) NOT NULL CHECK (tipo_alerta IN ('stock_minimo', 'vencimiento')),
    mensaje        VARCHAR(300),
    fecha_generada DATE NOT NULL DEFAULT CURRENT_DATE,
    estado         VARCHAR(20) NOT NULL DEFAULT 'pendiente'
                   CHECK (estado IN ('pendiente', 'notificada', 'resuelta', 'descartada'))
);
COMMENT ON TABLE alerta IS 'Alertas por stock bajo el mínimo o insumo próximo a vencer';

CREATE TABLE notificacion (
    id_notificacion INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_alerta       INTEGER NOT NULL REFERENCES alerta (id_alerta),
    id_canal        INTEGER NOT NULL REFERENCES canal_comunicacion (id_canal),
    id_staff        INTEGER REFERENCES staff (id_staff),
    id_proveedor    INTEGER REFERENCES proveedor (id_proveedor),
    fecha_envio     DATE,
    estado_envio    VARCHAR(20) NOT NULL DEFAULT 'pendiente'
                    CHECK (estado_envio IN ('pendiente', 'enviado', 'fallido')),
    -- Regla de 3FN: el destinatario es staff O proveedor, nunca ambos ni ninguno
    CONSTRAINT ck_destinatario_unico
        CHECK ((id_staff IS NOT NULL)::int + (id_proveedor IS NOT NULL)::int = 1)
);
COMMENT ON TABLE notificacion IS 'Aviso de una alerta enviado a un miembro del staff o a un proveedor';


-- ---------------------------------------------------------------------
-- 6. Triggers: mantienen insumo.stock_actual al registrar movimientos
--    (ingreso suma; consumo en consulta y salida restan)
-- ---------------------------------------------------------------------

CREATE FUNCTION fn_stock_sumar() RETURNS trigger AS $$
BEGIN
    UPDATE insumo
       SET stock_actual = stock_actual + NEW.cantidad
     WHERE id_insumo = NEW.id_insumo;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION fn_stock_restar() RETURNS trigger AS $$
BEGIN
    UPDATE insumo
       SET stock_actual = stock_actual - NEW.cantidad
     WHERE id_insumo = NEW.id_insumo;   -- si queda negativo, el CHECK de insumo rechaza el registro
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_ingreso_suma_stock
    AFTER INSERT ON detalle_ingreso
    FOR EACH ROW EXECUTE FUNCTION fn_stock_sumar();

CREATE TRIGGER trg_servicio_resta_stock
    AFTER INSERT ON detalle_servicio
    FOR EACH ROW EXECUTE FUNCTION fn_stock_restar();

CREATE TRIGGER trg_salida_resta_stock
    AFTER INSERT ON detalle_salida
    FOR EACH ROW EXECUTE FUNCTION fn_stock_restar();


-- ---------------------------------------------------------------------
-- 7. Índices para acelerar los reportes (consumo por box, staff y fecha)
-- ---------------------------------------------------------------------

CREATE INDEX idx_servicio_box      ON servicio (id_box);
CREATE INDEX idx_servicio_staff    ON servicio (id_staff);
CREATE INDEX idx_servicio_fecha    ON servicio (fecha);
CREATE INDEX idx_insumo_vencimiento ON insumo (fecha_vencimiento);
CREATE INDEX idx_alerta_estado     ON alerta (estado);
