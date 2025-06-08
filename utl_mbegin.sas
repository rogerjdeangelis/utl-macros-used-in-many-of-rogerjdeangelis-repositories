%macro utl_mbegin;
%utl_close;
%utlfkil(c:/temp/m_pgm.m);
%utlfkil(c:/temp/m_pgm.log);
filename ft15f001 "c:/temp/m_pgm.m";
%mend utl_mbegin;
