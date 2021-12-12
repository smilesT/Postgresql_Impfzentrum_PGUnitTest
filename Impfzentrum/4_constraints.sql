/*
 * Fremdschluessel setzen
 */
alter table scm.lager_entnahme
  add constraint fk_entn_lager foreign key (id_dosis) references scm.impfdosis_lager (id_dosis) on delete cascade;

alter table scm.angestellte
  add constraint max_lohn_ang check (lohn::numeric::float8 between 900 and 20000);

alter table scm.patient
  add constraint impfreihenfolge_pat check (impfdat_1 + interval '30 days' < impfdat_2);

alter table scm.angestellte
  add constraint check_ahv_constr check (scm.ahv_check (ahvnr));
