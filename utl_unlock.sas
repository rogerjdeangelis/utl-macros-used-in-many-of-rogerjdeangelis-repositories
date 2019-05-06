%macro utl_unlock(dsn)/des="convert b64 to binary zip file and unzip into work directory";

    %let zipPth=%sysfunc(pathname(work));

    /* %let dsn=class; */

    data _null_;

      length b64 $ 76 byte $ 1;

      /* We only deal with Base64 files with a max line length of 76 */
      infile "&zipPth./&dsn..lst" lrecl= 76 truncover length=b64length;
      input @1 b64 $base64X76.;
      if _N_=1 then putlog "NOTE: Detected Base64 Line Length of " b64length;
      file "&zipPth/&dsn..zip" recfm=F lrecl= 1;
      do i=1 to (b64length/4)*3;
        byte=byte(rank(substr(b64,i, 1)));
        put byte $char1.;
      end;
    run;

    filename inzip ZIP "&zipPth\&dsn..zip";
    filename mem "&zipPth\&dsn..sas7bdat";

    data _null_;

      infile inzip("&dsn..sas7bdat") lrecl=256 recfm=F length=length unbuf;
      file mem lrecl=256 recfm=N;

      input;
      put _infile_ $varying256. length;

    run;quit;

%mend utl_unlock;
