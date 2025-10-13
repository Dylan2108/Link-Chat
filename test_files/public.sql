/*
 Navicat Premium Dump SQL

 Source Server         : Hola BD
 Source Server Type    : PostgreSQL
 Source Server Version : 160002 (160002)
 Source Host           : localhost:5432
 Source Catalog        : Gestion_Hospitales
 Source Schema         : public

 Target Server Type    : PostgreSQL
 Target Server Version : 160002 (160002)
 File Encoding         : 65001

 Date: 20/04/2025 23:04:10
*/


-- ----------------------------
-- Sequence structure for departamentos_departamentocod_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."departamentos_departamentocod_seq";
CREATE SEQUENCE "public"."departamentos_departamentocod_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for hospitales_hospitalcod_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."hospitales_hospitalcod_seq";
CREATE SEQUENCE "public"."hospitales_hospitalcod_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for informes_informenum_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."informes_informenum_seq";
CREATE SEQUENCE "public"."informes_informenum_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for medicos_medicocod_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."medicos_medicocod_seq";
CREATE SEQUENCE "public"."medicos_medicocod_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for pacientes_historiaclinicanum_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."pacientes_historiaclinicanum_seq";
CREATE SEQUENCE "public"."pacientes_historiaclinicanum_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for registropaciente_registroid_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."registropaciente_registroid_seq";
CREATE SEQUENCE "public"."registropaciente_registroid_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for roles_rolcod_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."roles_rolcod_seq";
CREATE SEQUENCE "public"."roles_rolcod_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for turnos_turnonum_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."turnos_turnonum_seq";
CREATE SEQUENCE "public"."turnos_turnonum_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for unidades_unidadcod_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."unidades_unidadcod_seq";
CREATE SEQUENCE "public"."unidades_unidadcod_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Sequence structure for usuarios_usuariocod_seq
-- ----------------------------
DROP SEQUENCE IF EXISTS "public"."usuarios_usuariocod_seq";
CREATE SEQUENCE "public"."usuarios_usuariocod_seq" 
INCREMENT 1
MINVALUE  1
MAXVALUE 2147483647
START 1
CACHE 1;

-- ----------------------------
-- Table structure for departamentos
-- ----------------------------
DROP TABLE IF EXISTS "public"."departamentos";
CREATE TABLE "public"."departamentos" (
  "hospitalcod" int4 NOT NULL,
  "departamentocod" int4 NOT NULL DEFAULT nextval('departamentos_departamentocod_seq'::regclass),
  "nombre" varchar(100) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of departamentos
-- ----------------------------

-- ----------------------------
-- Table structure for hospitales
-- ----------------------------
DROP TABLE IF EXISTS "public"."hospitales";
CREATE TABLE "public"."hospitales" (
  "hospitalcod" int4 NOT NULL DEFAULT nextval('hospitales_hospitalcod_seq'::regclass),
  "nombre" varchar(100) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of hospitales
-- ----------------------------

-- ----------------------------
-- Table structure for informes
-- ----------------------------
DROP TABLE IF EXISTS "public"."informes";
CREATE TABLE "public"."informes" (
  "informenum" int4 NOT NULL DEFAULT nextval('informes_informenum_seq'::regclass),
  "turnonum" int4 NOT NULL,
  "fechahora" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  "pacientesatendidos" int4 NOT NULL,
  "pacientesaltas" int4 NOT NULL,
  "pacientesadmitidos" int4 NOT NULL,
  "totalactual" int4 NOT NULL
)
;

-- ----------------------------
-- Records of informes
-- ----------------------------

-- ----------------------------
-- Table structure for medicos
-- ----------------------------
DROP TABLE IF EXISTS "public"."medicos";
CREATE TABLE "public"."medicos" (
  "medicocod" int4 NOT NULL DEFAULT nextval('medicos_medicocod_seq'::regclass),
  "nombre" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "apellidos" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "especialidad" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "licenciamedica" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "telefono" varchar(20) COLLATE "pg_catalog"."default",
  "anosexperiencia" int4,
  "contacto" varchar(100) COLLATE "pg_catalog"."default",
  "hospitalcod" int4 NOT NULL,
  "departamentocod" int4 NOT NULL,
  "unidadcod" int4 NOT NULL
)
;

-- ----------------------------
-- Records of medicos
-- ----------------------------

-- ----------------------------
-- Table structure for pacientes
-- ----------------------------
DROP TABLE IF EXISTS "public"."pacientes";
CREATE TABLE "public"."pacientes" (
  "historiaclinicanum" int4 NOT NULL DEFAULT nextval('pacientes_historiaclinicanum_seq'::regclass),
  "nombre" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "apellidos" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "fechanacimiento" date NOT NULL,
  "direccion" varchar(200) COLLATE "pg_catalog"."default" NOT NULL,
  "hospitalcod" int4 NOT NULL,
  "departamentocod" int4 NOT NULL,
  "unidadcod" int4 NOT NULL
)
;

-- ----------------------------
-- Records of pacientes
-- ----------------------------

-- ----------------------------
-- Table structure for registropaciente
-- ----------------------------
DROP TABLE IF EXISTS "public"."registropaciente";
CREATE TABLE "public"."registropaciente" (
  "registroid" int4 NOT NULL DEFAULT nextval('registropaciente_registroid_seq'::regclass),
  "historiaclinicanum" int4 NOT NULL,
  "fechaalta" date NOT NULL DEFAULT CURRENT_DATE,
  "fechabaja" date,
  "atendido" bool NOT NULL DEFAULT false,
  "causanoatencion" varchar(200) COLLATE "pg_catalog"."default"
)
;

-- ----------------------------
-- Records of registropaciente
-- ----------------------------

-- ----------------------------
-- Table structure for roles
-- ----------------------------
DROP TABLE IF EXISTS "public"."roles";
CREATE TABLE "public"."roles" (
  "rolcod" int4 NOT NULL DEFAULT nextval('roles_rolcod_seq'::regclass),
  "nombrerol" varchar(50) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of roles
-- ----------------------------

-- ----------------------------
-- Table structure for turnos
-- ----------------------------
DROP TABLE IF EXISTS "public"."turnos";
CREATE TABLE "public"."turnos" (
  "turnonum" int4 NOT NULL DEFAULT nextval('turnos_turnonum_seq'::regclass),
  "medicocod" int4 NOT NULL,
  "hospitalcod" int4 NOT NULL,
  "departamentocod" int4 NOT NULL,
  "unidadcod" int4 NOT NULL,
  "fechahorainicio" timestamp(6) NOT NULL,
  "fechahorafin" timestamp(6) NOT NULL,
  "pacientesasignados" int4 NOT NULL
)
;

-- ----------------------------
-- Records of turnos
-- ----------------------------

-- ----------------------------
-- Table structure for unidades
-- ----------------------------
DROP TABLE IF EXISTS "public"."unidades";
CREATE TABLE "public"."unidades" (
  "hospitalcod" int4 NOT NULL,
  "departamentocod" int4 NOT NULL,
  "unidadcod" int4 NOT NULL DEFAULT nextval('unidades_unidadcod_seq'::regclass),
  "nombre" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "ubicacion" varchar(200) COLLATE "pg_catalog"."default" NOT NULL
)
;

-- ----------------------------
-- Records of unidades
-- ----------------------------

-- ----------------------------
-- Table structure for usuariorol
-- ----------------------------
DROP TABLE IF EXISTS "public"."usuariorol";
CREATE TABLE "public"."usuariorol" (
  "usuariocod" int4 NOT NULL,
  "rolcod" int4 NOT NULL,
  "fechaasignacion" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Records of usuariorol
-- ----------------------------

-- ----------------------------
-- Table structure for usuarios
-- ----------------------------
DROP TABLE IF EXISTS "public"."usuarios";
CREATE TABLE "public"."usuarios" (
  "usuariocod" int4 NOT NULL DEFAULT nextval('usuarios_usuariocod_seq'::regclass),
  "nombreusuario" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
  "contrasenahash" varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
  "email" varchar(100) COLLATE "pg_catalog"."default" NOT NULL,
  "nombre" varchar(50) COLLATE "pg_catalog"."default",
  "apellidos" varchar(100) COLLATE "pg_catalog"."default",
  "activo" bool NOT NULL DEFAULT true,
  "fechacreacion" timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP
)
;

-- ----------------------------
-- Records of usuarios
-- ----------------------------

-- ----------------------------
-- Function structure for check_max_medicos
-- ----------------------------
DROP FUNCTION IF EXISTS "public"."check_max_medicos"();
CREATE OR REPLACE FUNCTION "public"."check_max_medicos"()
  RETURNS "pg_catalog"."trigger" AS $BODY$
BEGIN
    IF (SELECT COUNT(*) FROM Medicos 
        WHERE HospitalCod = NEW.HospitalCod
        AND DepartamentoCod = NEW.DepartamentoCod
        AND UnidadCod = NEW.UnidadCod) >= 10 THEN
        RAISE EXCEPTION 'Una unidad no puede tener más de 10 médicos';
    END IF;
    RETURN NEW;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

-- ----------------------------
-- View structure for unidadesrevisar
-- ----------------------------
DROP VIEW IF EXISTS "public"."unidadesrevisar";
CREATE VIEW "public"."unidadesrevisar" AS  SELECT u.hospitalcod,
    u.departamentocod,
    u.unidadcod,
    u.nombre,
    u.ubicacion,
    t.turnonum,
    t.pacientesasignados::numeric * 0.8 AS meta,
    i.pacientesatendidos
   FROM unidades u
     JOIN turnos t ON u.hospitalcod = t.hospitalcod AND u.departamentocod = t.departamentocod AND u.unidadcod = t.unidadcod
     JOIN informes i ON t.turnonum = i.turnonum
  WHERE i.pacientesatendidos::numeric < (t.pacientesasignados::numeric * 0.8);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."departamentos_departamentocod_seq"
OWNED BY "public"."departamentos"."departamentocod";
SELECT setval('"public"."departamentos_departamentocod_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."hospitales_hospitalcod_seq"
OWNED BY "public"."hospitales"."hospitalcod";
SELECT setval('"public"."hospitales_hospitalcod_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."informes_informenum_seq"
OWNED BY "public"."informes"."informenum";
SELECT setval('"public"."informes_informenum_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."medicos_medicocod_seq"
OWNED BY "public"."medicos"."medicocod";
SELECT setval('"public"."medicos_medicocod_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."pacientes_historiaclinicanum_seq"
OWNED BY "public"."pacientes"."historiaclinicanum";
SELECT setval('"public"."pacientes_historiaclinicanum_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."registropaciente_registroid_seq"
OWNED BY "public"."registropaciente"."registroid";
SELECT setval('"public"."registropaciente_registroid_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."roles_rolcod_seq"
OWNED BY "public"."roles"."rolcod";
SELECT setval('"public"."roles_rolcod_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."turnos_turnonum_seq"
OWNED BY "public"."turnos"."turnonum";
SELECT setval('"public"."turnos_turnonum_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."unidades_unidadcod_seq"
OWNED BY "public"."unidades"."unidadcod";
SELECT setval('"public"."unidades_unidadcod_seq"', 1, false);

-- ----------------------------
-- Alter sequences owned by
-- ----------------------------
ALTER SEQUENCE "public"."usuarios_usuariocod_seq"
OWNED BY "public"."usuarios"."usuariocod";
SELECT setval('"public"."usuarios_usuariocod_seq"', 1, false);

-- ----------------------------
-- Uniques structure for table departamentos
-- ----------------------------
ALTER TABLE "public"."departamentos" ADD CONSTRAINT "departamentos_hospitalcod_nombre_key" UNIQUE ("hospitalcod", "nombre");

-- ----------------------------
-- Primary Key structure for table departamentos
-- ----------------------------
ALTER TABLE "public"."departamentos" ADD CONSTRAINT "departamentos_pkey" PRIMARY KEY ("hospitalcod", "departamentocod");

-- ----------------------------
-- Uniques structure for table hospitales
-- ----------------------------
ALTER TABLE "public"."hospitales" ADD CONSTRAINT "hospitales_nombre_key" UNIQUE ("nombre");

-- ----------------------------
-- Primary Key structure for table hospitales
-- ----------------------------
ALTER TABLE "public"."hospitales" ADD CONSTRAINT "hospitales_pkey" PRIMARY KEY ("hospitalcod");

-- ----------------------------
-- Checks structure for table informes
-- ----------------------------
ALTER TABLE "public"."informes" ADD CONSTRAINT "informes_pacientesatendidos_check" CHECK (pacientesatendidos >= 0);
ALTER TABLE "public"."informes" ADD CONSTRAINT "informes_pacientesaltas_check" CHECK (pacientesaltas >= 0);
ALTER TABLE "public"."informes" ADD CONSTRAINT "informes_pacientesadmitidos_check" CHECK (pacientesadmitidos >= 0);
ALTER TABLE "public"."informes" ADD CONSTRAINT "informes_totalactual_check" CHECK (totalactual >= 0);

-- ----------------------------
-- Primary Key structure for table informes
-- ----------------------------
ALTER TABLE "public"."informes" ADD CONSTRAINT "informes_pkey" PRIMARY KEY ("informenum");

-- ----------------------------
-- Triggers structure for table medicos
-- ----------------------------
CREATE TRIGGER "trigger_max_medicos" BEFORE INSERT OR UPDATE ON "public"."medicos"
FOR EACH ROW
EXECUTE PROCEDURE "public"."check_max_medicos"();

-- ----------------------------
-- Uniques structure for table medicos
-- ----------------------------
ALTER TABLE "public"."medicos" ADD CONSTRAINT "medicos_licenciamedica_key" UNIQUE ("licenciamedica");

-- ----------------------------
-- Checks structure for table medicos
-- ----------------------------
ALTER TABLE "public"."medicos" ADD CONSTRAINT "medicos_anosexperiencia_check" CHECK (anosexperiencia >= 0);

-- ----------------------------
-- Primary Key structure for table medicos
-- ----------------------------
ALTER TABLE "public"."medicos" ADD CONSTRAINT "medicos_pkey" PRIMARY KEY ("medicocod");

-- ----------------------------
-- Checks structure for table pacientes
-- ----------------------------
ALTER TABLE "public"."pacientes" ADD CONSTRAINT "pacientes_fechanacimiento_check" CHECK (date_part('year'::text, age(fechanacimiento::timestamp with time zone)) >= 16::double precision);

-- ----------------------------
-- Primary Key structure for table pacientes
-- ----------------------------
ALTER TABLE "public"."pacientes" ADD CONSTRAINT "pacientes_pkey" PRIMARY KEY ("historiaclinicanum");

-- ----------------------------
-- Primary Key structure for table registropaciente
-- ----------------------------
ALTER TABLE "public"."registropaciente" ADD CONSTRAINT "registropaciente_pkey" PRIMARY KEY ("registroid");

-- ----------------------------
-- Uniques structure for table roles
-- ----------------------------
ALTER TABLE "public"."roles" ADD CONSTRAINT "roles_nombrerol_key" UNIQUE ("nombrerol");

-- ----------------------------
-- Primary Key structure for table roles
-- ----------------------------
ALTER TABLE "public"."roles" ADD CONSTRAINT "roles_pkey" PRIMARY KEY ("rolcod");

-- ----------------------------
-- Checks structure for table turnos
-- ----------------------------
ALTER TABLE "public"."turnos" ADD CONSTRAINT "turnos_pacientesasignados_check" CHECK (pacientesasignados > 0);

-- ----------------------------
-- Primary Key structure for table turnos
-- ----------------------------
ALTER TABLE "public"."turnos" ADD CONSTRAINT "turnos_pkey" PRIMARY KEY ("turnonum");

-- ----------------------------
-- Uniques structure for table unidades
-- ----------------------------
ALTER TABLE "public"."unidades" ADD CONSTRAINT "unidades_hospitalcod_departamentocod_nombre_key" UNIQUE ("hospitalcod", "departamentocod", "nombre");

-- ----------------------------
-- Primary Key structure for table unidades
-- ----------------------------
ALTER TABLE "public"."unidades" ADD CONSTRAINT "unidades_pkey" PRIMARY KEY ("hospitalcod", "departamentocod", "unidadcod");

-- ----------------------------
-- Primary Key structure for table usuariorol
-- ----------------------------
ALTER TABLE "public"."usuariorol" ADD CONSTRAINT "usuariorol_pkey" PRIMARY KEY ("usuariocod", "rolcod");

-- ----------------------------
-- Uniques structure for table usuarios
-- ----------------------------
ALTER TABLE "public"."usuarios" ADD CONSTRAINT "usuarios_nombreusuario_key" UNIQUE ("nombreusuario");
ALTER TABLE "public"."usuarios" ADD CONSTRAINT "usuarios_email_key" UNIQUE ("email");

-- ----------------------------
-- Primary Key structure for table usuarios
-- ----------------------------
ALTER TABLE "public"."usuarios" ADD CONSTRAINT "usuarios_pkey" PRIMARY KEY ("usuariocod");

-- ----------------------------
-- Foreign Keys structure for table departamentos
-- ----------------------------
ALTER TABLE "public"."departamentos" ADD CONSTRAINT "departamentos_hospitalcod_fkey" FOREIGN KEY ("hospitalcod") REFERENCES "public"."hospitales" ("hospitalcod") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table informes
-- ----------------------------
ALTER TABLE "public"."informes" ADD CONSTRAINT "informes_turnonum_fkey" FOREIGN KEY ("turnonum") REFERENCES "public"."turnos" ("turnonum") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table medicos
-- ----------------------------
ALTER TABLE "public"."medicos" ADD CONSTRAINT "medicos_hospitalcod_departamentocod_unidadcod_fkey" FOREIGN KEY ("hospitalcod", "departamentocod", "unidadcod") REFERENCES "public"."unidades" ("hospitalcod", "departamentocod", "unidadcod") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table pacientes
-- ----------------------------
ALTER TABLE "public"."pacientes" ADD CONSTRAINT "pacientes_hospitalcod_departamentocod_unidadcod_fkey" FOREIGN KEY ("hospitalcod", "departamentocod", "unidadcod") REFERENCES "public"."unidades" ("hospitalcod", "departamentocod", "unidadcod") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table registropaciente
-- ----------------------------
ALTER TABLE "public"."registropaciente" ADD CONSTRAINT "registropaciente_historiaclinicanum_fkey" FOREIGN KEY ("historiaclinicanum") REFERENCES "public"."pacientes" ("historiaclinicanum") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table turnos
-- ----------------------------
ALTER TABLE "public"."turnos" ADD CONSTRAINT "turnos_hospitalcod_departamentocod_unidadcod_fkey" FOREIGN KEY ("hospitalcod", "departamentocod", "unidadcod") REFERENCES "public"."unidades" ("hospitalcod", "departamentocod", "unidadcod") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."turnos" ADD CONSTRAINT "turnos_medicocod_fkey" FOREIGN KEY ("medicocod") REFERENCES "public"."medicos" ("medicocod") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table unidades
-- ----------------------------
ALTER TABLE "public"."unidades" ADD CONSTRAINT "unidades_hospitalcod_departamentocod_fkey" FOREIGN KEY ("hospitalcod", "departamentocod") REFERENCES "public"."departamentos" ("hospitalcod", "departamentocod") ON DELETE CASCADE ON UPDATE NO ACTION;

-- ----------------------------
-- Foreign Keys structure for table usuariorol
-- ----------------------------
ALTER TABLE "public"."usuariorol" ADD CONSTRAINT "usuariorol_rolcod_fkey" FOREIGN KEY ("rolcod") REFERENCES "public"."roles" ("rolcod") ON DELETE CASCADE ON UPDATE NO ACTION;
ALTER TABLE "public"."usuariorol" ADD CONSTRAINT "usuariorol_usuariocod_fkey" FOREIGN KEY ("usuariocod") REFERENCES "public"."usuarios" ("usuariocod") ON DELETE CASCADE ON UPDATE NO ACTION;
