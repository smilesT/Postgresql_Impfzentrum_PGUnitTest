--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--
--Other examples, uncommentet, mostly scratch
select
  vor_name as "ang.vorname",
  nach_name as "ang.nachname",
  lohn as "ang.lohn"
from
  scm.angestellte
where
  lohn > 1000
order by
  nach_name asc;

select
  scm.impfdosis_lager.id_dosis,
  scm.impfdosis_lager.eingangsdatum,
  scm.impfdosis_lager.ablaufdatum,
  scm.lager_entnahme.id_ang,
  scm.lager_entnahme.id_pat,
  scm.lager_entnahme.entnahme_ts
from
  scm.impfdosis_lager
  inner join scm.lager_entnahme on scm.impfdosis_lager.id_dosis = scm.lager_entnahme.id_dosis
order by
  scm.lager_entnahme.entnahme_ts desc
limit 5;

with dosis_patient_zuordnung_impfung as (
  select
    pat.id_pat,
    pat.vor_name,
    pat.nach_name,
    pat.impfdat_1,
    pat.impfdat_2,
    scm.lager_entnahme.id_dosis
  from
    scm.patient as pat
    inner join scm.lager_entnahme on pat.id_pat = scm.lager_entnahme.id_pat
  where
    pat.impfdat_1 = scm.lager_entnahme.entnahme_ts
    or pat.impfdat_2 = scm.lager_entnahme.entnahme_ts
  order by
    pat.id_pat asc
)
select
  *
from
  dosis_patient_zuordnung_impfung;

with dosis_patient_zuordnung_impfung_per_impfung as (
  select
    pat.id_pat,
    pat.vor_name,
    pat.nach_name,
    pat.impfdat_1 as "impfdat",
    scm.lager_entnahme.id_dosis
  from
    scm.patient as pat
    inner join scm.lager_entnahme on pat.id_pat = scm.lager_entnahme.id_pat
  where
    pat.impfdat_1 = scm.lager_entnahme.entnahme_ts
  union
  select
    pat.id_pat,
    pat.vor_name,
    pat.nach_name,
    pat.impfdat_2 as "impfdat",
    scm.lager_entnahme.id_dosis
  from
    scm.patient as pat
    inner join scm.lager_entnahme on pat.id_pat = scm.lager_entnahme.id_pat
  where
    pat.impfdat_2 = scm.lager_entnahme.entnahme_ts
)
select
  *
from
  dosis_patient_zuordnung_impfung_per_impfung;

--cross-join (one left to all right)
--each to each aka. cartesian product, no chech on pk
select
  *
from
  scm.reservierung;

-- select * from scm.patient, scm.reservierung;
-- select
--   scm.patient.id_pat,
--   scm.reservierung.id_pat
-- from
--   scm.patient
--   cross join scm.reservierung;
--inner join on (inner not needed)
--row match, if not -> line no presented
select
  scm.patient.id_pat,
  scm.patient.nach_name,
  scm.reservierung.id_pat,
  scm.reservierung.datum,
  scm.reservierung.zeit
from
  scm.patient
  join scm.reservierung on scm.patient.id_pat = scm.reservierung.id_pat;

--natural join
--compare cols with name
select
  *
from
  scm.patient
  natural join scm.reservierung
where
  scm.reservierung.datum > '2021-11-06';

--left/right join
select
  *
from
  scm.patient
  right outer join scm.reservierung on scm.patient.id_pat = scm.reservierung.id_pat;

--full outer join
--zeigt alle scm.patienten an, egal ob impftermin oder nicht
select
  scm.patient.id_pat,
  scm.patient.nach_name,
  scm.reservierung.datum,
  scm.reservierung.zeit
from
  scm.patient
  full outer join scm.reservierung on scm.patient.id_pat = scm.reservierung.id_pat;

--lateral-joins
select
  *
from
  scm.lager_entnahme
  left outer join lateral (
  select
    min(lohn) lohn
  from
    scm.angestellte
  where
    scm.angestellte.id_ang = scm.lager_entnahme.id_ang) as tmp on true;

--impfcount
drop view if exists efficiency_ang cascade;

create view efficiency_ang as select distinct
  id_ang,
  vor_name,
  nach_name,
  coalesce(cc::int, 0) as cnt
from
  scm.angestellte as ang
  left outer join lateral (
  select
    count(*) over (partition by id_ang) as "cc"
  from
    scm.lager_entnahme
  where
    ang.id_ang = scm.lager_entnahme.id_ang) as efficiency_join_angestellte on true
order by
  ang.nach_name;

select
  *
from
  efficiency_ang;

-- Has to fail:
--
-- start transaction;
-- update efficiency_ang set cnt=99 where id_ang = 1002;
-- rollback;
-- Read-only user
-- revoke create on schema public from public;
-- create role readOnlyUser with login encrypted password 'encPW123' noinherit;
-- grant select on all tables in schema public to readOnlyUser;
-- -- scm.angestellter
-- revoke create on schema public from public;
-- create role scm.angestellter with login encrypted password 'ang123' noinherit;
-- grant insert on public.scm.lager_entnahme to scm.angestellter;
-- -- super angestelter
-- revoke create on schema public from public;
-- create role superScm.Angestellter with login encrypted password 'superang123' noinherit;
-- grant select, insert, update on public.scm.reservierung to superScm.Angestellter;
-- grant select, insert, update on public.scm.lager_entnahme to superScm.Angestellter;
-- grant select, insert, update on public.scm.patient to superScm.Angestellter;
-- -- trusted authority
-- revoke create on schema public from public;
-- create role goddess with login encrypted password '42isAnswer' noinherit;
-- grant all privileges on database impfproj to goddess;
--
--
--
-- Isolation Levels example
--
-- GUC variablen -> versch. conf. levels je nach state (config, session, on transaction begin)
-- set role angproj;
-- PSQL Variablen: \set etc. (nur innerhalb psql )
-- Isolation Levels
-- SET TRANSACTION ISOLATION LEVEL (READ COMMITED)
-- READ UNCOMMITTED; COMMITED (default);
-- REPEATABLE READ
-- SERIALIZABLE
-- Snapshot Isolation
-- Tradeoff Korrektheit <-> Parallelität
-- begin transaction;
-- set transaction isolation level read committed;
-- insert into update_view_1 (ahvnr, vor_name, nach_name, lohn)
--   values ('756.1001.1002.03', 'miles', 'admin', 2000);
-- rollback;
-- commit transaction;
-- select
--   *
-- from
--   scm.angestellte;
-- alter system set default_transaction_isolation = 'read committed';
-- mögliche fehlertypen:
-- - dirty read (read skew):
-- data of other trx, not committed allrdy
-- - fuzzy read
--
-- - phantom read
