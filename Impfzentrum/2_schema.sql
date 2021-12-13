/*
 * Tabellen erzeugen
 */
-- Testat 4: Aufgabe 2 Schema-Evolution
-- Passen Sie direkt im aktuellen Schema ("2_schema.sql") ein ID-Attribut so an, dass es vom Typ "serial" (SEQUENCE) ist. Diese ID soll nicht Teil einer Mehrere-zu-Mehrere-Beziehung sein.
--@doc bereits von anfang an vorhanden, aber startwert nicht bei eins, da mehrere sequencen (ang, pat, ...)
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

-- Testat 4
-- Aufgabe 3 Schema-Evolution ff.
-- Behalten Sie für diese Aufgabe ihre bestehenden CREATE TABLE-Statements bei. Nehmen Sie die geforderten Schema-Änderungen mittels ALTER TABLE vor (im Skript "2_schema.sql").
-- Feld mit Aufzählttyp: Schreiben Sie einen Aufzählttyp (ENUM) und passen Sie Ihr Schema (2_schema.sql) entsprechend an - falls nicht schon vorhanden. Informieren Sie sich ev. über diese Typen (siehe Enumerated Types und DOMAIN).
--@doc welchen ausbildungsstand haben die angestellten.
create type ausbildung as enum (
  'mpa',
  'doc',
  'other'
);

alter table scm.angestellte
  add ausb ausbildung default 'other' not null;

-- Feld mit BOOLEAN: Passen Sie Ihr Schema so an, dass ein Feld einen BOOLEAN als Datentyp enthält (falls nicht schon vorhanden).
--@doc also changed the trigger function, for changing the booleans.
alter table scm.patient
  add has_impf1 boolean default false,
  add has_impf2 boolean default false;

-- Fügen Sie Daten ein, die dem ENUM und dem BOOLEAN entsprechen.
--@doc booleans werden mit trigger angepasst
--@doc enums werden bei insert angepasst.
-- Fügen Sie - falls nicht schon vorhanden - ein zusätzliches Attribut vom Typ Datum ein (z.B. "aktualisiert DATETIME"), bei einer Tabelle, wo das passt.
--@doc time, date, timestamp bereits in vorhanden.
-- Falls Ihr Schema bereits einen oder mehr Aufzählungstypen und einen (oder mehr) BOOLEAN und eine (oder mehr) DATETIME enthält, müssen Sie für diesen Aufgabenteil nichts weiter tun.
--@doc all done!
-- Aufgabe 4 Indexe
-- Erstellen Sie einen funktionalen Index (d.h. Index auf Ausdrücke/Expressions) an eine Tabelle passend zu Ihren Projektdaten mit der Funktion lower().
--@doc index of patient nach_name, query in 5_queries.sql
create index idx_lower_nach_name on scm.patient ((lower(nach_name)));

