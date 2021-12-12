/*
 * Tabellen erzeugen
 */
-- Testat 4: Aufgabe 2 Schema-Evolution
-- Passen Sie direkt im aktuellen Schema ("2_schema.sql") ein ID-Attribut so an, dass es vom Typ "serial" (SEQUENCE) ist. Diese ID soll nicht Teil einer Mehrere-zu-Mehrere-Beziehung sein.
--@doc bereits von anfang an vorhanden
create schema scm;

create table scm.angestellte (
  id_ang serial,
  ahvnr char(16),
  vor_name varchar(20) not null,
  nach_name varchar(20) not null,
  lohn decimal(10, 2) not null,
  primary key (id_ang),
  unique (ahvnr)
);

alter sequence scm.angestellte_id_ang_seq
  restart with 1001;

create table scm.patient (
  id_pat serial,
  versnr integer not null,
  vor_name varchar(20) not null,
  nach_name varchar(20) not null,
  impfdat_1 date,
  impfdosis_1 integer,
  impfdat_2 date,
  impfdosis_2 integer,
  primary key (id_pat),
  unique (versnr),
  unique (impfdosis_1),
  unique (impfdosis_2)
);

alter sequence scm.patient_id_pat_seq
  restart with 8001;

create table scm.reservierung (
  id_pat integer,
  datum date not null default current_date,
  zeit time not null default current_time,
  primary key (id_pat, datum)
);

create table scm.impfdosis_lager (
  id_dosis integer,
  eingangsdatum date not null,
  ablaufdatum date not null,
  primary key (id_dosis)
);

-- id_dosis, id_pat, id_ang are fk
create table scm.lager_entnahme (
  id_dosis integer not null,
  id_pat integer not null,
  id_ang integer not null,
  entnahme_ts timestamp with time zone not null default current_timestamp,
  primary key (id_dosis)
);

