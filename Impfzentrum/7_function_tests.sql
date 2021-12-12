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

select
  *
from
  pgunit.run_suite ('pgunit_integrity');


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
