@echo off
>nul chcp 1252
psql -U postgres -v ON_ERROR_STOP=on -f 0_runAllScripts.sql
pause