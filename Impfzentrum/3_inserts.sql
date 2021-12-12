insert into scm.angestellte (ahvnr, vor_name, nach_name, lohn)
  values ('756.1234.5678.97', 'max', 'muster', 950), ('756.1234.5679.96', 'beatrix', 'beispiel', 950), ('756.1234.5579.97', 'carmen', 'specimen', 960), ('756.1111.1111.13', 'adam', 'binerfunden', 950), ('756.1111.1111.20', 'franz', 'fabulos', 950), ('756.1111.1331.22', 'hier', 'koennte', 1001), ('756.1111.1351.26', 'ihre', 'werbung-stehen', 1001);

--eine impfung, aber bei anderem impfzentrum, dafuer -1 als impfdosis_1 resp. impfdosis_2
insert into scm.patient (versnr, vor_name, nach_name, impfdat_1, impfdosis_1)
  values (222001, 'rahel', 'gesond', '2021-11-03'::date, -1);

insert into scm.patient (versnr, vor_name, nach_name)
  values (222002, 'fabrizio', 'binfit'), (222003, 'hermann', 'hanselmann'), (222004, 'adeltraut', 'fischermann'), (222005, 'p. franziskus', 'deraktuelle'), (222006, 'ti', 'holy'), (222007, 'herbert', 'chiffre');

insert into scm.reservierung (id_pat, datum, zeit)
  values (8007, '2021-11-05'::date, '08:00:00'::time), (8002, '2021-11-06'::date, '09:00:00'::time), (8003, '2021-11-06'::date, '10:00:00'::time), (8004, '2021-11-06'::date, '09:00:00'::time), (8005, '2021-11-06'::date, '11:00:00'::time), (8006, '2021-11-07'::date, '07:30:00'::time), (8001, '2021-12-10'::date, '10:00:00'::time);

insert into scm.impfdosis_lager (id_dosis, eingangsdatum, ablaufdatum)
  values (11170001, '2021-10-29'::date, '2021-12-30'::date), (11170002, '2021-10-29'::date, '2021-12-30'::date), (11170003, '2021-10-29'::date, '2021-12-30'::date), (11170004, '2021-10-29'::date, '2021-12-30'::date), (11170005, '2021-10-29'::date, '2021-12-30'::date), (11170006, '2021-10-29'::date, '2021-12-30'::date), (11170007, '2021-10-29'::date, '2021-12-30'::date), (11170008, '2021-10-29'::date, '2021-12-30'::date), (11170009, '2021-10-29'::date, '2021-12-30'::date);

insert into scm.lager_entnahme (id_dosis, id_pat, id_ang, entnahme_ts)
  values (11170001, 8007, 1001, '2021-11-05'::date), (11170002, 8002, 1003, '2021-11-06'::date), (11170003, 8003, 1003, '2021-11-06'::date), (11170004, 8004, 1003, '2021-11-06'::date), (11170005, 8005, 1005, '2021-11-06'::date), (11170006, 8006, 1005, '2021-11-07'::date), (11170007, 8001, 1001, '2021-12-10'::date);
