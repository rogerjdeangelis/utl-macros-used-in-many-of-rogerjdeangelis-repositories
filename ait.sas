%macro ait/cmd des="Read ai results from clipboard and format result for ms word d:/txt/search#.txt";
   %let _idx=&sysindex;
   %dosubl(%nrstr(
      filename clp clipbrd;
      data preprocess;
        length fyl $255 request $32756 idx name $16;
        retain request ;
        idx=symget("_idx");
        infile clp end=eof filename=fyl;
        name=cats("Search-",idx);
        input;
        request=catx(" ",request,_infile_,"0D0A"x);
        keep name request;
        if eof then do;
           output;
           call symputx("name",name);
        end;
      run;quit;
      %utlfkil(d:/txt/&name..txt);
      ods escapechar="~";
      title;
      footnote;
      ods listing file="d:/txt/&name..txt";
      options orientation=landscape ls=132 ps=255;
      proc report data=preprocess split=" " noheader;
      cols
          name
          request
          ;
      define Name   / group "Name"  noprint width=13;
      define Request  /order "Request"  flow width=100;
      break after name / page ;
      compute before name ;
       line name $200.;
       skp="09"x;
       line skp $2.;
      endcomp;
      run;quit;
      ods listing;
   ));
%mend ait;
