%macro utl_getcolumn(lib,dsn,col)
    /des="get variable attributes meta data";
/*---                  ---*/
/*--- OUTPUT MACRO     ---*/
/*--- VARIABLES        ---*/
/*---                  ---*/
/*---  _name           ---*/
/*---  _type           ---*/
/*---  _length         ---*/
/*---  _npos           ---*/
/*---  _varnum         ---*/
/*---  _label          ---*/
/*---  _format         ---*/
/*---  _informat       ---*/
/*---                  ---*/
  /*---
    %let lib=sashelp;
    %let dsn=class;
    %let col=sex;
  ---*/
   %global
     _memname
     _name
     _type
     _length
     _npos
     _varnum
     _label
     _format
     _informat ;
   %local
     memname
     name
     type
     length
     npos
     varnum
     label
     format
     informat /nowarn;
   %let dsid=%sysfunc(open(sashelp.vcolumn
     (where=(
          upcase("&lib") = upcase(libname)
      and upcase("&dsn") = upcase(memname)
      and upcase(name) = upcase("&col")
     ))
     ,i)) ;
   %syscall set(dsid);
   %let rc=%sysfunc(fetchobs(&dsid,1));
   %let rc=%sysfunc(close(&dsid));
   %let _memname        = %qtrim(&memname  );
   %let _name           = %qtrim(&name     );
   %let _type           = %qtrim(&type     );
   %let _length         = %qtrim(&length   );
   %let _npos           = %qtrim(&npos     );
   %let _varnum         = %qtrim(&varnum   );
   %let _label          = %qtrim(&label    );
   %let _format         = %qtrim(&format   );
   %let _informat       = %qtrim(&informat );
   %put ---- inside &=_memname ;
   %put ---- inside &=_name    ;
   %put ---- inside &=_type    ;
   %put ---- inside &=_length  ;
   %put ---- inside &=_npos    ;
   %put ---- inside &=_varnum  ;
   %put ---- inside &=_label   ;
   %put ---- inside &=_format  ;
   %put ---- inside &=_informat;
%mend utl_getcolumn;
