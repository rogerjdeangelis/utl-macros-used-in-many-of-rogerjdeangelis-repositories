%macro utl_rtfcombine(inpath= ,outpath= ,outfile= );

    *Get rtf file names from a folder;

    data rtffiles(keep=fileloc fnm);
       length fref $8 fnm $80 fileloc $400;

       rc = filename(fref,"&inpath");
       if rc = 0 then did = dopen(fref);

       dnum = dnum(did);

       do i = 1 to dnum;
          fnm = dread(did, i);
          fid = mopen(did, fnm);
          if fid > 0 and index(fnm,"rtf") then do;
             fileloc="&inpath/"||left(trim(fnm));
             fnm = strip(tranwrd(fnm,".rtf",""));
             output;
          end;
       end;

       rc = dclose(did);
    run;

    *Sort rtf files by tfl number;
    data rtffiles(keep= fileloc ord tflno);
       length tflno $200 ;
       set rtffiles;

       if index(fnm,"_t_") then ord = 1;
       else if index(fnm,"_f_") then ord = 2;
       else if index(fnm,"_l_") then ord = 3;

       tflno = strip(tranwrd(fnm,".rtf",""));
    run;

    proc sort data = rtffiles;
       by ord tflno;
    run;

    *Create macro variable which contains all rtf files;
    proc sql noprint;
        select
           quote(strip(fileloc))
        into
           :rtffiles separated by ", "
        from
           rtffiles;
    quit;

    filename rtffiles (&rtffiles); * create filename rtffiles ###;

    *Start;
    proc sql noprint;
        select
           fileloc into :fileloc
        from
           rtffiles(obs = 1);
    quit;

    data start;

        length rtfcode $32767;
        infile "&fileloc" lrecl = 32767 end = eof;
        input ;
        rtfcode = _infile_;

       retain kpfl strfl;

       if substr(rtfcode,1,6)="\sectd" then kpfl=1;
       if index(rtfcode, "\paperw") and index(rtfcode,"\paperh") then delete;
       if kpfl = . then output start;

    run;

    *data rtf;
    data rtf(keep = rtfcode);
        length rtfcode $32767 tflnam $1000;
        set rtffiles end=last;
        sof+1;

        retain kpfl ;

        do until (eof);
              infile rtffiles lrecl=32767 end=eof filevar=fileloc;
            input;
            rtfcode=_infile_;

            *Remove RTF header section and replce \sectd with \pard\sect\sectd;
            if sof then kpfl=.;
            if substr(rtfcode,1,6)="\sectd" then do;
               num+1;
               kpfl=1;
               if num = 1 then rtfcode=compress(tranwrd(rtfcode,"\pgnrestart\pgnstarts1",""));
                else rtfcode="\pard\sect"||compress(tranwrd(rtfcode,"\pgnrestart\pgnstarts1",""));
            end;

            *Remove RTF closing } except for last file;
            if eof and not last then delete;

            if kpfl=1 then output rtf;
            sof=0;
        end;
    run;

    data _null_;
        file "&outpath/&outfile..rtf" lrecl=32767 nopad;
        set start rtf; *concatenate rtf header,document info, all rtf files;
        put rtfcode;
    run;

%mend utl_rtfcombine;

%utl_rtfcombine(
    inpath  = d:/rtfinp   /* input folder with mutiple rtf files  */
   ,outpath = d:/rtfout
   ,outfile = male_female_all
);


