/* === Author's macro (from getFileWithoutExtension.sas) === */
%macro getFileWithoutExtension(pth);
  %qscan(&pth,-2,'./\')
%mend getFileWithoutExtension;

/* === Caller: exercise getFileWithoutExtension on representative paths === */
%let stem_unix = %getFileWithoutExtension(/data/raw/2024_inventory.csv);
%let stem_dos  = %getFileWithoutExtension(C:\reports\summary.pdf);
%let stem_sas  = %getFileWithoutExtension(/usr/local/programs/etl_step01.sas);

data _null_;
  put "stem_unix=&stem_unix";
  put "stem_dos=&stem_dos";
  put "stem_sas=&stem_sas";
run;
