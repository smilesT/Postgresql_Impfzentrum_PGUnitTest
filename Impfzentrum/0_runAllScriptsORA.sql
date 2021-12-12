drop user impfuser cascade;

create user impfuser identified by
  impfzentrum;

grant dba to impfuser;

commit;

connect impfuser / impfzentrum;

-- create schema
@@ 2_schema.sql
-- insert data
@@ 3_inserts.sql
commit;

quit
