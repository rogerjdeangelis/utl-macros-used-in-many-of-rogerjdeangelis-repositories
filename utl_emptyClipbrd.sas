%macro utl_emptyclipbrd/des="empty the sas clipbrd";
  %dosubl('
  filename _clp clipbrd;
  data _null_;
   file _clp;
   put;
  run;quit;
  filename _clp clear;;
');
%mend utl_emptyclipbrd;
