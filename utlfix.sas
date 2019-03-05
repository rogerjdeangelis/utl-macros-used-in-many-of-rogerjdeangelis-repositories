%macro utlfix(dum);
* fix frozen sas and restore to invocation ;
 dm "odsresults;clear;";
ods results off;
 options ls=171 ps=65;run;quit;
 ods listing;
 ods select all;
 ods excel close;
 ods graphics off;
 proc printto;run;
 goptions reset=all;
 endsubmit;
 endrsubmit;
 run;quit;
 %utlopts;

%mend utlfix;
