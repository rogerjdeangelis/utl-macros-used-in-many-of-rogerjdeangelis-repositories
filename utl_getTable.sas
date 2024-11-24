%macro utl_getTable(sashelp,class)
    /des="get table attributes meta data";
/*--- OUTPUT MACRO VARIABLES
  _LIBNAME
  _MEMNAME
  _MEMTYPE
  _MEMLABEL
  _TYPEMEM
  _CRDATE
  _MODATE
  _NOBS
  _OBSLEN
  _NVAR
  _FILESIZE
  _DELOBS
  _NLOBS
  _NUM_CHARACTER
  _NUM_NUMERIC
---*/
 /*---
   for testing withou macro
   %let lib=sashelp;
   %let dsn=class;
 ---*/
  %global
     _libname
     _memname
     _memtype
     _memlabel
     _typemem
     _crdate
     _modate
     _nobs
     _obslen
     _nvar
     _filesize
     _delobs
     _nlobs
     _num_character
     _num_numeric ;
   %local
     libname
     memname
     memtype
     memlabel
     typemem
     crdate
     modate
     nobs
     obslen
     nvar
     filesize
     delobs
     nlobs
     num_character
     num_numeric ;
   %let dsid=%sysfunc(open(sashelp.vtable
     (where=(
          upcase("&lib") = upcase(libname)
      and upcase("&dsn") = memname)),i));
   %syscall set(dsid);
   %let rc=%sysfunc(fetchobs(&dsid,1));
   %let rc=%sysfunc(close(&dsid));
   %let _libname        = %qtrim(&libname      );
   %let _memname        = %qtrim(&memname      );
   %let _memtype        = %qtrim(&memtype      );
   %let _memlabel       = %qtrim(&memlabel     );
   %let _typemem        = %qtrim(&typemem      );
   %let _crdate         = %qtrim(&crdate       );
   %let _modate         = %qtrim(&modate       );
   %let _nobs           = %qtrim(&nobs         );
   %let _obslen         = %qtrim(&obslen       );
   %let _nvar           = %qtrim(&nvar         );
   %let _filesize       = %qtrim(&filesize     );
   %let _delobs         = %qtrim(&delobs       );
   %let _nlobs          = %qtrim(&nlobs        );
   %let _num_character  = %qtrim(&num_character);
   %let _num_numeric    = %qtrim(&num_numeric  );
   %put ---- inside &=_libname      ;
   %put ---- inside &=_memname      ;
   %put ---- inside &=_memtype      ;
   %put ---- inside &=_memlabel     ;
   %put ---- inside &=_typemem      ;
   %put ---- inside &=_crdate       ;
   %put ---- inside &=_modate       ;
   %put ---- inside &=_nobs         ;
   %put ---- inside &=_obslen       ;
   %put ---- inside &=_nvar         ;
   %put ---- inside &=_filesize     ;
   %put ---- inside &=_delobs       ;
   %put ---- inside &=_nlobs        ;
   %put ---- inside &=_num_character;
   %put ---- inside &=_num_numeric  ;
%mend utl_getTable;
