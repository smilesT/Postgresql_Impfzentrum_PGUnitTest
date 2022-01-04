/*
 * Test the other functions (with pgunit from buchli)
 */
/*
 * Dummy PGUnit Test
 */
create function test_case_pgunit_integrity_check_true_is_true ()
  returns void
  as $$
begin
  perform
    pgunit.assertTrue (true);
  raise notice 'PGUnit_Info: True is True -> PGUnit works :)';
end;
$$
language plpgsql;

--@pgcorrect if assertTrue fails, the test does not! it throws invalid transaction termination...
create function test_case_pgunit_integrity_check_false_IsNot_True_not_Errnous ()
  returns void
  as $$
begin
  raise notice 'PGUnit_Info: Should fail not erroneous';
  perform
    pgunit.assertTrue (false);
end;
$$
language plpgsql;

--@pgcorrect implement
--not yet implemented
create function test_case_pgunit_integrity_check_false_Is_False ()
  returns void
  as $$
begin
  perform
    pgunit.assertFalse (false);
  raise notice 'PGUnit_Info: False is False -> PGUnit works :)';
end;
$$
language plpgsql;

create function test_case_pgunit_integrity_check_erroneous ()
  returns void
  as $$
begin
  perform
    pgunit.assertTrue ('a42');
  raise notice 'PGUnit_Info: False is False -> PGUnit works :)';
end;
$$
language plpgsql;

-- select
--   *
-- from
--   pgunit.run_suite ('pgunit_integrity');


create or replace function test_setup_angestellte() returns boolean as $$
declare
id int;
begin
select null into id;
return id is null;
end;
$$ language plpgsql;

create or replace function test_precondition_angestellte() returns boolean as $$
declare
ahvnr_t varchar;
ahv_begin_t varchar;
begin
select ahvnr into ahvnr_t from scm.angestellte  where id_ang = 1001;
select substr(ahvnr_t, 0, 4) into ahv_begin_t;
return ahvnr_t is not null and (ahv_begin_t = '756');
end;
$$ language plpgsql;

create or replace function test_case_angestellte_1() returns void as $$
begin
  perform
    pgunit.assertFalse (false);
end;
$$
language plpgsql;

create or replace function test_postcondition_angestellte() returns boolean as $$
declare
id int;
begin
select 2 into id;
return id is not null and (id = 2);
end;
$$ language plpgsql;

create or replace function test_teardown_angestellte() returns boolean as $$
declare
id int;
begin
select 3 into id;
return id is not null and (id = 2);
end;
$$ language plpgsql;

select
  *
from
  pgunit.run_suite ('angestellte');
/*
 * Real PGUnit Test
 */
--@pgcorrect if assertTrue fails, the test does not! it throws invalid transaction termination...
create or replace function test_case_ahv_checksum_true ()
  returns void
  as $$
declare
  num1 char(16);
  num2 char(16);
begin
  select
    '756.1234.5679.96' into num1;
  select
    '756.1234.5670.95' into num2;
  perform
    pgunit.assertTrue (scm.ahv_check (num1));
  perform
    pgunit.assertTrue (scm.ahv_check (num2));
end;
$$
language plpgsql;

--@todo implement checksum_false, number_notNull_forAll,
select
  *
from
  pgunit.run_suite ('ahv');


/*
 * Run all PGUnit Test
 */
-- select
--   *
-- from
--   pgunit.run_all ();
