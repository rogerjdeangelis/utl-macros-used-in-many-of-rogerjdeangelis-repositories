/* === Author's macro (from getFileExtension.sas) === */
%macro getFileExtension(pth);
  %qscan(&pth,-1,'.')
%mend getFileExtension;

/* === Caller: exercise getFileExtension on representative paths === */
%let ext_csv  = %getFileExtension(/data/raw/2024_inventory.csv);
%let ext_pdf  = %getFileExtension(report.pdf);
%let ext_sas  = %getFileExtension(/usr/local/programs/etl_step01.sas);
%let ext_dual = %getFileExtension(/x/y/archive.tar.gz);

data _null_;
  put "ext_csv=&ext_csv";
  put "ext_pdf=&ext_pdf";
  put "ext_sas=&ext_sas";
  put "ext_dual=&ext_dual";
run;
