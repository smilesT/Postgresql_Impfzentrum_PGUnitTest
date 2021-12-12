do $$
begin
  /* Exceptions of type integrity_constraint_violation within this block
   * are intercepted and don't make the script fail.
   */
  -- Add a constraint:
  alter table scm.angestellte
    add constraint check_lohn check (lohn::numeric::float8 between 900 and 20000);
  -- Test the constraint:
  update
    scm.angestellte
  set
    lohn = 30000
  where
    id_ang = 1001;

  /* The UPDATE above fails, thereby making execution jump
   * into the EXCEPTION block below and causing a ROLLBACK
   * of all changes within the block so far,
   * incl. the addition of the constraint.
   */
  -- This exception is therefore never being raised:
  raise exception 'The constraint did not work.';
exception
  when integrity_constraint_violation then
    -- Swallow the exception, but do print out its error message:
    raise notice 'The constraint worked and made the UPDATE fail with message: %', SQLERRM;
end;

$$;

do $$
begin
  /* Exceptions of type integrity_constraint_violation within this block
   * are intercepted and don't make the script fail.
   */
  -- Add a constraint:
  alter table scm.patient
    add constraint check_impfreihenfolge check (impfdat_1 + interval '30 days' < impfdat_2);
  -- Test the constraint:
  update
    scm.patient
  set
    impfdat_1 = '2021-05-01'::date
  where
    id_pat = 8001;
  update
    scm.patient
  set
    impfdat_2 = '2021-05-03'::date
  where
    id_pat = 8001;

  /* The UPDATE above fails, thereby making execution jump
   * into the EXCEPTION block below and causing a ROLLBACK
   * of all changes within the block so far,
   * incl. the addition of the constraint.
   */
  -- This exception is therefore never being raised:
  raise exception 'The constraint did not work.';
exception
  when integrity_constraint_violation then
    -- Swallow the exception, but do print out its error message:
    raise notice 'The constraint worked and made the UPDATE fail with message: %', SQLERRM;
end;

$$;

do $$
begin
  /* Exceptions of type integrity_constraint_violation within this block
   * are intercepted and don't make the script fail.
   */
  -- Add a constraint:
  alter table scm.angestellte
    add constraint check_ahvnumber
    -- TODO check with regex format
    --CHECK ( select * from ahv_check(angestellte.ahvnr) = 1 );
    check (scm.ahv_check (ahvnr));
  -- Test the constraint:
  update
    scm.angestellte
  set
    ahvnr = '756.5485.8888.77'
  where
    id_ang = 1001;

  /* The UPDATE above fails, thereby making execution jump
   * into the EXCEPTION block below and causing a ROLLBACK
   * of all changes within the block so far,
   * incl. the addition of the constraint.
   */
  -- This exception is therefore never being raised:
  raise exception 'The constraint did not work.';
exception
  when integrity_constraint_violation then
    -- Swallow the exception, but do print out its error message:
    raise notice 'The constraint worked and made the UPDATE fail with message: %', SQLERRM;
end;

$$;

do $$
begin
  /* Exceptions of type integrity_constraint_violation within this block
   * are intercepted and don't make the script fail.
   */
  -- Add a constraint:
  alter table scm.angestellte
    add constraint check_ahvnumber
    -- TODO check with regex format
    --CHECK ( select * from ahv_check(angestellte.ahvnr) = 1 );
    check (scm.ahv_check (ahvnr));
  -- Test the constraint:
  update
    scm.angestellte
  set
    ahvnr = '157.5485.8888.77'
  where
    id_ang = 1001;

  /* The UPDATE above fails, thereby making execution jump
   * into the EXCEPTION block below and causing a ROLLBACK
   * of all changes within the block so far,
   * incl. the addition of the constraint.
   */
  -- This exception is therefore never being raised:
  raise exception 'The constraint did not work.';
exception
  when integrity_constraint_violation then
    -- Swallow the exception, but do print out its error message:
    raise notice 'The constraint worked and made the UPDATE fail with message: %', SQLERRM;
end;

$$;
