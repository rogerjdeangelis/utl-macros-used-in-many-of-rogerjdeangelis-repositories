%macro utl_mbegin;
%utlnopts; /*-- turn of the mant temp files that will be closed ----*/
%utl_close;
%utlopts;
%utlfkil(c:/temp/m_pgm.m);
%utlfkil(c:/temp/m_pgm.log);
filename ft15f001 "c:/temp/m_pgm.m";
%mend utl_mbegin;
