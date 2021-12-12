\echo
\conninfo
\echo
\echo -n 'client encoding: '
\encoding
\echo
set client_min_messages = ERROR;

-- Warning about Postgres superuser
\echo
\prompt 'ATTENTION! USER POSTGRES MUST BE PRESENT AS SUPERUSER FOR EXTENSION CREATION!! (\\q or Ctrl-C to abort)?' promptvar
:promptvar \encoding 'auto'
\set user impfuser
\set password '\'impfproj\''
\set database impfproj
\set promptvar ''
\prompt 'DROP USER [':user'] and DROP DATABASE [':database'] if existing (\\q or Ctrl-C to abort)?' promptvar
:promptvar drop database if exists :database;

drop user if exists :user;

\echo -------------------------------------
\echo passwort for user :user = :password
\echo -------------------------------------
\echo
\prompt 'CREATE USER [':user'] and DATABASE [':database'] (\\q or Ctrl-C to abort)?' promptvar
:promptvar create user :user with password :password;

create database :database with owner :user encoding 'UTF8';

-- \c :database :user --after extensions
-- specify encoding to match your files encoding, usually UTF8
-- valid values are: 'UTF8', 'LATIN1', 'WIN1252'
-- \encoding 'UTF8'
-- create extensions
\c :database postgres
\ir 1_extensions.sql
-- connect now as user, since extension needs superuser role
\c :database :user
\encoding 'UTF8'
-- create schema
\ir 2_schema.sql
-- create functions
\ir 2_functions.sql
-- insert data in slo-mo or use COPY for speedup
\ir 3_inserts.sql
--\ir 3_copy.sql
-- create primary keys, constraints, indexes
\ir 4_constraints.sql
\echo
\prompt 'Execute Queries (\\q or Ctrl-C to abort)?' promptvar
:promptvar
-- set client encoding for query results to auto
-- > adjust if the detected default is not what you want
-- valid values are: 'UTF8', 'LATIN1', 'WIN1252'
\encoding 'auto'
\set ECHO queries
-- query the database
\ir 5_queries.sql
\unset ECHO
-- demonstrate constraints in action
\ir 6_constraints_tests.sql
-- some tests to check functin integrity
\echo
\prompt 'Execute PGUnit-Tests (\\q or Ctrl-C to abort)?' promptvar
:promptvar \encoding 'auto'
\ir 7_function_tests.sql
