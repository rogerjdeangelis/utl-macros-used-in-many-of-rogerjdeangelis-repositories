%macro aip/cmd des="Read ai results from clipboard and format result for ms word d:/txt/search#.txt";
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
        request=catx(" ",request,_infile_,"~{newline}");
        keep name request;
        if eof then do;
           output;
           call symputx("name",name);
        end;
      run;quit;
      %utlfkil(d:/pdf/&name..pdf);
      ods escapechar="~";
      title;
      footnote;
      ods listing close;
      options orientation=landscape;
      ods pdf file="d:/pdf/&name..pdf";
      proc report data=preprocess style=journal noheader;
      cols
          name
          request
          ;
      define Name   / group "Name"  noprint width=80 flow style(column)={just=left font_size=15pt font_weight=bold};
      define Request  / order "Request"  width=132 flow style(column)={vjust=top font_size=12pt};
      break after name / page style={just=left};
      compute before name / style={just=left font_weight=bold font_size=15pt };
       line name $200.;
       skp="09"x;
       line skp $2.;
      endcomp;
      run;quit;
      ods pdf close;
      ods listing;
   ));
%mend aip;
