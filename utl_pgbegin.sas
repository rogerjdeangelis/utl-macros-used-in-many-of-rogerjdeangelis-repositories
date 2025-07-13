%macro utl_pgbegin;
%utlfkil(c:/temp/pg_pgm.sql);
%utlfkil(c:/temp/pg_pgmx.sql);
%utlfkil(c:/temp/pg_pgm.log);
filename ft15f001 "c:/temp/pg_pgm.sql";
%mend utl_pgbegin;
