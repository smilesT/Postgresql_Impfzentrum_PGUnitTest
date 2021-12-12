--trigger, has to come before first inserts on lager_entnahme
--drop function if exists trigfun_impf cascade;
create function scm.trigfun_impf ()
  returns trigger
  language 'plpgsql'
  as $$
declare
  _impfdat_1 scm.patient.impfdat_1%type;
  _impfdosis_1 scm.patient.impfdosis_1%type;
  _impfdat_2 scm.patient.impfdat_2%type;
  _impfdosis_2 scm.patient.impfdosis_2%type;
begin
  select
    impfdat_1,
    impfdosis_1,
    impfdat_2,
    impfdosis_2 into _impfdat_1,
    _impfdosis_1,
    _impfdat_2,
    _impfdosis_2
  from
    scm.patient
  where
    id_pat = new.id_pat;
  if _impfdosis_1 is null then
    update
      scm.patient
    set
      impfdat_1 = new.entnahme_ts,
      impfdosis_1 = new.id_dosis
    where
      scm.patient.id_pat = new.id_pat;
  elsif _impfdosis_1 is not null
      and _impfdosis_2 is null then
      update
        scm.patient
      set
        impfdat_2 = new.entnahme_ts,
        impfdosis_2 = new.id_dosis
      where
        scm.patient.id_pat = new.id_pat;
  else
    raise notice 'something strange happend, this should never be reached! (assuming only 2 vaccinations per client)';
  end if;
  return new;
end
$$;

--drop trigger if exists trig_impf on lager_entnahme;
create trigger trig_impf
  before insert on scm.lager_entnahme for each row
  execute procedure scm.trigfun_impf ();

--drop function if exists ahv_check cascade;
-- . = 4, 9, 14
-- e = 1, 3, 6, 8, 11, 13
-- o = 2, 5, 7, 10, 12, 15
-- 756.1234.5678.97
create function scm.ahv_check (char(16))
  returns bool
  as $$
declare
  ahv alias for $1;
  cnt int;
  dots int = 0;
  adot char = '.';
  tmp int;
  tmp2 char;
  even_sum int = 0;
  odd_sum int = 0;
  checksum int;
  countrycode int;
begin
  select
    substr(ahv, 0, 4) into countrycode;
  if countrycode <> 756 then
    raise notice 'AHVINFO: countrycode % is not the code for switzerland', countrycode;
  end if;
  for cnt in 1..16 loop
    --dots
    if cnt = 4 or cnt = 9 or cnt = 14 then
      select
        substr(ahv, cnt, 1)::char into tmp2;
      if tmp2 = adot then
        dots = dots + 1;
      end if;
      --even
    elsif cnt = 1
        or cnt = 3
        or cnt = 6
        or cnt = 8
        or cnt = 11
        or cnt = 13 then
        select
          substr(ahv, cnt, 1)::int into tmp;
      even_sum = even_sum + tmp;
      --odd
    elsif cnt = 2
        or cnt = 5
        or cnt = 7
        or cnt = 10
        or cnt = 12
        or cnt = 15 then
        select
          substr(ahv, cnt, 1)::int into tmp;
      odd_sum = odd_sum + (3 * tmp);
      --checknumber
    else
      select
        substr(ahv, 16, 1)::int into tmp;
      checksum = tmp;
    end if;
  end loop;
  tmp = (10 - ((even_sum + odd_sum) % 10)) % 10;
  if tmp = checksum and dots = 3 then
    return true;
  else
    raise notice 'AHVINFO: ahv check returns false for: %; the correct checksum shoud be: %', ahv, tmp;
    return false;
  end if;
end
$$
language plpgsql;
