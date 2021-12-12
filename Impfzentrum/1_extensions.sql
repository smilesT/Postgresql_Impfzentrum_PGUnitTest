/*
 * Extensions / PGUnit by Buchli
 */
-- https://github.com/geometalab/pgunit
-- pgunit as extension from lukas buchli
create extension pgunit;

--grant to normal user for later function testing
grant usage on schema pgunit to impfuser;
