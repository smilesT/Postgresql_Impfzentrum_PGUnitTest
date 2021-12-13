-- START TESTAT 3
-- Aufgabe 1: Einfache Queries
-- SQL-Datei mit folgenden 4 SQL-Queries, wobei vor jeder Anfrage (Query) ein Kommentar steht mit präziser Beschreibung was die Query macht (Datei 5_queries.sql):
-- 1.1. Eine Query mit DISTINCT.
--@doc: selects distinct paare von scm.patient, scm.angestellte und zählt wieviele dosen der scm.angestellte schon aus dem lager entnommen hat.
select distinct
  id_pat,
  id_ang,
  count(*) over (partition by id_ang) as "c1"
from
  scm.lager_entnahme;

--@doc: prints out how many different lohnklassen there are in the company und sums it up.
select distinct
  scm.angestellte.lohn as "lohnklasse",
  sum(lohn) over w
from scm.angestellte
window w as (partition by lohn)
order by
  1;

-- 1.2. Eine Query, die einen JOIN über drei oder mehr Tabellen enthält (bitte als "New Style"-JOIN mit "JOIN ... ON").
--@doc zeigt welcher scm.angestellte welche dosis mit welchem eingangsdatum zu welchem ts verwendet hat.
select
  ang.id_ang,
  ang.nach_name,
  lagout.id_dosis,
  lagout.entnahme_ts,
  lag.eingangsdatum,
  lag.ablaufdatum
from
  scm.lager_entnahme as lagout
  left join scm.angestellte as ang on ang.id_ang = lagout.id_ang
  left join scm.impfdosis_lager as lag on lag.id_dosis = lagout.id_dosis;

-- 1.3. Eine Query mit einer Unterabfrage mit Angabe, ob diese Query korreliert ist oder unkorreliert.
--@doc unkorrelierte unterabfrage der bestbezahltesten Scm.Angestellten
select
  *
from
  scm.angestellte as ang
where
  ang.lohn = (
    select
      max(lohn)
    from
      scm.angestellte);

-- 1.4. Eine Query, die eines der vier folgenden Statements enthält (gegebenenfalls mit NOT davor): ANY, IN, EXISTS oder ALL.
--@doc alle scm.angestellten die an tag XXXX-YY-ZZ gearbeitet haben. unkorreliert
select
  ang.nach_name,
  ang.id_ang
from
  scm.angestellte as ang
where
  ang.id_ang in (
    select
      id_ang
    from
      scm.lager_entnahme
    where
      entnahme_ts::text like '2021-11-06%');

-- Aufgabe 2: Common Table Expressions und Window-Funktionen
-- 2.1 Common Table Expressions/WITH-Statements:
-- Schreiben Sie zunächst eine Anfrage mit einer unkorrelierten Unterabfrage und dokumentieren Sie diese (einfacher Kommentar vor dem SQL).
--@doc wieviele scm.patienten haben die scm.angestellten schon geimpft
--
select
  ang.id_ang,
  ang.vor_name,
  ang.nach_name,
  (
    select
      count(*) as cnt
    from
      scm.lager_entnahme
    where
      scm.lager_entnahme.id_ang = ang.id_ang)
from
  scm.angestellte as ang
order by
  cnt desc;

--
-- Formen Sie dann diese Subquery um in eine Common Table Expression.
-- Ihre Abgabe muss sowohl die Query mit unkorrelierten Unterabfrage (vor der Umformung) als auch die Query mit Common Table Expression enthalten.
with produktivitaet_mitarbeiter as (
  select
    scm.angestellte.id_ang,
    scm.angestellte.vor_name,
    scm.angestellte.nach_name,
    (
      select
        count(*) as cnt
    from
      scm.lager_entnahme
    where
      scm.lager_entnahme.id_ang = scm.angestellte.id_ang)
  from
    scm.angestellte
  order by
    cnt desc
)
select
  *
from
  produktivitaet_mitarbeiter;

-- 2.2 GROUP-BY und Window-Funktionen:
-- Schreiben Sie eine sinnvolle Query mit einer GROUP BY-Klausel.
--@doc wieviel scm.angestellte pro lohnklasse
with lk as (
  select
    lohn,
    count(*) as c
  from
    scm.angestellte
  group by
    lohn
)
select distinct
  lk.lohn,
  lk.c
from
  scm.angestellte
  join lk on scm.angestellte.lohn = lk.lohn;

-- Schreiben Sie eine sinnvolle Query mit einer Window-Funktion.
--@doc: selects distinct paare von scm.patient, scm.angestellte und zählt wieviele dosen der scm.angestellte schon aus dem lager entnommen hat.
select distinct
  id_pat,
  id_ang,
  count(*) over (partition by id_ang) as "c1"
from
  scm.lager_entnahme
  -- window w as (partition by id_ang)
order by
  3 desc;

-- Aufgabe 3: Views
-- 3.1 Views:
-- Schreiben Sie eine View, die mindestens drei Tabellen umfasst.
--@doc
create view vv as
select
  ang.id_ang,
  ang.nach_name,
  lagout.id_dosis,
  lagout.entnahme_ts,
  lag.eingangsdatum,
  lag.ablaufdatum
from
  scm.lager_entnahme as lagout
  left join scm.angestellte as ang on ang.id_ang = lagout.id_ang
  left join scm.impfdosis_lager as lag on lag.id_dosis = lagout.id_dosis;

-- Schreiben Sie dann eine normale Query, welche diese View verwendet.
select
  *
from
  vv;

-- 3.2 Schreiben Sie eine zweite View (also eine "einfachere" View), die sich updaten lässt. Testen Sie, dass die View sich wirklich updaten lässt, wie folgt:
-- View schreiben (Tipp: Beschränkungen von PostgreSQL beachten, so dass die View "updateable" ist).
-- Eine Änderung eines bestimmten Datensatzes über diese View schreiben mittels UPDATE (UPDATE <Ihre View> SET ... WHERE ...;).
--@doc simple updatable view
drop view if exists update_view_1;

create view update_view_1 as
select
  ang.ahvnr,
  ang.nach_name,
  ang.vor_name,
  ang.lohn
from
  scm.angestellte as ang;

select
  *
from
  update_view_1;

insert into update_view_1 (ahvnr, vor_name, nach_name, lohn)
  values ('756.1001.1001.04', 'miles', 'admin', 2000);

-- END TESTAT 3
--
--
-- START TESTAT 4
-- Aufgabe 1 Lateral Join-Query
-- Formulieren Sie eine SQL-Query mit einem Lateral Join.
--@doc ordnet die impfungen den angestellten und patienten zu
select
  *
from
  scm.lager_entnahme;

select
  a.id_ang,
  a.vor_name,
  a.nach_name,
  id_pat,
  entnahme_ts
from
  scm.angestellte a
  join lateral (
    select
      *
    from
      scm.lager_entnahme le
    where
      le.id_ang = a.id_ang) as patToAng on true
order by
  entnahme_ts desc;

-- Testat 4, Aufgabe 4
--@doc query from indexed table
--
select
  *
from
  scm.patient
where
  lower(nach_name)
  like 'chiff%';

-- Aufgabe 5 Tests
-- Testen Sie mittels INSERT-Statements im Skript "5_queries.sql", ob Sie Daten-Werte eintragen können,
-- die nicht den Datentypen ENUM und BOOLEAN entsprechen, bzw.
--@enum test:
-- insert into scm.angestellte (ahvnr, vor_name, nach_name, lohn, ausb)
--   values ('756.1111.2222.39', 'dontcare', 'onconstraints', 950, null);
-- ERROR:  null value in column "ausb" of relation "angestellte" violates not-null constraint
-- DETAIL:  Failing row contains (1009, 756.1111.2222.39, dontcare, onconstraints, 950.00, null).
--
--@boolean test:
-- insert into scm.patient (versnr, vor_name, nach_name, impfdat_1, impfdosis_1, has_impf1)
--   values (222999, 'mrs', 'donnoboolean', '2021-11-03'::date, -1, 'sotrue');
-- ERROR:  invalid input syntax for type boolean: "sotrue"
-- LINE 2: ...9, 'mrs', 'donnoboolean', '2021-11-03'::date, -1, 'sotrue');
--
-- die einen UNIQUE-Constraint verletzten. (Kann auch ein durch einen PK-Constraint implizierter UNIQUE-Constraint sein.)
-- insert into scm.angestellte (ahvnr, vor_name, nach_name, lohn, ausb)
--   values ('756.1234.5678.97', 'max', 'muster', 950, 'mpa');
-- ERROR:  duplicate key value violates unique constraint "angestellte_ahvnr_key"
-- DETAIL:  Key (ahvnr)=(756.1234.5678.97) already exists.
--
-- Dies sollte ja erwartungsgemäss nicht möglich sein. Kommentieren Sie die Tests daher nach den Versuchen aus, so dass ihre Skripte nach wie vor fehlerfrei ausführbar sind.
